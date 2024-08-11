import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// {@template authentication_exception}
/// Exceptions from the authentication client.
/// {@endtemplate}
abstract class AuthenticationException implements Exception {
  /// {@macro authentication_exception}
  const AuthenticationException(this.error);

  /// The error which was caught.
  final Object error;
}

/// {@template log_in_with_google_failure}
/// Thrown during the sign in with google process if a failure occurs.
/// {@endtemplate}
class LogInWithGoogleFailure extends AuthenticationException {
  /// {@macro log_in_with_google_failure}
  const LogInWithGoogleFailure(super.error);
}

/// {@template log_in_with_google_canceled}
/// Thrown during the sign in with google process if it's canceled.
/// {@endtemplate}
class LogInWithGoogleCanceled extends AuthenticationException {
  /// {@macro log_in_with_google_canceled}
  const LogInWithGoogleCanceled(super.error);
}

/// {@template log_in_with_credentials_failure}
/// Thrown during the sign in with credentials process if a failure occurs.
/// {@endtemplate}
class LogInWithCredentialsFailure extends AuthenticationException {
  /// {@macro log_in_with_credentials_failure}
  const LogInWithCredentialsFailure(super.error);
}

/// {@template sign_up_with_credentials_failure}
/// Thrown during the sign up with credentials process if a failure occurs.
/// {@endtemplate}
class SignUpWithCredentialsFailure extends AuthenticationException {
  /// {@macro sign_up_with_credentials_failure}
  const SignUpWithCredentialsFailure(super.error);
}

/// {@template log_out_failure}
/// Thrown during the logout process if a failure occurs.
/// {@endtemplate}
class LogOutFailure extends AuthenticationException {
  /// {@macro log_out_failure}
  const LogOutFailure(super.error);
}

/// {@template delete_account_failure}
/// Thrown during the delete account process if a failure occurs.
/// {@endtemplate}
class DeleteAccountFailure extends AuthenticationException {
  /// {@macro delete_account_failure}
  const DeleteAccountFailure(super.error);
}

/// {@template forgot_password_failure}
/// Thrown during the delete account process if a failure occurs.
/// {@endtemplate}
class ForgotPasswordFailure extends AuthenticationException {
  /// {@macro forgot_password_failure}
  const ForgotPasswordFailure(super.error);
}

class AuthenticationClient {
  /// {@macro supabase_authentication_client}
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

  Stream<User?> get user {
    return _supabaseClient.auth.onAuthStateChange.map((data) {
      return data.session?.user;
    });
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleCanceled] if the flow is canceled by the user.
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
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

  /// Starts the Sign In Flow.
  ///
  /// Throws a [LogInWithCredentialsFailure] if an exception occurs.
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

  /// Starts the Sign Up Flow.
  ///
  /// Throws a [SignUpWithCredentialsFailure] if an exception occurs.
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
          SignUpWithCredentialsFailure(error), stackTrace);
    }
  }

  /// Signs out the current user which will emit
  /// [AuthUser.anonymous] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _supabaseClient.auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogOutFailure(error), stackTrace);
    }
  }

  /// Deletes and signs out the user.
  Future<void> deleteAccount() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw DeleteAccountFailure(
          Exception('User is not authenticated'),
        );
      }

      // TODO: Implement deletion
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteAccountFailure(error), stackTrace);
    }
  }

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
