import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/register/register.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late RegisterBloc registerBloc;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    registerBloc = RegisterBloc(userRepository: mockUserRepository);
  });

  group('RegisterBloc', () {
    test('initial state is RegisterState', () {
      expect(registerBloc.state, equals(const RegisterState()));
    });

    blocTest<RegisterBloc, RegisterState>(
      'emits [inProgress, success] when googleSubmitted succeeds',
      build: () {
        when(() => mockUserRepository.logInWithGoogle()).thenAnswer((_) async {});
        return registerBloc;
      },
      act: (bloc) => bloc.googleSubmitted(),
      expect: () => [
        const RegisterState(status: FormzSubmissionStatus.inProgress),
        const RegisterState(status: FormzSubmissionStatus.success),
      ],
      verify: (_) {
        verify(() => mockUserRepository.logInWithGoogle()).called(1);
      },
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [inProgress, failure] when googleSubmitted fails',
      build: () {
        when(() => mockUserRepository.logInWithGoogle()).thenThrow(Exception('error'));
        return registerBloc;
      },
      act: (bloc) => bloc.googleSubmitted(),
      expect: () => [
        const RegisterState(status: FormzSubmissionStatus.inProgress),
        const RegisterState(status: FormzSubmissionStatus.failure),
      ],
      verify: (_) {
        verify(() => mockUserRepository.logInWithGoogle()).called(1);
      },
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [failure] when signupWithCredentials is called with invalid email',
      build: () => registerBloc,
      act: (bloc) => bloc.signupWithCredentials(
        email: const Email.dirty('invalid-email'),
        password: const Password.dirty('password123'),
      ),
      expect: () => [
        const RegisterState(status: FormzSubmissionStatus.failure),
      ],
      verify: (_) {
        verifyNever(() => mockUserRepository.signUpWithCredentials(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ));
      },
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [inProgress, success] when signupWithCredentials succeeds',
      build: () {
        when(() => mockUserRepository.signUpWithCredentials(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async {});
        return registerBloc;
      },
      act: (bloc) => bloc.signupWithCredentials(
        email: const Email.dirty('valid@example.com'),
        password: const Password.dirty('password123'),
      ),
      expect: () => [
        const RegisterState(status: FormzSubmissionStatus.inProgress),
        const RegisterState(status: FormzSubmissionStatus.success),
      ],
      verify: (_) {
        verify(() => mockUserRepository.signUpWithCredentials(
          email: 'valid@example.com',
          password: 'password123',
        )).called(1);
      },
    );

    blocTest<RegisterBloc, RegisterState>(
      'emits [inProgress, failure] when signupWithCredentials fails',
      build: () {
        when(() => mockUserRepository.signUpWithCredentials(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(Exception('error'));
        return registerBloc;
      },
      act: (bloc) => bloc.signupWithCredentials(
        email: const Email.dirty('valid@example.com'),
        password: const Password.dirty('password123'),
      ),
      expect: () => [
        const RegisterState(status: FormzSubmissionStatus.inProgress),
        const RegisterState(status: FormzSubmissionStatus.failure),
      ],
      verify: (_) {
        verify(() => mockUserRepository.signUpWithCredentials(
          email: 'valid@example.com',
          password: 'password123',
        )).called(1);
      },
    );
  });
}
