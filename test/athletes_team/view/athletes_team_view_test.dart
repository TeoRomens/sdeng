import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sdeng/athletes_team/athletes.dart';
import 'package:sdeng/add_athlete/view/add_athlete_modal.dart';

import '../../helpers/helpers.dart';

class MockAthletesCubit extends MockCubit<AthletesState> implements AthletesCubit {}

void main() {
  late AthletesCubit mockAthletesCubit;
  late AthletesState initialState;

  setUp(() {
    mockAthletesCubit = MockAthletesCubit();
    initialState = AthletesState.initial(
      team: Team(id: 'team-1', name: 'Test Team', numAthletes: 5),
    );
  });

  group('AthletesView', () {

    testWidgets('displays loading indicator when status is loading', (tester) async {
      when(() => mockAthletesCubit.state).thenReturn(
        initialState.copyWith(status: AthletesStatus.loading),
      );

      await tester.pumpApp(
        BlocProvider<AthletesCubit>.value(
          value: mockAthletesCubit,
          child: const AthletesView(),
        )
      );

      expect(find.byType(LoadingBox), findsOneWidget);
    });

    testWidgets('displays EmptyState when there are no athletes', (tester) async {
      when(() => mockAthletesCubit.state).thenReturn(
        initialState.copyWith(status: AthletesStatus.populated, athletes: []),
      );

      await tester.pumpApp(
          BlocProvider<AthletesCubit>.value(
            value: mockAthletesCubit,
            child: const AthletesView(),
          )
      );

      expect(find.byType(EmptyState), findsOneWidget);
      expect(find.text('New athlete'), findsOneWidget);
    });

    testWidgets('displays list of athletes when populated', (tester) async {
      final testAthletes = [
        const Athlete(id: '1',  teamId: '1', fullName: 'Athlete 1', taxCode: ''),
        const Athlete(id: '1',  teamId: '1', fullName: 'Athlete 2', taxCode: ''),
      ];

      when(() => mockAthletesCubit.state).thenReturn(
        initialState.copyWith(status: AthletesStatus.populated, athletes: testAthletes),
      );

      await tester.pumpApp(
          BlocProvider<AthletesCubit>.value(
            value: mockAthletesCubit,
            child: const AthletesView(),
          )
      );

      expect(find.byType(AthleteTile), findsNWidgets(2));
      expect(find.text('Athlete 1'), findsOneWidget);
      expect(find.text('Athlete 2'), findsOneWidget);
    });

    testWidgets('displays and triggers add athlete flow', (tester) async {
      when(() => mockAthletesCubit.state).thenReturn(
        initialState.copyWith(status: AthletesStatus.populated, athletes: []),
      );

      await tester.pumpApp(
          BlocProvider<AthletesCubit>.value(
            value: mockAthletesCubit,
            child: const AthletesView(),
          )
      );

      expect(find.text('New athlete'), findsOneWidget);

      await tester.tap(find.text('New athlete'));
      await tester.pumpAndSettle();

      expect(find.byType(AddAthleteModal), findsOneWidget);
    });

    testWidgets('displays the correct team name in TextBox', (tester) async {
      when(() => mockAthletesCubit.state).thenReturn(
        initialState.copyWith(
          status: AthletesStatus.populated,
          team: initialState.team,
        ),
      );

      await tester.pumpApp(
          BlocProvider<AthletesCubit>.value(
            value: mockAthletesCubit,
            child: const AthletesView(),
          )
      );

      expect(find.text('Test Team'), findsOneWidget);
    });

    testWidgets('pull to refresh triggers getAthletesFromTeam', (tester) async {
      when(() => mockAthletesCubit.state).thenReturn(
        initialState.copyWith(status: AthletesStatus.populated, athletes: []),
      );

      await tester.pumpApp(
          BlocProvider<AthletesCubit>.value(
            value: mockAthletesCubit,
            child: const AthletesView(),
          )
      );

      await tester.drag(find.byType(EmptyState), const Offset(0, 500));
      await tester.pump();

      verify(() => mockAthletesCubit.getAthletesFromTeam('1')).called(1);
    });
  });
}
