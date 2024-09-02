import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sdeng_api/api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sdeng/teams/teams.dart';
import 'package:sdeng/add_team/view/add_team_modal.dart';
import 'package:sdeng/athletes_team/view/athletes_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_ui/app_ui.dart';

import '../../helpers/helpers.dart';

class MockTeamsCubit extends MockCubit<TeamsState> implements TeamsCubit {}

void main() {
  late MockTeamsCubit mockTeamsCubit;

  setUp(() {
    mockTeamsCubit = MockTeamsCubit();
  });

  group('TeamsView', () {
    testWidgets('shows SnackBar when status is failure', (tester) async {
      const errorMessage = 'An error occurred';
      when(() => mockTeamsCubit.state).thenReturn(
        const TeamsState(status: TeamsStatus.failure, error: errorMessage),
      );

      await tester.pumpApp(
        BlocProvider<TeamsCubit>.value(
          value: mockTeamsCubit,
          child: const TeamsView(),
        ),
      );

      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('renders TeamsScreen', (tester) async {
      when(() => mockTeamsCubit.state).thenReturn(const TeamsState(status: TeamsStatus.populated));

      await tester.pumpApp(
        BlocProvider<TeamsCubit>.value(
            value: mockTeamsCubit,
            child: const TeamsView(),
          ),
      );

      expect(find.byType(TeamsScreen), findsOneWidget);
    });
  });

  group('TeamsScreen', () {
    testWidgets('renders loading state', (tester) async {
      when(() => mockTeamsCubit.state).thenReturn(
        const TeamsState(status: TeamsStatus.loading),
      );

      await tester.pumpApp(
        BlocProvider<TeamsCubit>.value(
          value: mockTeamsCubit,
          child: const TeamsScreen(),
        ),
      );

      expect(find.byType(LoadingBox), findsOneWidget);
    });

    testWidgets('renders EmptyState when no teams are available', (tester) async {
      when(() => mockTeamsCubit.state).thenReturn(
        const TeamsState(status: TeamsStatus.populated, teams: []),
      );

      await tester.pumpApp(
        BlocProvider<TeamsCubit>.value(
          value: mockTeamsCubit,
          child: const TeamsScreen(),
        ),
      );

      expect(find.byType(EmptyState), findsOneWidget);
      expect(find.text('New team'), findsOneWidget);
    });

    testWidgets('renders list of teams when teams are available', (tester) async {
      final mockTeams = [
        Team(id: '1', name: 'Team A', numAthletes: 10, ),
        Team(id: '2', name: 'Team B', numAthletes: 5),
      ];
      when(() => mockTeamsCubit.state).thenReturn(
        TeamsState(status: TeamsStatus.populated, teams: mockTeams),
      );

      await tester.pumpApp(
        BlocProvider<TeamsCubit>.value(
          value: mockTeamsCubit,
          child: const TeamsScreen(),
        ),
      );

      expect(find.byType(TeamTile), findsNWidgets(2));
      expect(find.text('Team A'), findsOneWidget);
      expect(find.text('Team B'), findsOneWidget);
    });

    testWidgets('calls getTeams on pull-to-refresh', (tester) async {
      when(() => mockTeamsCubit.state).thenReturn(
        const TeamsState(status: TeamsStatus.populated, teams: []),
      );
      when(() => mockTeamsCubit.getTeams()).thenAnswer((_) async {});

      await tester.pumpApp(
        BlocProvider<TeamsCubit>.value(
          value: mockTeamsCubit,
          child: const TeamsScreen(),
        ),
      );

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, 300));
      await tester.pumpAndSettle();

      verify(() => mockTeamsCubit.getTeams()).called(1);
    });

    testWidgets('opens AddTeamModal when Add team button is pressed', (tester) async {
      when(() => mockTeamsCubit.state).thenReturn(
        TeamsState(status: TeamsStatus.populated, teams: [Team(id: '1', name: 'Team A', numAthletes: 1)]),
      );

      await tester.pumpApp(
        BlocProvider<TeamsCubit>.value(
          value: mockTeamsCubit,
          child: const TeamsScreen(),
        ),
      );

      await tester.tap(find.text('Add team'));
      await tester.pumpAndSettle();

      expect(find.byType(AddTeamModal), findsOneWidget);
    });

    testWidgets('navigates to AthletesPage when a team is tapped', (tester) async {
      final team = Team(id:'1', name: 'Team A', numAthletes: 10);
      when(() => mockTeamsCubit.state).thenReturn(
        TeamsState(status: TeamsStatus.populated, teams: [team]),
      );

      await tester.pumpApp(
        BlocProvider<TeamsCubit>.value(
          value: mockTeamsCubit,
          child: const TeamsScreen(),
        ),
      );

      await tester.tap(find.text('Team A'));
      await tester.pumpAndSettle();

      expect(find.byType(AthletesPage), findsOneWidget);
    });
  });
}
