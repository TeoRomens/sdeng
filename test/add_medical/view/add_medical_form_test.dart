import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sdeng/add_medical/add_medical.dart';
import 'package:flutter_sdeng_api/client.dart';

import '../../helpers/helpers.dart';

class MockAddMedicalCubit extends Mock implements AddMedicalCubit {}

class MockAthlete extends Mock implements Athlete {}

void main() {
  late MockAddMedicalCubit mockCubit;
  late MockAthlete mockAthlete;

  setUp(() {
    mockCubit = MockAddMedicalCubit();
    mockAthlete = MockAthlete();

    registerFallbackValue(MedType.agonistic);

    when(() => mockAthlete.id).thenReturn('athleteId');
    when(() => mockCubit.state).thenReturn(const AddMedicalState(athleteId: 'athleteId'));
  });

  group('AddMedicalForm', () {
    const buttonText = 'button';

    testWidgets('renders form correctly', (WidgetTester tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              child: const Text(buttonText),
              onPressed: () =>
                  showAppModal<void>(
                    context: context,
                    content: AddMedicalModal(athlete: mockAthlete),
                  ),
            );
          },
        ),
      );
      await tester.tap(find.text(buttonText));
      await tester.pumpAndSettle();

      expect(find.text('New medical visit'), findsOneWidget);
      expect(find.text('Agonistic'), findsOneWidget);
      expect(find.text('Not agonistic'), findsOneWidget);
      expect(find.text('Not required'), findsOneWidget);
      expect(find.byType(AppTextFormField), findsOneWidget);
      expect(find.byType(PrimaryButton), findsOneWidget);
    });

    testWidgets('updates radio button selection', (WidgetTester tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              child: const Text(buttonText),
              onPressed: () =>
                  showAppModal<void>(
                    context: context,
                    content: AddMedicalModal(athlete: mockAthlete),
                  ),
            );
          },
        ),
      );
      await tester.tap(find.text(buttonText));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Not agonistic'));
      await tester.pump();

      final NotAgonisticRadioListTile = tester.widget<RadioListTile<MedType>>(
        find.byType(RadioListTile<MedType>).at(1),
      );
      expect(NotAgonisticRadioListTile.groupValue, MedType.not_agonistic);
    });

    testWidgets('shows date picker when tapping expire field', (WidgetTester tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              child: const Text(buttonText),
              onPressed: () =>
                  showAppModal<void>(
                    context: context,
                    content: AddMedicalModal(athlete: mockAthlete),
                  ),
            );
          },
        ),
      );
      await tester.tap(find.text(buttonText));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AppTextFormField));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('calls addMedical when form is valid and submitted', (WidgetTester tester) async {
      when(() => mockCubit.addMedical(
        type: any(named: 'type'),
        expire: any(named: 'expire'),
      )).thenAnswer((_) async {});

      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              child: const Text(buttonText),
              onPressed: () =>
                  showAppModal<void>(
                    context: context,
                    content: AddMedicalModal(athlete: mockAthlete),
                  ),
            );
          },
        ),
      );
      await tester.tap(find.text(buttonText));
      await tester.pumpAndSettle();

      // Fill in the expire date
      await tester.tap(find.byType(AppTextFormField));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Submit the form
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      verify(() => mockCubit.addMedical(
        type: any(named: 'type'),
        expire: any(named: 'expire'),
      )).called(1);
    });
  });
}