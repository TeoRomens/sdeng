// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('AppTextField', () {
    const hintText = 'Hint';

    testWidgets('renders TextFormField', (tester) async {
      await tester.pumpApp(
        AppTextFormField(),
      );
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('has autocorrect set to true', (tester) async {
      await tester.pumpApp(
        AppTextFormField(),
      );

      final field =
          tester.widget<AppTextFormField>(find.byType(AppTextFormField));
      expect(field.autocorrect, true);
    });

    testWidgets('has hint text', (tester) async {
      await tester.pumpApp(
        AppTextFormField(
          hintText: hintText,
        ),
      );
      expect(find.text(hintText), findsOneWidget);
    });

    testWidgets('calls onSubmitted when submitted', (tester) async {
      var onSubmittedCalled = false;
      await tester.pumpApp(
        AppTextFormField(
          onSubmitted: (_) => onSubmittedCalled = true,
        ),
      );

      await tester.showKeyboard(find.byType(TextField));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(onSubmittedCalled, isTrue);
    });
  });
}
