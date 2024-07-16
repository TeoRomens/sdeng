import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTextStyles', () {
    group('UITextStyle', () {
      test('headline1 returns TextStyle', () {
        expect(UITextStyle.displayLarge, isA<TextStyle>());
      });

      test('headline2 returns TextStyle', () {
        expect(UITextStyle.displayMedium, isA<TextStyle>());
      });

      test('headline3 returns TextStyle', () {
        expect(UITextStyle.displaySmall, isA<TextStyle>());
      });

      test('headline4 returns TextStyle', () {
        expect(UITextStyle.headlineLarge, isA<TextStyle>());
      });

      test('headline5 returns TextStyle', () {
        expect(UITextStyle.headlineMedium, isA<TextStyle>());
      });

      test('headline6 returns TextStyle', () {
        expect(UITextStyle.headlineSmall, isA<TextStyle>());
      });

      test('subtitle1 returns TextStyle', () {
        expect(UITextStyle.titleMedium, isA<TextStyle>());
      });

      test('subtitle2 returns TextStyle', () {
        expect(UITextStyle.titleSmall, isA<TextStyle>());
      });

      test('bodyText1 returns TextStyle', () {
        expect(UITextStyle.bodyLarge, isA<TextStyle>());
      });

      test('bodyText2 returns TextStyle', () {
        expect(UITextStyle.bodyMedium, isA<TextStyle>());
      });

      test('button returns TextStyle', () {
        expect(UITextStyle.labelLarge, isA<TextStyle>());
      });

      test('caption returns TextStyle', () {
        expect(UITextStyle.bodySmall, isA<TextStyle>());
      });

      test('overline returns TextStyle', () {
        expect(UITextStyle.labelSmall, isA<TextStyle>());
      });

      test('labelSmall returns TextStyle', () {
        expect(UITextStyle.label, isA<TextStyle>());
      });
    });
  });
}
