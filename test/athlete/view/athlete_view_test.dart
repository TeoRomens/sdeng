import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sdeng/athlete/cubit/athlete_cubit.dart';
import 'package:sdeng/athlete/view/view.dart';

import '../../helpers/helpers.dart';

class MockAthleteCubit extends MockCubit<AthleteState> implements AthleteCubit {}

void main() {
  late AthleteCubit mockAthleteCubit;

  const athleteId = '1';
  const athlete = Athlete(
      id: athleteId,
      teamId: '1',
      fullName: 'Athlete 1',
      taxCode: 'TAXCODE',
  );

  setUp(() {
    mockAthleteCubit = MockAthleteCubit();
  });

  group('AthleteView', ()
  {
    testWidgets(
        'renders loading indicators when athlete is null', (tester) async {
      when(() => mockAthleteCubit.state).thenReturn(
          AthleteState.initial(athleteId: athlete.id));

      await tester.pumpApp(
          BlocProvider<AthleteCubit>.value(
            value: mockAthleteCubit,
            child: const AthleteView(),
          )
      );

      expect(find.text('Loading...'), findsNWidgets(2));
      expect(find.byType(TabBar), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);
    });

    testWidgets('renders athlete info when athlete is loaded', (tester) async {
      when(() => mockAthleteCubit.state).thenReturn(const AthleteState(
          status: AthleteStatus.loaded,
          athleteId: athleteId,
          athlete: athlete));

      await tester.pumpApp(
          BlocProvider<AthleteCubit>.value(
            value: mockAthleteCubit,
            child: const AthleteView(),
          )
      );

      expect(find.text('Athlete 1'), findsOneWidget);
      expect(find.text('TAXCODE'), findsNWidgets(2));
    });
  });
}
