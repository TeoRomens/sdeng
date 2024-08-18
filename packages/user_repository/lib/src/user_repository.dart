import 'dart:async';

import 'package:authentication_client/authentication_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A base class for user-related failures in the repository.
///
/// This class represents generic failures that occur within the user repository
/// and provides a way to handle exceptions uniformly.
abstract class UserFailure with EquatableMixin implements Exception {
  /// Creates a [UserFailure] with the provided error.
  ///
  /// The [error] parameter represents the underlying exception or error that
  /// caused the failure.
  const UserFailure(this.error);

  /// The error that caused the failure.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// Thrown when updating user data fails.
///
/// This exception is thrown if there is an error while trying to update user
/// information in the repository.
class UpdateUserDataFailure extends UserFailure {
  /// Creates an [UpdateUserDataFailure] with the provided error.
  const UpdateUserDataFailure(super.error);
}

/// A repository class that manages user-related operations.
///
/// This class handles authentication, user data retrieval, and updates. It
/// integrates with both the authentication client and the API client to
/// provide a comprehensive user management solution.
class UserRepository {
  /// Creates a [UserRepository] instance with the given clients.
  ///
  /// The [authenticationClient] parameter is used for authentication-related
  /// operations, while the [apiClient] is used for interacting with the API
  /// to fetch and update user data.
  UserRepository({
    required AuthenticationClient authenticationClient,
    required FlutterSdengApiClient apiClient,
  })  : _authenticationClient = authenticationClient,
        _apiClient = apiClient;

  final AuthenticationClient _authenticationClient;
  final FlutterSdengApiClient _apiClient;

  /// A stream of [User] that emits the current user when the authentication
  /// state changes.
  ///
  /// This stream allows listening to changes in the user's authentication
  /// state, such as sign-in or sign-out events.
  Stream<User?> get user => _authenticationClient.user;

  /// The additional user data fetched from the API.
  SdengUser? sdengUser;

  /// Fetches additional user data from the `users` table.
  ///
  /// This method retrieves detailed information about a user from the API.
  /// Throws a [UserFailure] if the operation fails.
  Future<SdengUser> getUserData(String userId) async {
    sdengUser = await _apiClient.getUserData(userId: userId);
    return sdengUser!;
  }

  /// Updates user data in the API.
  ///
  /// This method updates various fields of user data, such as full name and
  /// society information. Throws an [UpdateUserDataFailure] if the update
  /// fails.
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

  /// Starts the sign-in flow with Google.
  ///
  /// This method initiates the Google sign-in process using the authentication
  /// client. Throws a [LogInWithGoogleCanceled] if the sign-in is canceled
  /// by the user, or a [LogInWithGoogleFailure] if an error occurs during
  /// the process.
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

  /// Starts the sign-in flow with email and password.
  ///
  /// This method handles user authentication using email and password. Throws
  /// a [LogInWithCredentialsFailure] if an error occurs during the sign-in
  /// process.
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

  /// Starts the sign-up flow with email and password.
  ///
  /// This method handles user registration using email and password. Throws
  /// a [SignUpWithCredentialsFailure] if an error occurs during the sign-up
  /// process.
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
      Error.throwWithStackTrace(
          SignUpWithCredentialsFailure(error), stackTrace);
    }
  }

  /// Signs out the current user.
  ///
  /// This method signs out the user and clears the authentication state. Throws
  /// a [LogOutFailure] if an error occurs during the sign-out process.
  Future<void> logOut() async {
    try {
      await _authenticationClient.logout();
    } on LogOutFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogOutFailure(error), stackTrace);
    }
  }

  /// Starts the forgot password flow.
  ///
  /// This method initiates the password reset process for the provided email.
  /// Throws a [ForgotPasswordFailure] if an error occurs during the process.
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
      Error.throwWithStackTrace(ForgotPasswordFailure(error), stackTrace);
    }
  }

  /// Fetches various home values related to the user.
  ///
  /// This method retrieves counts for different data types related to the user,
  /// such as teams, athletes, expired medicals, payments, and notes.
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
