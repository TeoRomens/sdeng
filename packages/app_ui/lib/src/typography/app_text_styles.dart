import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// The default app's [TextTheme] is [AppTheme.uiTextTheme].

/// UI Text Style Definitions
abstract class UITextStyle {
  static const _baseTextStyle = TextStyle(
    package: 'app_ui',
    fontWeight: AppFontWeight.regular,
    fontFamily: FontFamily.plusJakartaSans,
    decoration: TextDecoration.none,
    textBaseline: TextBaseline.alphabetic,
    color: Color(0xFF101828),
    letterSpacing: 0,
  );

  /// Headline 1 Text Style
  static final TextStyle displayLarge = _baseTextStyle.copyWith(
    fontSize: 48,
    fontWeight: AppFontWeight.bold,
    letterSpacing: -0.2,
  );

  /// Headline 2 Text Style
  static final TextStyle displayMedium = _baseTextStyle.copyWith(
    fontSize: 36,
    fontWeight: AppFontWeight.bold,
    letterSpacing: -0.2,
  );

  /// Headline 3 Text Style
  static final TextStyle displaySmall = _baseTextStyle.copyWith(
    fontSize: 30,
    fontWeight: AppFontWeight.bold,
    letterSpacing: -0.2,
  );

  /// Headline 4 Text Style
  static final TextStyle headlineLarge = _baseTextStyle.copyWith(
    fontSize: 30,
    fontWeight: AppFontWeight.semiBold,
    letterSpacing: -0.2,
  );

  /// Headline 5 Text Style
  static final TextStyle headlineMedium = _baseTextStyle.copyWith(
    fontSize: 24,
    fontWeight: AppFontWeight.semiBold,
    letterSpacing: -0.2,
  );

  /// Headline 6 Text Style
  static final TextStyle headlineSmall = _baseTextStyle.copyWith(
    fontSize: 20,
    fontWeight: AppFontWeight.semiBold,
    letterSpacing: -0.2,
  );

  /// Subtitle 1 Text Style
  static final TextStyle titleMedium = _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: AppFontWeight.semiBold,
    letterSpacing: -0.2,
  );

  /// Subtitle 2 Text Style
  static final TextStyle titleSmall = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: AppFontWeight.semiBold,
    letterSpacing: -0.2,
  );

  /// Body Text 1 Text Style
  static final TextStyle bodyLarge = _baseTextStyle.copyWith(
    fontSize: 16,
    color: const Color(0xFF475467),
  );

  /// Body Text 2 Text Style (the default)
  static final TextStyle bodyMedium = _baseTextStyle.copyWith(
    fontSize: 14,
    color: const Color(0xFF475467),
  );

  /// Caption Text Style
  static final TextStyle bodySmall = _baseTextStyle.copyWith(
    fontSize: 12,
    color: const Color(0xFF475467),
  );

  /// Caption Text Style
  static final TextStyle inputError = _baseTextStyle.copyWith(
    fontSize: 12,
    color: AppColors.red,
    fontWeight: AppFontWeight.medium,
  );

  /// Button Text Style
  static final TextStyle labelLarge = _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: AppFontWeight.medium,
    color: const Color(0xFF475467),
    letterSpacing: 0,
  );

  /// Overline Text Style
  static final TextStyle labelSmall = _baseTextStyle.copyWith(
    fontSize: 14,
    color: const Color(0xFF475467),
    letterSpacing: 0,
  );

  /// Label Small Text Style
  static final TextStyle label = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: AppFontWeight.medium,
    color: const Color(0xFF344054),
    letterSpacing: 0,
  );
}
