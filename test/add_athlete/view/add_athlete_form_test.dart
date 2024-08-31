import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sdeng/add_athlete/cubit/add_athlete_cubit.dart';
import 'package:sdeng/add_athlete/view/add_athlete_form.dart';
import 'package:sdeng/add_athlete/view/add_athlete_modal.dart';

import '../../helpers/helpers.dart';

class MockAddAthleteCubit extends Mock implements AddAthleteCubit {}

void main() {
  late MockAddAthleteCubit mockAddAthleteCubit;

  setUp(() {
    mockAddAthleteCubit = MockAddAthleteCubit();
    when(() => mockAddAthleteCubit.state).thenReturn(
      const AddAthleteState(
        teamId: 'team-123',
      ),
    );
    when(() => mockAddAthleteCubit.stream).thenAnswer(
          (_) => const Stream<AddAthleteState>.empty(),
    );
  });

  group('AddAthleteForm', ()
  {
    const buttonText = 'button';

    testWidgets('navigates to second page on valid input', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              child: const Text(buttonText),
              onPressed: () =>
                  showAppModal<void>(
                    context: context,
                    content: const AddAthleteModal(teamId: 'team-123'),
                  ),
            );
          },
        ),
      );
      await tester.tap(find.text(buttonText));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(AppTextFormField).at(0), 'John');
      await tester.enterText(find.byType(AppTextFormField).at(1), 'Doe');
      await tester.enterText(
          find.byType(AppTextFormField).at(2), 'XXXYYY00T01D514P');

      await tester.runAsync(() async {
        await tester.tap(find.text('Next'));
      });
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('addAthleteForm_address_appTextField')),
          findsWidgets);
    });

    testWidgets('calls addAthlete on form submission', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              child: const Text(buttonText),
              onPressed: () =>
                  showAppModal<void>(
                    context: context,
                    content: const AddAthleteModal(teamId: 'team-123'),
                  ),
            );
          },
        ),
      );
      await tester.tap(find.text(buttonText));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(AppTextFormField).at(0), 'Mario');
      await tester.enterText(find.byType(AppTextFormField).at(1), 'Rossi');
      await tester.enterText(
          find.byType(AppTextFormField).at(2), 'XXXYYY00T01D514P');

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(AppTextFormField).at(0), '01/01/1990');
      await tester.enterText(
          find.byType(AppTextFormField).at(1), '123 Main St');
      await tester.enterText(
          find.byType(AppTextFormField).at(2), 'mariorossi@example.com');
      await tester.enterText(find.byType(AppTextFormField).at(3), '1234567890');

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(find.byType(AddAthleteForm), findsNothing);
    });
  });
}
