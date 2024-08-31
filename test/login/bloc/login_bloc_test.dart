import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/login/bloc/login_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:authentication_client/authentication_client.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('LoginBloc', () {
    late UserRepository userRepository;
    late LoginBloc loginBloc;

    setUp(() {
      userRepository = MockUserRepository();
      loginBloc = LoginBloc(userRepository: userRepository);
    });

    test('initial state is correct', () {
      expect(loginBloc.state, equals(const LoginState()));
    });

    group('googleSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'emits [inProgress, success] when Google login succeeds',
        build: () {
          when(() => userRepository.logInWithGoogle()).thenAnswer((_) async {});
          return loginBloc;
        },
        act: (bloc) => bloc.googleSubmitted(),
        expect: () => [
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(status: FormzSubmissionStatus.success),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [inProgress, canceled] when Google login is canceled',
        build: () {
          when(() => userRepository.logInWithGoogle()).thenThrow(const LogInWithGoogleCanceled('error'));
          return loginBloc;
        },
        act: (bloc) => bloc.googleSubmitted(),
        expect: () => [
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(status: FormzSubmissionStatus.canceled),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [inProgress, failure] when Google login fails',
        build: () {
          when(() => userRepository.logInWithGoogle()).thenThrow(Exception('Google login failed'));
          return loginBloc;
        },
        act: (bloc) => bloc.googleSubmitted(),
        expect: () => [
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(status: FormzSubmissionStatus.failure),
        ],
      );
    });

    group('loginWithCredentials', () {

      blocTest<LoginBloc, LoginState>(
        'emits [inProgress, success] when loginWithCredentials succeeds',
        build: () {
          when(() => userRepository.logInWithCredentials(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async {});
          return loginBloc;
        },
        act: (bloc) => bloc.loginWithCredentials(
          email: const Email.dirty('test@example.com'),
          password: const Password.dirty('password123'),
        ),
        expect: () => [
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(status: FormzSubmissionStatus.success),
        ],
        verify: (_) {
          verify(() => userRepository.logInWithCredentials(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [inProgress, failure] when loginWithCredentials fails',
        build: () {
          when(() => userRepository.logInWithCredentials(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(Exception('error'));
          return loginBloc;
        },
        act: (bloc) => bloc.loginWithCredentials(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password123'),
        ),
        expect: () => [
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(
            status: FormzSubmissionStatus.failure,
            error: 'Authentication error',
          ),
        ],
        verify: (_) {
          verify(() => userRepository.logInWithCredentials(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);
        },
      );
    });

    group('forgotPassword', () {

      blocTest<LoginBloc, LoginState>(
        'emits [inProgress, success] when forgotPassword succeeds',
        build: () {
          when(() => userRepository.forgotPassword(email: any(named: 'email')))
              .thenAnswer((_) async {});
          return loginBloc;
        },
        act: (bloc) => bloc.forgotPassword(email: const Email.dirty('test@example.com')),
        expect: () => [
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(status: FormzSubmissionStatus.success),
        ],
        verify: (_) {
          verify(() => userRepository.forgotPassword(email: 'test@example.com'))
              .called(1);
        },
      );


      blocTest<LoginBloc, LoginState>(
        'emits [inProgress, failure] when forgotPassword fails',
        build: () {
          when(() => userRepository.forgotPassword(email: any(named: 'email')))
              .thenThrow(Exception('error'));
          return loginBloc;
        },
        act: (bloc) => bloc.forgotPassword(email: Email.dirty('test@example.com')),
        expect: () => [
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(status: FormzSubmissionStatus.failure),
        ],
        verify: (_) {
          verify(() => userRepository.forgotPassword(email: 'test@example.com'))
              .called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'does not emit new state when email is invalid',
        build: () => loginBloc,
        act: (bloc) => bloc.forgotPassword(
          email: const Email.dirty('invalid-email'),
        ),
        expect: () => [],
      );
    });
  });
}