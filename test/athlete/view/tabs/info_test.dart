import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_sdeng_api/api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sdeng/athlete/athlete.dart';

import '../../../helpers/helpers.dart';

class MockAthleteCubit extends Mock implements AthleteCubit {}

void main() {
  late AthleteCubit athleteCubit;

  const athleteId = '1';
  final athlete = Athlete(
    id: athleteId,
    teamId: '1',
    fullName: 'Athlete 1',
    taxCode: 'TAXCODE',
    birthdate: DateTime(1990, 01, 01),
    email: 'athlete1@example.com',
  );

  setUp(() {
    athleteCubit = MockAthleteCubit();
  });

  group('AthleteInfo Widget Tests', () {
    testWidgets('renders loading indicator when status is loading', (tester) async {
      when(() => athleteCubit.state).thenReturn(
        const AthleteState(
          status: AthleteStatus.loading,
          athleteId: athleteId
      ));

      whenListen(
        athleteCubit,
        Stream.fromIterable([
          const AthleteState(
            status: AthleteStatus.loading,
            athleteId: athleteId),
        ]),
      );

      await tester.pumpApp(
        BlocProvider<AthleteCubit>.value(
          value: athleteCubit,
          child: const AthleteInfo(),
        )
      );

      expect(find.byType(LoadingBox), findsNWidgets(2)); // One for Athlete, one for Parent
    });

    testWidgets('renders personal data correctly when loaded', (tester) async {
      when(() => athleteCubit.state).thenReturn(AthleteState(
        status: AthleteStatus.loaded,
        athlete: athlete,
        athleteId: athleteId,
      ));

      whenListen(
        athleteCubit,
        Stream.fromIterable([
          AthleteState(
            status: AthleteStatus.loaded,
            athleteId: athleteId,
            athlete: athlete
          ),
        ]),
      );

      await tester.pumpApp(
        BlocProvider<AthleteCubit>.value(
          value: athleteCubit,
          child: const AthleteInfo(),
        )
      );

      expect(find.text('Personal Data'), findsOneWidget);
      expect(find.text('TAXCODE'), findsOneWidget);
      expect(find.text('athlete1@example.com'), findsOneWidget);
    });

  });
}
