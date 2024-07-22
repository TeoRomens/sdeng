import 'dart:async';

import 'package:authentication_client/authentication_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A base failure for the user repository failures.
abstract class UserFailure with EquatableMixin implements Exception {
  /// {@macro user_failure}
  const UserFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// Thrown when adding a team fails.
class UpdateUserDataFailure extends UserFailure {
  /// {@macro update_user_data}
  const UpdateUserDataFailure(super.error);
}

/// Repository which manages the user domain.
class UserRepository {
  /// {@macro user_repository}
  UserRepository({
    required AuthenticationClient authenticationClient,
    required FlutterSdengApiClient apiClient,
  })  : _authenticationClient = authenticationClient,
        _apiClient = apiClient;

  final AuthenticationClient _authenticationClient;
  final FlutterSdengApiClient _apiClient;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  Stream<User?> get user => _authenticationClient.user;

  SdengUser? _sdengUser;

  SdengUser? get sdengUser => _sdengUser;

  set sdengUser(SdengUser? value) {
    _sdengUser = value;
  }

  /// Fetch additional user data from the `users` table.
  Future<SdengUser> getUserData(String userId) async {
    sdengUser = await _apiClient.getUserData(userId: userId);
    return sdengUser!;
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
      sdengUser = await _apiClient.updateUserData(
        userId: userId,
        fullName: fullName,
        societyName: societyName,
        societyEmail: societyEmail,
        societyPhone: societyPhone,
        societyAddress: societyAddress,
        societyPiva: societyPiva,
      );
      return sdengUser!;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(UpdateUserDataFailure(error), stackTrace);
    }
  }


  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleCanceled] if the flow is canceled by the user.
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithGoogle() async {
    try {
      await _authenticationClient.logInWithGoogle();
    } on LogInWithGoogleFailure {
      rethrow;
    } on LogInWithGoogleCanceled {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithGoogleFailure(error), stackTrace);
    }
  }

  /// Starts the Sign In Flow.
  ///
  /// Throws a [LogInWithCredentialsFailure] if an exception occurs.
  Future<void> logInWithCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await _authenticationClient.logInWithCredentials(
        email: email,
        password: password,
      );
    } on LogInWithCredentialsFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithCredentialsFailure(error), stackTrace);
    }
  }

  /// Starts the Sign Up Flow.
  ///
  /// Throws a [SignUpWithCredentialsFailure] if an exception occurs.
  Future<void> signUpWithCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await _authenticationClient.signUpWithCredentials(
        email: email,
        password: password,
      );
    } on SignUpWithCredentialsFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignUpWithCredentialsFailure(error), stackTrace);
    }
  }

  /// Signs out the current user
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await _authenticationClient.logOut();
    } on LogOutFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogOutFailure(error), stackTrace);
    }
  }

  /// Starts the Forgot Password Flow.
  ///
  /// Throws a [ForgotPasswordFailure] if an exception occurs.
  Future<void> forgotPassword({
    required String email,
  }) async {
    try {
      await _authenticationClient.forgotPassword(
        email: email,
      );
    } on ForgotPasswordFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithCredentialsFailure(error), stackTrace);
    }
  }

  /// Deletes the current user account.
  Future<void> deleteAccount() async {
    try {
      await _authenticationClient.deleteAccount();
    } on DeleteAccountFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteAccountFailure(error), stackTrace);
    }
  }

  /// Fetch additional user data from the `users` table.
  Future<Map<String, dynamic>> getHomeValues(String userId) async {
    final results = await Future.wait([
      _apiClient.countTeams(userId: userId),
      _apiClient.countAthletes(userId: userId),
      _apiClient.countExpiredMedicals(userId: userId),
      _apiClient.countPayments(userId: userId),
      _apiClient.countNotes(userId: userId),
    ]);

    return {
      'teams': results[0],
      'athletes': results[1],
      'expired_medicals': results[2],
      'payments': results[3],
      'notes': results[4],
    };
  }

}
