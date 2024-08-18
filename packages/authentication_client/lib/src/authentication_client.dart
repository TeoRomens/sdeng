import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// {@template authentication_exception}
/// Base class for exceptions thrown by the `AuthenticationClient`.
///
/// This class holds an error object that provides details about what went wrong.
/// {@endtemplate}
abstract class AuthenticationException implements Exception {
  /// {@macro authentication_exception}
  const AuthenticationException(this.error);

  /// The error that was caught.
  final Object error;
}

/// {@template log_in_with_google_failure}
/// Exception thrown during the Google Sign-In process if an error occurs.
///
/// This can happen due to network issues, invalid credentials, or other errors
/// during the Google authentication process.
/// {@endtemplate}
class LogInWithGoogleFailure extends AuthenticationException {
  /// {@macro log_in_with_google_failure}
  const LogInWithGoogleFailure(super.error);
}

/// {@template log_in_with_google_canceled}
/// Exception thrown when the Google Sign-In process is canceled by the user.
///
/// This occurs when the user exits the Google Sign-In flow without completing it.
/// {@endtemplate}
class LogInWithGoogleCanceled extends AuthenticationException {
  /// {@macro log_in_with_google_canceled}
  const LogInWithGoogleCanceled(super.error);
}

/// {@template log_in_with_credentials_failure}
/// Exception thrown during the sign-in process with email and password if a failure occurs.
///
/// This can happen due to incorrect credentials, network issues, or other authentication errors.
/// {@endtemplate}
class LogInWithCredentialsFailure extends AuthenticationException {
  /// {@macro log_in_with_credentials_failure}
  const LogInWithCredentialsFailure(super.error);
}

/// {@template sign_up_with_credentials_failure}
/// Exception thrown during the sign-up process with email and password if a failure occurs.
///
/// This can happen due to invalid input, network issues, or other errors during the sign-up process.
/// {@endtemplate}
class SignUpWithCredentialsFailure extends AuthenticationException {
  /// {@macro sign_up_with_credentials_failure}
  const SignUpWithCredentialsFailure(super.error);
}

/// {@template log_out_failure}
/// Exception thrown during the logout process if a failure occurs.
///
/// This can happen due to network issues or other errors during the sign-out process.
/// {@endtemplate}
class LogOutFailure extends AuthenticationException {
  /// {@macro log_out_failure}
  const LogOutFailure(super.error);
}

/// {@template delete_account_failure}
/// Exception thrown during the account deletion process if a failure occurs.
///
/// This can happen if the user is not authenticated or due to other errors during account deletion.
/// {@endtemplate}
class DeleteAccountFailure extends AuthenticationException {
  /// {@macro delete_account_failure}
  const DeleteAccountFailure(super.error);
}

/// {@template forgot_password_failure}
/// Exception thrown during the password reset process if a failure occurs.
///
/// This can happen due to network issues, incorrect email, or other errors during the password reset process.
/// {@endtemplate}
class ForgotPasswordFailure extends AuthenticationException {
  /// {@macro forgot_password_failure}
  const ForgotPasswordFailure(super.error);
}

/// The `AuthenticationClient` class handles user authentication tasks such as
/// signing in with Google, signing in or signing up with email and password,
/// logging out, and resetting passwords.
///
/// This class uses Supabase and Google Sign-In to manage authentication, and throws
/// specific exceptions when errors occur during these processes.
class AuthenticationClient {
  /// Creates an `AuthenticationClient` instance.
  ///
  /// The [supabaseClient] parameter is optional and defaults to `Supabase.instance.client`.
  /// The [googleSignIn] parameter is optional and defaults to a preconfigured instance of `GoogleSignIn`.
  AuthenticationClient({
    SupabaseClient? supabaseClient,
    GoogleSignIn? googleSignIn,
  })  : _supabaseClient = supabaseClient ?? Supabase.instance.client,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              clientId:
              '424833225652-ehsmi8dg6fmu6j4tgssjkl8q5hnf33hj.apps.googleusercontent.com',
              serverClientId:
              '424833225652-s9n3jlj2q6fkdeo95234e8hjcp1iiv48.apps.googleusercontent.com',
            );

  final SupabaseClient _supabaseClient;
  final GoogleSignIn _googleSignIn;

  /// A stream that emits the current authenticated user.
  ///
  /// The stream emits `null` if the user is not authenticated.
  Stream<User?> get user {
    return _supabaseClient.auth.onAuthStateChange.map((data) {
      return data.session?.user;
    });
  }

  /// Initiates the Google Sign-In flow.
  ///
  /// If the sign-in process is canceled by the user, a [LogInWithGoogleCanceled] exception is thrown.
  /// If any other error occurs during the process, a [LogInWithGoogleFailure] exception is thrown.
  Future<void> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw LogInWithGoogleCanceled(
          Exception('Sign in with Google canceled'),
        );
      }
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;
      if (accessToken == null) {
        throw LogInWithGoogleFailure(
          Exception('No Access Token found.'),
        );
      }
      if (idToken == null) {
        throw LogInWithGoogleFailure(Exception('No ID Token found.'));
      }
      await _supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } on LogInWithGoogleCanceled {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithGoogleFailure(error), stackTrace);
    }
  }

  /// Signs in the user with their email and password.
  ///
  /// Throws a [LogInWithCredentialsFailure] if the sign-in fails.
  Future<void> logInWithCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithCredentialsFailure(error), stackTrace);
    }
  }

  /// Signs up a new user with their email and password.
  ///
  /// Throws a [SignUpWithCredentialsFailure] if the sign-up process fails.
  Future<void> signUpWithCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        //emailRedirectTo: 'io.teoromens.sdeng://home'
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
          SignUpWithCredentialsFailure(error), stackTrace,);
    }
  }

  /// Signs out the current user.
  ///
  /// Throws a [LogOutFailure] if the logout process fails.
  Future<void> logout() async {
    try {
      await Future.wait([
        _supabaseClient.auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogOutFailure(error), stackTrace);
    }
  }

  /// Sends a password reset email to the given email address.
  ///
  /// Throws a [ForgotPasswordFailure] if the password reset process fails.
  Future<void> forgotPassword({required String email}) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(
        email,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ForgotPasswordFailure(error), stackTrace);
    }
  }
}
