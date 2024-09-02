import 'package:app_ui/app_ui.dart';
import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sdeng/athletes_team/cubit/athletes_cubit.dart';
import 'package:sdeng/athletes_team/view/athletes_view.dart';
import 'package:sdeng/athletes_team/view/athletes_view_desktop.dart';
import 'package:sdeng/rename_team/view/rename_team_modal.dart';
import 'package:teams_repository/teams_repository.dart';
import 'package:sdeng/athletes_team/view/athletes_page.dart';

import '../../helpers/helpers.dart';

class MockAthletesRepository extends Mock implements AthletesRepository {}
class MockTeamsRepository extends Mock implements TeamsRepository {}
class MockAthletesCubit extends MockCubit<AthletesState> implements AthletesCubit {}

void main() {
  late MockAthletesCubit athletesCubit;
  late Team testTeam;

  setUp(() {
    athletesCubit = MockAthletesCubit();
    testTeam = Team(id: 'team-1', name: 'Test Team', numAthletes: 5);

    when(() => athletesCubit.state).thenReturn(AthletesState.initial(team: testTeam));
  });


  group('AthletesPage', () {
    testWidgets('displays AppBar with correct title', (tester) async {
      await tester.pumpApp(
        BlocProvider<AthletesCubit>.value(
          value: athletesCubit,
          child: AthletesPage(team: testTeam),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Test Team'), findsNothing); // Title is the logo, not text
      expect(find.byType(AppLogo), findsOneWidget);
    });

    testWidgets('shows SnackBar on error', (tester) async {
      when(() => athletesCubit.state).thenReturn(
        AthletesState(
          status: AthletesStatus.failure,
          team: testTeam,
          error: 'Error loading athletes.',
        ),
      );

      await tester.pumpApp(
        BlocProvider<AthletesCubit>.value(
          value: athletesCubit,
          child: AthletesPage(team: testTeam),
        ),
      );
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('shows AthletesView in portrait mode', (tester) async {
      await tester.pumpApp(
        BlocProvider<AthletesCubit>.value(
          value: athletesCubit,
          child: AthletesPage(team: testTeam),
        ),
      );

      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpAndSettle();

      expect(find.byType(AthletesView), findsOneWidget);
      expect(find.byType(AthletesViewDesktop), findsNothing);
    });

    testWidgets('shows AthletesViewDesktop in landscape mode', (tester) async {
      await tester.pumpApp(
        BlocProvider<AthletesCubit>.value(
          value: athletesCubit,
          child: AthletesPage(team: testTeam),
        ),
      );

      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpAndSettle();

      expect(find.byType(AthletesViewDesktop), findsOneWidget);
      expect(find.byType(AthletesView), findsNothing);
    });

    testWidgets('opens RenameTeamModal when Rename is tapped', (tester) async {
      await tester.pumpApp(
        BlocProvider<AthletesCubit>.value(
          value: athletesCubit,
          child: AthletesPage(team: testTeam),
        ),
      );

      await tester.tap(find.byKey(const Key('AthletesTeamPage_popUpMenu_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Rename'));
      await tester.pumpAndSettle();

      expect(find.byType(RenameTeamModal), findsOneWidget);
    });

    testWidgets('calls deleteTeam when Delete is tapped', (tester) async {
      await tester.pumpApp(
        BlocProvider<AthletesCubit>.value(
          value: athletesCubit,
          child: AthletesPage(team: testTeam),
        ),
      );

      await tester.tap(find.byKey(const Key('AthletesTeamPage_popUpMenu_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      verify(() => athletesCubit.deleteTeam(testTeam.id)).called(1);
    });
  });
}
