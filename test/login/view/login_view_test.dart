import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sdeng/login/login.dart';
import 'package:sdeng/login/view/login_view.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockLoginBloc extends MockCubit<LoginState> implements LoginBloc {}
class MockUserRepository extends Mock implements UserRepository {}

Widget buildLoginView({required LoginBloc loginBloc}) {
  return MaterialApp(
    home: BlocProvider.value(
      value: loginBloc,
      child: const LoginView(),
    ),
  );
}

void main() {
  late LoginBloc loginBloc;

  setUp(() {
    loginBloc = MockLoginBloc();

    when(() => loginBloc.state).thenReturn(const LoginState());
  });

  testWidgets('AuthenticationFailure SnackBar when submission fails',
      (tester) async {
    whenListen(
      loginBloc,
      Stream.fromIterable(const <LoginState>[
        LoginState(status: FormzSubmissionStatus.inProgress),
        LoginState(status: FormzSubmissionStatus.failure),
      ]),
    );
    await tester.pumpApp(
      BlocProvider.value(value: loginBloc, child: const LoginView()),
    );
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('disables email and password fields while login is in progress', (tester) async {
    when(() => loginBloc.state).thenReturn(
      const LoginState(status: FormzSubmissionStatus.inProgress),
    );

    await tester.pumpWidget(buildLoginView(loginBloc: loginBloc));

    final emailField = tester.widget<AppTextFormField>(
      find.widgetWithText(AppTextFormField, 'Email'),
    );
    final passwordField = tester.widget<AppTextFormField>(
      find.widgetWithText(AppTextFormField, 'Password'),
    );

    expect(emailField.readOnly, isTrue);
    expect(passwordField.readOnly, isTrue);
  });

  testWidgets('nothing when login is canceled', (tester) async {
    whenListen(
      loginBloc,
      Stream.fromIterable(const <LoginState>[
        LoginState(status: FormzSubmissionStatus.inProgress),
        LoginState(status: FormzSubmissionStatus.canceled),
      ]),
    );
  });

}
