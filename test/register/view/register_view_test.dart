import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sdeng/login/login.dart';
import 'package:sdeng/register/register.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockRegisterCubit extends MockCubit<RegisterState> implements RegisterBloc {}
class MockUserRepository extends Mock implements UserRepository {}

Widget buildRegisterView({required RegisterBloc registerBloc}) {
  return MaterialApp(
    home: BlocProvider.value(
      value: registerBloc,
      child: const RegisterView(),
    ),
  );
}

void main() {
  late RegisterBloc registerBloc;

  setUp(() {
    registerBloc = MockRegisterCubit();

    when(() => registerBloc.state).thenReturn(const RegisterState());
  });

  testWidgets('AuthenticationFailure SnackBar when registration fails',
          (tester) async {
        whenListen(
          registerBloc,
          Stream.fromIterable(const <LoginState>[
            LoginState(status: FormzSubmissionStatus.inProgress),
            LoginState(status: FormzSubmissionStatus.failure),
          ]),
        );
        await tester.pumpApp(
          BlocProvider.value(value: registerBloc, child: const RegisterView()),
        );
        await tester.pump();
        expect(find.byType(SnackBar), findsOneWidget);
      });

  testWidgets('disables email and password fields while register is in progress', (tester) async {
    when(() => registerBloc.state).thenReturn(
      const RegisterState(status: FormzSubmissionStatus.inProgress),
    );

    await tester.pumpWidget(buildRegisterView(registerBloc: registerBloc));

    final emailField = tester.widget<AppTextFormField>(
      find.widgetWithText(AppTextFormField, 'Email'),
    );
    final passwordField = tester.widget<AppTextFormField>(
      find.widgetWithText(AppTextFormField, 'Password'),
    );

    expect(emailField.readOnly, isTrue);
    expect(passwordField.readOnly, isTrue);
  });

  testWidgets('nothing when register is canceled', (tester) async {
    whenListen(
      registerBloc,
      Stream.fromIterable(const <LoginState>[
        LoginState(status: FormzSubmissionStatus.inProgress),
        LoginState(status: FormzSubmissionStatus.canceled),
      ]),
    );
  });

}
