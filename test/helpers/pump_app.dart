import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:documents_repository/documents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicals_repository/medicals_repository.dart';
import 'package:mockingjay/mockingjay.dart'
    show MockNavigator, MockNavigatorProvider;
import 'package:mocktail/mocktail.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/app/bloc/app_bloc.dart';
import 'package:teams_repository/teams_repository.dart';
import 'package:user_repository/user_repository.dart';

class MockAppBloc extends MockCubit<AppState> implements AppBloc {}

class MockUserRepository extends Mock implements UserRepository {}

class MockTeamsRepository extends Mock implements TeamsRepository {}

class MockAthletesRepository extends Mock implements AthletesRepository {}

class MockMedicalsRepository extends Mock implements MedicalsRepository {}

class MockPaymentsRepository extends Mock implements PaymentsRepository {}

class MockNotesRepository extends Mock implements NotesRepository {}

class MockDocumentsRepository extends Mock implements DocumentsRepository {}

extension AppTester on WidgetTester {
  Future<void> pumpApp(
    Widget widgetUnderTest, {
    AppBloc? appBloc,
    UserRepository? userRepository,
    TeamsRepository? teamsRepository,
    AthletesRepository? athletesRepository,
    MedicalsRepository? medicalsRepository,
    PaymentsRepository? paymentsRepository,
    NotesRepository? notesRepository,
    DocumentsRepository? documentsRepository,
    TargetPlatform? platform,
    NavigatorObserver? navigatorObserver,
    MockNavigator? navigator,
  }) async {
    await pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: userRepository ?? MockUserRepository(),
          ),
          RepositoryProvider.value(
            value: teamsRepository ?? MockTeamsRepository(),
          ),
          RepositoryProvider.value(
            value: athletesRepository ?? MockAthletesRepository(),
          ),
          RepositoryProvider.value(
            value: athletesRepository ?? MockAthletesRepository(),
          ),
          RepositoryProvider.value(
            value: medicalsRepository ?? MockMedicalsRepository(),
          ),
          RepositoryProvider.value(
            value: paymentsRepository ?? MockPaymentsRepository(),
          ),
          RepositoryProvider.value(
            value: notesRepository ?? MockNotesRepository(),
          ),
          RepositoryProvider.value(
            value: documentsRepository ?? MockDocumentsRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: appBloc ?? MockAppBloc()),
          ],
          child: MaterialApp(
            title: 'Sdeng',
            home: Theme(
              data: ThemeData(platform: platform),
              child: navigator == null
                  ? Scaffold(body: widgetUnderTest)
                  : MockNavigatorProvider(
                      navigator: navigator,
                      child: Scaffold(body: widgetUnderTest),
                    ),
            ),
            navigatorObservers: [
              if (navigatorObserver != null) navigatorObserver,
            ],
          ),
        ),
      ),
    );
    await pump();
  }
}
