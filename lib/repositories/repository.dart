import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/model/medical.dart';
import 'package:sdeng/model/note.dart';
import 'package:sdeng/model/payment.dart';
import 'package:sdeng/model/profile.dart';
import 'package:sdeng/model/team.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Class that communicates with external APIs.
class Repository {
  /// Class that communicates with external APIs.
  Repository({
    required SupabaseClient supabaseClient,
    required FlutterSecureStorage localStorage,
  }) : _supabase = supabaseClient,
        _localStorage = localStorage {
    _setAuthListener();
  }

  final SupabaseClient _supabase;
  final FlutterSecureStorage _localStorage;

  static const _termsOfServiceAgreementKey = 'terms_of_service_agreed';
  static const _timestampOfLastSeenNotification = 'timestamp_last_seen_notification';

  // Local Cache
  final Map<String, Athlete> _mapAthletes = {};

  // Local Cache
  final Map<String, Team> _mapTeam = {};

  // Local Cache
  final Map<String, Medical> _mapMedical = {};

  // Local Cache
  final List<Payment> _listPayments = <Payment>[];

  // Local Cache
  final List<Note> _listNotes = <Note>[];

  /// Return userId or null
  String? get userId => _supabase.auth.currentUser?.id;

  /// Completes when auth state is known
  Completer<void> statusKnown = Completer<void>();

  /// Completer that completes once the logged in user's profile has been loaded
  Completer<void> myProfileHasLoaded = Completer<void>();

  /// The user's profile
  Profile? userProfile;

  /// Whether the user has agreed to terms of service or not
  Future<bool> get hasAgreedToTermsOfService =>
      _localStorage.containsKey(key: _termsOfServiceAgreementKey);

  /// Returns whether the user has agreed to the terms of service or not.
  Future<void> agreedToTermsOfService() =>
      _localStorage.write(key: _termsOfServiceAgreementKey, value: 'true');

  /// Resets all caches
  _resetCache() {
    _mapAthletes.clear();
    _mapMedical.clear();
    _mapTeam.clear();
    _listPayments.clear();
    _listNotes.clear();
  }

  void _setAuthListener() {
    _supabase.auth.onAuthStateChange.listen((authState) {
      if(authState.event == AuthChangeEvent.signedOut) {
        _resetCache();
      }
    });
  }

