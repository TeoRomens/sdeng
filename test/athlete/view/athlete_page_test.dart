import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sdeng/athlete/athlete.dart';

import '../../helpers/helpers.dart';

class MockAthleteCubit extends MockCubit<AthleteState> implements AthleteCubit {}

void main() {
  late MockAthleteCubit mockAthleteCubit;

  const athleteId = '1';
  const athlete = Athlete(
    id: athleteId,
    teamId: '1',
    fullName: 'Athlete 1',
    taxCode: 'TAXCODE',
  );

  setUp(() {
    mockAthleteCubit = MockAthleteCubit();
    when(() => mockAthleteCubit.state).thenReturn(const AthleteState.initial(athleteId: '1'));
  });

  group('AthletePage', () {

    testWidgets('shows loading indicator when in loading state', (tester) async {
      when(() => mockAthleteCubit.state).thenReturn(
        const AthleteState(
            status: AthleteStatus.loading,
            athleteId: athleteId,
        )
      );

      await tester.pumpApp(
        BlocProvider<AthleteCubit>.value(
          value: mockAthleteCubit,
          child: const AthleteView(),
        )
      );

      expect(find.text('Loading...'), findsNWidgets(2));
    });

    testWidgets('displays error snackbar on failure state', (tester) async {
      whenListen(
        mockAthleteCubit,
        Stream.fromIterable([
          const AthleteState(
            status: AthleteStatus.failure,
            error: 'Error occurred',
            athleteId: athleteId),
        ]),
      );

      //TODO: Uses the BlocProvider inside athletePage and not the mockCubit
      await tester.pumpApp(
          BlocProvider<AthleteCubit>.value(
            value: mockAthleteCubit,
            child: const AthletePage(athleteId: athleteId,),
          )
      );
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('renders AthleteView or AthleteViewDesktop based on orientation', (tester) async {
      when(() => mockAthleteCubit.state).thenReturn(const AthleteState(
          status: AthleteStatus.loaded,
          athleteId: '1',
          athlete: athlete
      ));

      await tester.pumpApp(
          BlocProvider.value(
            value: mockAthleteCubit,
            child: const AthletePage(athleteId: athleteId),
          )
      );

      // Test portrait mode
      tester.view.physicalSize = const Size(1080, 1920);
      await tester.pumpAndSettle();
      expect(find.byType(AthleteView), findsOneWidget);

      // Test landscape mode
      tester.view.physicalSize = const Size(1920, 1080);
      await tester.pumpAndSettle();
      expect(find.byType(AthleteViewDesktop), findsOneWidget);
    });
  });
}
