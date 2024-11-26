import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_sdeng_api/client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// An exception thrown when there is a problem decoded the response body.
class FlutterSdengApiMalformedResponse implements Exception {
  /// {@macro flutter_sdeng_api_malformed_response}
  const FlutterSdengApiMalformedResponse({required this.error});

  /// The associated error.
  final Object error;
}

/// An exception thrown when an http request failure occurs.
class FlutterSdengApiRequestFailure implements Exception {
  /// {@macro flutter_sdeng_api_request_failure}
  const FlutterSdengApiRequestFailure({
    required this.message,
  });

  /// The associated response body.
  final String message;
}

/// A Dart API client for the Flutter News Example API.
class FlutterSdengApiClient {
  /// Create an instance of [FlutterSdengApiClient] that integrates
  /// with the remote API.
  ///
  FlutterSdengApiClient();

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<SdengUser> getUserData({required String userId}) async {
    final res = await _supabase
        .from('users')
        .select()
        .eq('id', userId)
        .single()
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return SdengUser.fromMap(res);
  }

  Future<SdengUser> updateUserData({
    required String userId,
    required String fullName,
    required String societyName,
    required String societyEmail,
    required String societyPhone,
    required String societyAddress,
    required String societyPiva,
  }) async {
    try {
      final user = await _supabase
          .from('users')
          .update({
            'full_name': fullName,
            'society_name': societyName,
            'society_email': societyEmail,
            'society_phone': societyPhone,
            'society_address': societyAddress,
            'society_piva': societyPiva,
          })
          .eq('id', userId)
          .single();

      return SdengUser.fromMap(user);
    } catch (err) {
      throw FlutterSdengApiRequestFailure(message: err.toString());
    }
  }

