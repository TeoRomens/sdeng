import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/model/staff_member.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A class responsible for handling authentication-related operations.
class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _localAuth = LocalAuthentication();

  final _googleSignIn = GoogleSignIn(
      scopes: <String>[
        "email",
        "https://www.googleapis.com/auth/calendar"
  ]);

  /// Retrieves the currently signed-in Google account, if any.
  GoogleSignInAccount? get googleAccount => _googleSignIn.currentUser;

  /// Attempts to log in a user using their email and password.
  ///
  /// Given an [email] and a [password], this method attempts to sign in the user using
  /// Firebase Authentication. The password is encrypted before being used for authentication.
  /// Returns a [User] object if the login is successful.
  Future<User?> login(
      String email,
      String password,
  ) async {
      return await _auth.signInWithEmailAndPassword(email: email, password: encrypt(password))
          .then((value) => value.user);
  }

  /// Encrypts a given [string] using SHA-512 hashing.
  ///
  /// Given a [string], this method encodes it in UTF-8 and computes its SHA-512 hash.
  /// The resulting hash is returned as a string.
  String encrypt(String string) {
    var bytes = utf8.encode(string);
    var digest = sha512.convert(bytes);
    return digest.bytes.toString();
  }

  /// Signs up a staff member and creates a new user account in the authentication system.
  ///
  /// Given an [email], [password], and [staffMember] object, this method attempts to create a new
  /// user account using Firebase Authentication with the provided email and an encrypted password.
  /// The user's information, including staff member details, is also added to the Firestore database.
  ///
  /// Returns a [User] object if the signup is successful, or `null` if an error occurs.
  Future<User?> signupStaff(String email, String password, StaffMember staffMember) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: encrypt(password),
    ).then((value) async {
      // Create a user document in Firestore with staff member details.
      await FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .set({
        'name': staffMember.name,
        'surname': staffMember.surname,
        'email': email,
        'invoice': 0,
        'calendarId': '',
        'firstPaymentDate': Timestamp.fromDate(staffMember.closingPayDate1!),
        'secondPaymentDate': Timestamp.fromDate(staffMember.closingPayDate2!),
        'quotaUnder': staffMember.totalAmountUnder,
        'quotaMB': staffMember.totalAmountMB,
        'societyName': staffMember.societyName,
        'societyEmail': staffMember.societyEmail,
        'societyTaxId': staffMember.societyTaxId,
        'societyPIva': staffMember.societyPIva,
        'societyFipCode': staffMember.societyFipCode,
        'societyCity': staffMember.societyCity,
        'societyAddress': staffMember.societyAddress,
        'societyCap': staffMember.societyCap,
        'isStaff': true,
        });

      return value.user;
    });
  }


  /// Logs out the currently signed-in user and clears session-related variables.
  ///
  /// This method logs out the currently signed-in user by signing them out using Firebase Authentication.
  /// It also clears any session-related variables, such as the user's unique identifier.
  ///
  Future<void> logout() async {
    Variables.clear();

    // Sign out the user from Firebase Authentication.
    await _auth.signOut();

    // Sign out from the Google account, if signed in.
    await _googleSignIn.signOut();
  }


  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if(googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final List<String> providers = await _auth.fetchSignInMethodsForEmail(googleUser.email);
      if(providers.contains('google.com')) {
        // Once signed in, return the UserCredential
        log('Google provider found');
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        return userCredential.user;
      } else {
        throw FirebaseAuthException(code: 'missing-provider');
      }
    }
    return null;
  }

  Future<User?> authenticateWithBiometrics() async {
    try {
      if(!await hasBiometrics()) return null;
      bool result = await _localAuth.authenticate(localizedReason: 'Authenticate to login');
      log('Authentication using biometrics success!');
      if(!result) return null;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('email') ?? '';
      String password = prefs.getString('password') ?? '';
      return await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) => value.user);
    } catch (e) {
      log("Error using biometric auth: $e");
    }
    return null;
  }

  Future<bool> hasBiometrics() async {
    final isAvailable = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

  Future<void> setBiometrics(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('biometrics', value);
    Variables.biometrics = value;
  }

  Future<void> writeCredentials({required String email, required String password, required bool rememberme}) async {
    log('Writing credentials...');
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("remember_me", rememberme);
      prefs.setString('email', email);
      prefs.setString('password', password);
    });
    log('Writing credentials done!');
  }

  Future<void> writeGoogleCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _googleSignIn.currentUser!.email);
    prefs.setString('googleIdToken', _googleSignIn.serverClientId!);
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<bool> isStaff(String uid) async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid).get();

    return data.get('isStaff');
  }

  Future<bool> checkUserInDatabase(String uid) async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid).get();

    return data.exists;
  }

  Future<void> loadVariables(String uid) async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if(data.exists){
      Variables.uid = data.id;
      Variables.calendarId = data['calendarId'];
      Variables.quotaUnder = data['quotaUnder'];
      Variables.firstPaymentDate = data['firstPaymentDate'].toDate();
      Variables.secondPaymentDate = data['secondPaymentDate'].toDate();
    } else {
      throw Exception('Error fetching variables document');
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Variables.biometrics = prefs.getBool('biometrics') ?? false;
  }

  Future<void> deleteCurrentUser() async {
    try{
      await _auth.currentUser!.delete();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> linkGoogleAccount() async {
    //get currently logged in user
    final user = _auth.currentUser!;

    //get the credentials of the new linking account
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if(googleUser != null) {
     // Obtain the auth details from the request
     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
     // Create a new credential
     final credential = GoogleAuthProvider.credential(
       accessToken: googleAuth.accessToken,
       idToken: googleAuth.idToken,
     );

     await user.linkWithCredential(credential);
     return;
    }
  }

}