  /// Returns Access Token String
  Future<String> signup({
    required String email,
    required String password,
  }) async {
    final res = await _supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: 'io.teoromens.sdeng://login'
    );
    if (res.session == null) {
      throw PlatformException(code: 'signup error');
    }
    return res.session!.accessToken;
  }

  /// Returns Persist Session String
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final res = await _supabase.auth.signInWithPassword(email: email, password: password);
    if (res.session == null) {
      throw PlatformException(code: 'login error');
    }
    return res.session!.accessToken;
  }

  Future<void> forgotPassword({
    required String email
  }) async {
    await _supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: 'io.teoromens.sdeng://login'
    );
  }

  Future<AuthResponse> googleLogin() async {
    /// Web Client ID that you registered with Google Cloud.
    const webClientId = '424833225652-s9n3jlj2q6fkdeo95234e8hjcp1iiv48.apps.googleusercontent.com';
    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId = '424833225652-ehsmi8dg6fmu6j4tgssjkl8q5hnf33hj.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the
    // Android Client ID registered on Google Cloud.
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  /// Get the logged in user's profile.
  Future<Profile?> getMyProfile() async {
    if (userProfile != null) {
      return userProfile;
    }
    final userId = this.userId;
    if (userId == null) {
      throw PlatformException(code: 'not signed in ', message: 'Not signed in');
    }
    try {
      final res = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      final profile = Profile.fromMap(res);

      if (!myProfileHasLoaded.isCompleted) {
        myProfileHasLoaded.complete();
      }
      if (!statusKnown.isCompleted) {
        statusKnown.complete();
      }
      return profile;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  /// Get a team from his id.
  Future<Team> loadTeamFromId(String id) async {
    if (_mapTeam[id] != null) {
      return _mapTeam[id]!;
    }
    final res = await _supabase
        .from('teams')
        .select()
        .eq('id', id)
        .limit(1)
        .single()
        .onError((error, stackTrace) =>
          throw PlatformException(code: 'getTeamFromId', message: 'error getting team by id')
    );

    final team = Team.fromMap(res);
    _mapTeam[team.id] = team;
    return team;
  }

  /// Get all teams.
  Future<Map<String, Team>> loadTeams() async {
    final res = await _supabase
        .from('teams')
        .select()
        .onError((error, stackTrace) =>
          throw PlatformException(code: 'loadAthletes')
        );

    Team.fromList(res).forEach((team) => _mapTeam[team.id] = team);
    return _mapTeam;
  }

  ///
  Future<Team> addTeam({
    required String name,
  }) async {
    final check = await _supabase
        .from('teams')
        .select('id')
        .eq('name', name)
        .count();
    if(check.count > 0) {
      throw PlatformException(code: 'invalid_name', message: 'Name already used');
    }
    final res = await _supabase
        .from('teams')
        .insert(Team.create(name: name))
        .select()
        .single();

    if (res.isEmpty) {
      throw PlatformException(
        code: 'add_team',
        message: 'error adding new team',
      );
    }
    _mapTeam[res['id']] = Team.fromMap(res);
    return res['id'];
  }

  /// Get an athlete from his id.
  Future<Athlete> loadAthleteFromId(String id) async {
    if (_mapAthletes[id] != null) {
      return _mapAthletes[id]!;
    }
    final res = await _supabase
        .from('athletes')
        .select()
        .eq('id', id)
        .limit(1)
        .single();

    if (res.isEmpty) {
      throw PlatformException(code: 'getAthleteFromId error');
    }

    final athlete = Athlete.fromMap(res);
    _mapAthletes[athlete.id] = athlete;
    return athlete;
  }

  /// Get all athletes.
  Future<Map<String, Athlete>> loadAthletes() async {
    final res = await _supabase
        .from('athletes')
        .select()
        .onError((error, stackTrace) =>
          throw PlatformException(code: 'loadAthletes')
    );
    Athlete.fromList(res).forEach((athlete) => _mapAthletes[athlete.id] = athlete);
    return _mapAthletes;
  }

  Future<String> addAthlete({
    required String teamId,
    required String fullName,
    required String taxCode,
  }) async {
    final res = await _supabase
        .from('athletes')
        .insert(Athlete.create(
          teamId: teamId,
          fullName: fullName,
          taxCode: taxCode
        ))
        .select()
        .single();

    if (res.isEmpty) {
      throw PlatformException(
        code: 'add athlete',
        message: 'error adding new athlete',
      );
    }
    _mapAthletes[res['id']] = Athlete.fromMap(res);
    return res['id'];
  }

  Future<void> editAthlete({
    required String id,
    String? fullName
    // Add all other fields
  }) async {
    final res = await _supabase
        .from('athletes')
        .update({
            'full_name': fullName,
        })
        .eq('id', id)
        .select()
        .single()
        .onError((error, stackTrace) =>
          throw PlatformException(
              code: 'editAthlete',
            message: error.toString(),
            stacktrace: stackTrace.toString()
          ));

    _mapAthletes[res['id']] = Athlete.fromMap(res);
  }

  /// Get all medical visits.
  Future<Map<String, Medical>> loadMedicals() async {
    final res = await _supabase
        .from('medical')
        .select()
        .onError((error, stackTrace) =>
          throw PlatformException(code: 'loadAthletes')
        );

    Medical.fromList(res).forEach((medical) =>
        _mapMedical[medical.athleteId] = medical);

    return _mapMedical;
  }

  Future<Medical> loadMedVisitFromAthleteId(String id) async {
    if(_mapMedical[id] != null) {
      return _mapMedical[id]!;
    }
    final res = await _supabase
        .from('medical')
        .select()
        .eq('athlete_id', id)
        .single()
        .onError((error, stackTrace) =>
            throw PlatformException(
                code: 'loadMedical',
                message: error.toString(),
                stacktrace: stackTrace.toString()
        ));

    final medVisit = Medical.fromMap(res);
    _mapMedical[medVisit.athleteId] = medVisit;
    return medVisit;
  }

  Future<List<Medical>> loadExpiredMedVisits() async {
    final res = await _supabase
        .from('medical')
        .select('''
          *,
          athletes: athlete_id(full_name)
        ''')
        .gt('expiration_date', DateTime.now())
        .lte('expiration_date', DateTime.now().add(const Duration(days: 14)));

    final meds = Medical.fromList(res).map((medical) =>
        _mapMedical[medical.athleteId] = medical).toList();

    return meds;
  }

  Future<List<Medical>> loadOkMedVisits() async {
    final res = await _supabase
        .from('medical')
        .select('''
          *,
          athletes: athlete_id(full_name)
        ''')
        .gt('expiration_date', DateTime.now().add(const Duration(days: 14)));

    final meds = Medical.fromList(res).map((medical) =>
        _mapMedical[medical.athleteId] = medical).toList();

    return meds;
  }

  Future<List<Medical>> loadUnknownMedVisits() async {
    final res = await _supabase
        .from('medical')
        .select('''
          *,
          athletes: athlete_id(full_name)
        ''')
        .filter('expiration_date', 'is', null);

    final meds = Medical.fromList(res).map((medical) =>
        _mapMedical[medical.athleteId] = medical).toList();

    return meds;
  }

  /// Get all payments.
  Future<List<Payment>> loadPayments() async {
    final res = await _supabase
        .from('payments')
        .select()
        .onError((error, stackTrace) =>
          throw PlatformException(code: 'loadAthletes')
        );

    _listPayments.clear();
    _listPayments.addAll(Payment.fromList(res));

    return _listPayments;
  }

  Future<List<Payment>> loadPaymentsFromAthleteId(String id) async {
    //TODO: maybe implement cache
    final res = await _supabase
        .from('payments')
        .select()
        .eq('athlete_id', id)
        .onError((error, stackTrace) =>
          throw PlatformException(
              code: 'loadMedical',
              message: error.toString(),
              stacktrace: stackTrace.toString()
        ));

    final paymentList = Payment.fromList(res);
    //_listPayments.addAll(paymentList);
    return paymentList;
  }

  /// Updates a profile of logged in user.
  Future<void> saveProfile({required Profile profile}) async {
    await _supabase
        .from('users')
        .update(profile.toMap())
        .eq('id', profile.id)
        .catchError(
            () => throw PlatformException(
          code: 'Database_Error',
          message: 'Error occurred while saving profile',
        ));
  }

  /// Uploads the file and returns the download URL
  Future<String> uploadFile({
    required String bucket,
    required File file,
    required String path,
  }) async {
    await _supabase
        .storage
        .from(bucket)
        .upload(path, file)
        .onError((error, stackTrace) {
          throw PlatformException(
            code: 'uploadFile',
            message: error.toString(),
          );
    });

    final urlRes = _supabase
        .storage
        .from(bucket)
        .getPublicUrl(path);

    return urlRes;
  }

  /*
  /// Loads the 50 most recent notifications.
  Future<void> getNotifications() async {
    if (userId == null) {
      // If the user is not signed in, do not emit anything
      return;
    }
    final res = await _supabaseClient
        .from('notifications')
        .select()
        .eq('receiver_user_id', userId)
        .not('action_user_id', 'eq', userId)
        .order('created_at')
        .limit(50)
        .execute();
    final data = res.data;
    final error = res.error;
    if (error != null) {
      throw PlatformException(
        code: error.code ?? 'getNotifications',
        message: error.message,
      );
    }
    final timestampOfLastSeenNotification =
    await _localStorage.read(key: _timestampOfLastSeenNotification);
    DateTime? createdAtOfLastSeenNotification;
    if (timestampOfLastSeenNotification != null) {
      createdAtOfLastSeenNotification =
          DateTime.parse(timestampOfLastSeenNotification);
    }
    _notifications = AppNotification.fromData(data,
        createdAtOfLastSeenNotification: createdAtOfLastSeenNotification);
    _notificationsStreamController.sink.add(_notifications);

    Future<AppNotification> _replaceCommentTextWithMentionedUserName(
        AppNotification notification,
        ) async {
      if (notification.commentText == null) {
        return notification;
      }
      final commentText =
      await replaceMentionsWithUserNames(notification.commentText!);
      return notification.copyWith(commentText: commentText);
    }

    _notifications = await Future.wait(
        _notifications.map(_replaceCommentTextWithMentionedUserName));
    _notificationsStreamController.sink.add(_notifications);
  }
  */


  /// Performs a keyword search of videos.
  Future<List<Athlete>> searchAthlete(String searchText) async {
    final query = searchText.split(' ').map((word) => "%$word%").join('');

    final res = await _supabase
        .from('athletes')
        .select()
        .ilike('full_name', query)
        .onError((error, stackTrace) {
          throw PlatformException(
            code: 'search',
            message: error.toString(),
            stacktrace: stackTrace.toString()
          );
        }
    );
    return Athlete.fromList(res);
  }

  /// Updates the timestamp of when the user has last seen notifications.
  ///
  /// Timestamp of when the user has last seen notifications is used to
  /// determine which notification is unread.
  Future<void> updateTimestampOfLastSeenNotification(DateTime time) async {
    await _localStorage.write(
        key: _timestampOfLastSeenNotification, value: time.toIso8601String());
  }

  /// Opens a share dialog to share the file with other apps.
  Future<void> shareFile(String bucket, String path) async {
    Uint8List file = await _supabase
        .storage
        .from(bucket)
        .download(path);

    await Share.shareXFiles([XFile.fromData(file)]);
  }

  /// Loads cached file.
  Future<File> getCachedFile(String url) {
    return DefaultCacheManager().getSingleFile(url);
  }

  Future<Payment> addPayment({
    required String athleteId,
    required String cause,
    required int amount,
    required PaymentType paymentType,
    required PaymentMethod paymentMethod,
  }) async {
    final res = await _supabase
        .from('payments')
        .insert(Payment.create(
            athleteId: athleteId,
            cause: cause,
            amount: amount,
            type: paymentType,
            method: paymentMethod))
        .select()
        .single()
        .onError((error, stackTrace) =>
          throw PlatformException(
          code: 'add_payment',
          message: 'error adding new payment',
          stacktrace: stackTrace.toString()
        ));

    _listPayments.add(Payment.fromMap(res));
    return Payment.fromMap(res);
  }

  /// Opens device's camera roll to find videos taken in the past.
  Future<File?> getVideoFile() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        return File(pickedImage.path);
      }
    } catch (err) {
      log(err.toString());
    }
    return null;
  }

}