  Future<int> countTeams({required String userId}) async {
    return await _supabase
        .from('teams')
        .count()
        .eq('owner_id', userId)
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );
  }

  Future<int> countAthletes({required String userId}) async {
    return await _supabase
        .from('athletes')
        .count()
        .eq('owner_id', userId)
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );
  }

  Future<int> countNotes({required String userId}) async {
    return await _supabase
        .from('notes')
        .count()
        .eq('owner_id', userId)
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );
  }

  Future<int> countExpiredMedicals({required String userId}) async {
    return await _supabase
        .from('medical')
        .count()
        .lte('expire', DateTime.now())
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );
  }

  Future<int> countPayments({required String userId}) async {
    return await _supabase
        .from('payments')
        .count()
        .eq('owner_id', userId)
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );
  }

  /// Requests teams data.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
  Future<List<Team>> getTeams({int? limit}) async {
    final res =
        await _supabase.from('teams').select().limit(limit ?? 1000).catchError(
              (Object err) =>
                  throw FlutterSdengApiRequestFailure(message: err.toString()),
            );

    return Team.fromList(res);
  }

  /// Add a new team.
  ///
  /// Supported parameters:
  /// [name] - The name of the team to add.
  Future<Team> addTeam({
    required String name,
  }) async {
    final res = await _supabase
        .from('teams')
        .insert(Team.create(name: name))
        .select()
        .single()
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return Team.fromMap(res);
  }

  /// Delete a team.
  ///
  /// Supported parameters:
  /// [id] - The name of the team to add.
  Future<void> deleteTeam({
    required String id,
  }) async {
    if (await _supabase.from('athletes').count().eq('team_id', id) == 0) {
      await _supabase.from('teams').delete().eq('id', id).catchError(
            (Object err) =>
                throw FlutterSdengApiRequestFailure(message: err.toString()),
          );
    }
  }

  ///
  Future<Team> updateTeam({
    required String id,
    required String name,
  }) async {
    final res = await _supabase
        .from('teams')
        .update({
          'name': name,
        })
        .eq('id', id)
        .select()
        .single()
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return Team.fromMap(res);
  }

  /// Delete a team.
  ///
  /// Supported parameters:
  /// [id] - The name of the team to add.
  Future<int> countAthletesInTeam({
    required String id,
  }) async {
    final num =
        await _supabase.from('athletes').count().eq('team_id', id).catchError(
              (Object err) =>
                  throw FlutterSdengApiRequestFailure(message: err.toString()),
            );
    return num;
  }

  /// Get an athlete by his Id.
  ///
  /// Supported parameters:
  /// [id] - The name of the athlete to load.
  Future<Athlete> getAthleteFromId(String id) async {
    final res = await _supabase
        .from('athletes')
        .select()
        .eq('id', id)
        .single()
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    final athlete = Athlete.fromMap(res);
    return athlete;
  }

  Future<List<Athlete>> getAthletes({int? limit, int? offset}) async {
    final res = await _supabase
        .from('athletes')
        .select()
        .order('full_name', ascending: true)
        .limit(20)
        .range(offset ?? 0, offset ?? 0 + 20)
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return Athlete.fromList(res);
  }

  /// Get all athletes in a team.
  ///
  /// Supported parameters:
  /// [teamId] - The id of the team to load athletes.
  Future<List<Athlete>> getAthletesFromTeamId({
    required String teamId,
    int? limit,
  }) async {
    final res = await _supabase
        .from('athletes')
        .select()
        .eq('team_id', teamId)
        .order('full_name', ascending: true)
        .limit(limit ?? 9999)
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return Athlete.fromList(res);
  }

  ///
  ///
  /// Supported parameters:
  /// [teamId] - The id of the team.
  /// [fullName] - The full name of the athlete.
  /// [taxCode] - The tax code of the athlete.
  Future<Athlete> addAthlete({
    required String teamId,
    required String fullName,
    required String taxCode,
    String? email,
    String? phone,
    String? address,
    DateTime? birthdate,
  }) async {
    if (await _supabase.from('athletes').count().eq('tax_code', taxCode) != 0) {
      throw const FlutterSdengApiRequestFailure(
        message: 'Athlete already exists.',
      );
    }

    final res = await _supabase
        .from('athletes')
        .insert(
          Athlete.create(
            teamId: teamId,
            fullName: fullName,
            taxCode: taxCode,
            email: email,
            phone: phone,
            birthDate: birthdate,
            fullAddress: address,
          ),
        )
        .select()
        .single()
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return Athlete.fromMap(res);
  }

  ///
  Future<Athlete> updateAthlete({
    required String id,
    required String fullName,
    required String taxCode,
    required String? teamId,
    required DateTime? birthDate,
    required String? email,
    required String? phone,
    required String? fullAddress,
    required bool? archived,
    required String? paymentFormulaId,
  }) async {
    final res = await _supabase
        .from('athletes')
        .update({
          'full_name': fullName,
          'tax_code': taxCode,
          'team_id': teamId,
          'birth_date': birthDate?.toIso8601String(),
          'email': email,
          'phone': phone,
          'full_address': fullAddress,
          'archived': archived,
          'payment_formula_id': paymentFormulaId,
        })
        .eq('id', id)
        .select()
        .single()
        .catchError(
          (Object err) {
              throw FlutterSdengApiRequestFailure(message: err.toString());},
        );

    return Athlete.fromMap(res);
  }

  /// Get all athletes with essentials data.
  ///
  /// Supported parameters:
  /// * [limit] - The number of items to return.
  Future<List<Athlete>> getAthletesList({
    int? limit,
  }) async {
    final res = await _supabase
        .from('athletes')
        .select('id, full_name, tax_code')
        .order('full_name', ascending: true)
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return Athlete.fromList(res);
  }

  /// Delete an athlete.
  ///
  /// Supported parameters:
  /// [id] - The name of the athlete to delete.
  Future<void> deleteAthlete({
    required String id,
  }) async {
    await _supabase.from('athletes').delete().eq('id', id).catchError(
          (Object err) => print(err.toString()),
        );
  }

  Future<List<Athlete>> searchAthlete(String searchText) async {
    final res = await _supabase
        .from('athletes')
        .select()
        .ilike('full_name', '%$searchText%')
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return Athlete.fromList(res);
  }

  /// Get an athlete's parent.
  ///
  /// Return an empty parent if it doesn't exists.
  ///
  /// Supported parameters:
  /// [id] - The id of the athlete of which load the parent.
  Future<Parent> getParentFromAthleteId(String id) async {
    final res = await _supabase
        .from('parents')
        .select()
        .eq('athlete_id', id)
        .limit(1)
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    if (res.isEmpty) return Parent(athleteId: id);

    final parent = Parent.fromMap(res.first);
    return parent;
  }

  ///
  ///
  /// Supported parameters:
  /// [athleteId] - The id of the team.
  Future<Parent> addParent({
    required String athleteId,
  }) async {
    if (await _supabase.from('parents').count().eq('athlete_id', athleteId) !=
        0) {
      throw const FlutterSdengApiRequestFailure(
        message: 'Parent already exists.',
      );
    }

    final res = await _supabase
        .from('parents')
        .insert(
          Parent.create(
            athleteId: athleteId,
          ),
        )
        .select()
        .single()
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return Parent.fromMap(res);
  }

  /// Delete a parent.
  ///
  /// Supported parameters:
  /// [athleteId] - The id of the athlete with releted parent to delete.
  Future<void> deleteParent({
    required String athleteId,
  }) async {
    await _supabase
        .from('parents')
        .delete()
        .eq('athlete_id', athleteId)
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );
  }

  Future<Parent> updateParent({
    required String athleteId,
    required String? fullName,
    required String? email,
    required String? phone,
    required String? fullAddress,
  }) async {
    final res = await _supabase
        .from('parents')
        .update({
          'full_name': fullName,
          'email': email,
          'phone': phone,
          'full_address': fullAddress,
        })
        .eq('athlete_id', athleteId)
        .select()
        .single()
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return Parent.fromMap(res);
  }

  /// Requests medicals.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
  Future<List<Medical>> getMedicals({int? limit}) async {
    final res = await _supabase.from('medical').select('''
          *,
          athletes: athlete_id(full_name)
        ''').limit(limit ?? 1000).catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return Medical.fromList(res);
  }

  /// Requests medical of an athlete.
  ///
  /// Supported parameters:
  /// [athleteId] - The id of the athlete.
  Future<Medical?> getMedicalFromAthleteId({
    required String athleteId,
  }) async {
    final res = await _supabase.from('medical').select('''
          *,
          athletes: athlete_id(full_name)
        ''').eq('athlete_id', athleteId).limit(1).catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    if (res.isEmpty) return null;

    final medVisit = Medical.fromMap(res.first);
    return medVisit;
  }

  /// Requests expired medicals.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
  Future<List<Medical>> getExpiredMedicals({int? limit}) async {
    final res = await _supabase.from('medical').select('''
          *,
          athletes: athlete_id(full_name)
        ''').lte('expire', DateTime.now()).catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    if (res.isEmpty) return [];

    return Medical.fromList(res);
  }

  /// Requests expiring medicals.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
  Future<List<Medical>> getExpiringMedicals({int? limit}) async {
    final res = await _supabase
        .from('medical')
        .select('''
          *,
          athletes: athlete_id(full_name)
        ''')
        .gt('expire', DateTime.now())
        .lte('expire', DateTime.now().add(const Duration(days: 14)))
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    if (res.isEmpty) return [];

    return Medical.fromList(res);
  }

  /// Requests good medicals.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
  Future<List<Medical>> getGoodMedicals({int? limit}) async {
    final res = await _supabase
        .from('medical')
        .select('''
          *,
          athletes: athlete_id(full_name)
        ''')
        .gt('expire', DateTime.now().add(const Duration(days: 14)))
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    if (res.isEmpty) return [];

    return Medical.fromList(res);
  }

  /// Requests unknown medicals.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
  Future<List<Medical>> getUnknownMedicals({int? limit}) async {
    final res = await _supabase.from('medical').select('''
          *,
          athletes: athlete_id(full_name)
        ''').filter('expire', 'is', null).catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    if (res.isEmpty) return [];

    return Medical.fromList(res);
  }

  /// Add a new medical to an athlete.
  ///
  /// Supported parameters:
  /// [athleteId] - The id of the athlete.
  /// [type] - The medical type.
  /// [expire] - The future expiring date.
  Future<Medical> addMedical({
    required String athleteId,
    MedType? type,
    DateTime? expire,
  }) async {
    final res = await _supabase
        .from('medical')
        .insert(
          Medical.create(
            athleteId: athleteId,
            type: type,
            expirationDate: expire,
          ),
        )
        .select('''
          *,
          athletes: athlete_id(full_name)
        ''')
        .limit(1)
        .single()
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return Medical.fromMap(res);
  }

  /// Update an existing medical to an athlete.
  ///
  /// Supported parameters:
  /// [athleteId] - The id of the athlete.
  /// [type] - The medical type.
  /// [expire] - The future expiring date.
  Future<Medical> updateMedical({
    required String athleteId,
    required DateTime expire,
    required MedType medType,
  }) async {
    final res = await _supabase
        .from('medical')
        .update({
          'expire': expire.toIso8601String(),
          'type': medType == MedType.agonistic
              ? 'agonistic'
              : medType == MedType.not_agonistic
                  ? 'not_agonistic'
                  : 'not_required',
        })
        .eq('athlete_id', athleteId)
        .select('''
          *,
          athletes: athlete_id(full_name)
        ''')
        .single()
        .catchError((Object err) => print(err));

    return Medical.fromMap(res);
  }

  /// Requests payments.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
  /// * [offset] - The offset of the first result to return.
  Future<List<Payment>> getPayments({int? limit, int? offset}) async {
    final from = offset ?? 0;
    final to = from + 20;
    final res = await _supabase
        .from('payments')
        .select()
        .range(from, to)
        .limit(limit ?? 20)
        .order('created_at', ascending: false)
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return Payment.fromList(res);
  }

  /// Requests payments only from an athlete.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
  Future<List<Payment>> getPaymentsFromAthleteId({
    required String athleteId,
    int? limit,
  }) async {
    final res = await _supabase
        .from('payments')
        .select()
        .eq('athlete_id', athleteId)
        .limit(limit ?? 1000)
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return Payment.fromList(res);
  }

  /// Add a new payment.
  ///
  /// Supported parameters:
  /// [athleteId] - The id of the athlete who made payments.
  /// [cause] - The cause of the payment.
  /// [amount] - The total amount paid.
  /// [paymentType] -
  /// [paymentMethod] -
  Future<Payment> addPayment({
    String? athleteId,
    required String cause,
    required double amount,
    required PaymentType paymentType,
    required PaymentMethod paymentMethod,
  }) async {
    final res = await _supabase
        .from('payments')
        .insert(
          Payment.create(
            athleteId: athleteId,
            cause: cause,
            amount: amount,
            type: paymentType,
            method: paymentMethod,
          ),
        )
        .select()
        .single()
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return Payment.fromMap(res);
  }

  /// Delete a payment.
  ///
  /// Supported parameters:
  /// [id] - The name of the payment to delete.
  Future<void> deletePayment({
    required String id,
  }) async {
    await _supabase
        .from('payments')
        .delete()
        .eq('id', id)
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );
  }

  /// Requests payments.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
  /// * [offset] - The offset of the first result to return.
  Future<List<PaymentFormula>> getPaymentFormulas(
      {int? limit, int? offset}) async {
    final res = await _supabase
        .from('formulas')
        .select()
        .order('name', ascending: true)
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return PaymentFormula.fromList(res);
  }

  /// Requests payments.
  ///
  /// Supported parameters:
  /// [athleteId] - The id of the athlete.
  Future<PaymentFormula?> getPaymentFormulaFromAthleteId({
    required String athleteId,
  }) async {
    final formula = await _supabase
        .from('athletes')
        .select('payment_formula_id')
        .eq('id', athleteId)
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    final formulaId = formula.first['payment_formula_id'] as String?;
    if (formulaId == null) return null;

    final res = await _supabase
        .from('formulas')
        .select()
        .eq('id', formulaId)
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return PaymentFormula.fromMap(res.first);
  }

  /// Add a new payment.
  ///
  /// Supported parameters:
  Future<PaymentFormula> addPaymentFormula({
    required String name,
    required bool full,
    required num amount1,
    required DateTime date1,
    num? amount2,
    DateTime? date2,
  }) async {
    final res = await _supabase
        .from('formulas')
        .insert(
          PaymentFormula.create(
            name: name,
            full: full,
            quota1: amount1,
            date1: date1,
            quota2: amount2,
            date2: date2,
          ),
        )
        .select()
        .single()
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return PaymentFormula.fromMap(res);
  }

  ///
  Future<PaymentFormula> updatePaymentFormula({
    required String id,
    required String name,
    required bool full,
    required num? amount1,
    required num? amount2,
    required DateTime? date1,
    required DateTime? date2,
  }) async {
    final res = await _supabase
        .from('formulas')
        .update({
          'name': name,
          'full': full,
          'quota1': amount1,
          'date1': date1?.toIso8601String(),
          'quota2': amount2,
          'date2': date2?.toIso8601String(),
        })
        .eq('id', id)
        .select()
        .single()
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return PaymentFormula.fromMap(res);
  }

  /// Delete a payment formula.
  ///
  /// Supported parameters:
  /// [id] - The name of the payment formula to delete.
  Future<void> deletePaymentFormula({
    required String id,
  }) async {
    await _supabase.from('formulas').delete().eq('id', id).catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );
  }

  /// Get all notes.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
  Future<List<Note>> getNotes({int? limit}) async {
    final res = await _supabase
        .from('notes')
        .select()
        .limit(limit ?? 1000)
        .order('created_at')
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return Note.fromList(res);
  }

  /// Add a new notes.
  ///
  /// Supported parameters:
  /// [author] - Who made the note.
  /// [content] - The content of the note.
  Future<Note> addNote({
    required String author,
    required String content,
  }) async {
    final res = await _supabase
        .from('notes')
        .insert(
          Note.create(
            author: author,
            content: content,
          ),
        )
        .select()
        .catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return Note.fromMap(res.first);
  }

  /// Get the user personal folder in the online storage.
  Future<Bucket> getUserBucket() async {
    if (_supabase.auth.currentUser == null) {
      throw const FlutterSdengApiRequestFailure(
          message: 'User not authenticated. Cannot get user id.');
    }
    final userId = _supabase.auth.currentUser!.id;
    final bucket = await _supabase.storage
        .getBucket(userId)
        .catchError((Object err) async {
      final exception = err as StorageException;
      if (exception.statusCode == '404') {
        log('Bucket not found\nCreating bucket...');
        await _supabase.storage.createBucket(userId);
        log('Bucket created with id $userId');
      }
      return _supabase.storage.getBucket(userId);
    });

    return bucket;
  }

  /// Get the user personal folder in the online storage.
  Future<List<Document>> getDocumentsFromFolder({
    required String path,
  }) async {
    final documents = <Document>[];
    final bucket = await getUserBucket();
    final files = await _supabase.storage.from(bucket.id).list(path: path);

    for (final file in files) {
      documents.add(
        Document(
          name: file.name,
          path: '$path/${file.name}',
        ),
      );
    }
    return documents;
  }

  /// Uploads the file and returns the path
  ///
  /// Supported parameters
  /// [path] - Path of the file to be downloaded.
  /// [file] - The file to be uploaded.
  Future<String> uploadFile({
    required File file,
    required String path,
  }) async {
    final bucket = await getUserBucket();
    await _supabase.storage.from(bucket.id).upload(path, file).catchError(
          (Object err) =>
              throw FlutterSdengApiRequestFailure(message: err.toString()),
        );

    return path;
  }

  /// Download a file
  ///
  /// Supported parameters
  /// [path] - Path of the file to be downloaded.
  Future<Uint8List> downloadFile({required String path}) async {
    final bucket = await getUserBucket();
    log(path);
    final file = await _supabase.storage
        .from(bucket.id)
        .download(path)
        .catchError((Object err) {
      log(err.toString());
      throw FlutterSdengApiRequestFailure(message: err.toString());
    });

    return file;
  }

  /// Delete a file
  ///
  /// Supported parameters
  /// [path] - Path of the file to be downloaded.
  Future<void> deleteFile({required String path}) async {
    final bucket = await getUserBucket();
    await _supabase.storage
        .from(bucket.id)
        .remove([path]).catchError((Object err) {
      log(err.toString());
      throw FlutterSdengApiRequestFailure(message: err.toString());
    });
  }
}
