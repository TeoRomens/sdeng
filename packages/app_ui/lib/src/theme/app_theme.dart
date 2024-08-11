import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// {@template app_theme}
/// The Default App [ThemeData].
/// {@endtemplate}
class AppTheme {
  /// {@macro app_theme}
  const AppTheme();

  /// Default `ThemeData` for App UI.
  ThemeData get themeData {
    return ThemeData(
      primaryColor: AppColors.primary,
      canvasColor: _backgroundColor,
      dialogBackgroundColor: _backgroundColor,
      scaffoldBackgroundColor: _backgroundColor,
      indicatorColor: AppColors.white,
      iconTheme: _iconTheme,
      appBarTheme: _appBarTheme,
      dividerTheme: _dividerTheme,
      textTheme: _textTheme,
      inputDecorationTheme: _inputDecorationTheme,
      buttonTheme: _buttonTheme,
      splashColor: AppColors.transparent,
      snackBarTheme: _snackBarTheme,
      textButtonTheme: _textButtonTheme,
      colorScheme: _colorScheme,
      bottomSheetTheme: _bottomSheetTheme,
      listTileTheme: _listTileTheme,
      switchTheme: _switchTheme,
      progressIndicatorTheme: _progressIndicatorTheme,
      tabBarTheme: _tabBarTheme,
      bottomNavigationBarTheme: _bottomAppBarTheme,
      chipTheme: _chipTheme,
      checkboxTheme: _checkboxTheme,
      datePickerTheme: _datePickerTheme,
      dialogTheme: _dialogTheme,
      dropdownMenuTheme: _dropdownTheme,
      menuButtonTheme: _menuButtonTheme,
      searchBarTheme: _searchBarTheme,
      iconButtonTheme: _iconButtonTheme,
      radioTheme: _radioTheme,
    );
  }

  ColorScheme get _colorScheme {
    return ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: _backgroundColor,
    );
  }

  RadioThemeData get _radioTheme {
    return const RadioThemeData(
      fillColor: WidgetStatePropertyAll<Color>(AppColors.primary),
    );
  }

  SnackBarThemeData get _snackBarTheme {
    return SnackBarThemeData(
        contentTextStyle: UITextStyle.bodyLarge.copyWith(
          color: AppColors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        actionTextColor: AppColors.white,
        backgroundColor: AppColors.primaryDark,
        elevation: 3,
        behavior: SnackBarBehavior.floating,
        insetPadding: const EdgeInsets.symmetric(horizontal: 10));
  }

  Color get _backgroundColor => AppColors.white;

  AppBarTheme get _appBarTheme {
    return AppBarTheme(
      iconTheme: _iconTheme,
      titleTextStyle: _textTheme.headlineMedium,
      elevation: 0,
      toolbarHeight: 46,
      backgroundColor: AppColors.transparent,
      surfaceTintColor: AppColors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  IconThemeData get _iconTheme {
    return const IconThemeData(
      color: AppColors.onBackground,
      size: 20,
    );
  }

  CheckboxThemeData get _checkboxTheme {
    return const CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    );
  }

  DropdownMenuThemeData get _dropdownTheme {
    return const DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(AppColors.white),
        surfaceTintColor: MaterialStatePropertyAll<Color>(AppColors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        constraints: BoxConstraints(maxHeight: 48),
        isDense: true,
      ),
    );
  }

  MenuButtonThemeData get _menuButtonTheme {
    return MenuButtonThemeData(
      style: MenuItemButton.styleFrom(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shadowColor: AppColors.white,
        textStyle: const TextStyle(
          fontSize: 16,
          fontFamily: FontFamily.plusJakartaSans,
        ),
      ),
    );
  }

  DividerThemeData get _dividerTheme {
    return const DividerThemeData(
      color: AppColors.pastelGrey,
      space: AppSpacing.lg,
      thickness: AppSpacing.xxxs,
      indent: AppSpacing.lg,
      endIndent: AppSpacing.lg,
    );
  }

  IconButtonThemeData get _iconButtonTheme {
    return IconButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.resolveWith((states) => 0),
        shape: MaterialStateProperty.resolveWith(
          (states) => const CircleBorder(),
        ),
      ),
    );
  }

  DatePickerThemeData get _datePickerTheme {
    return DatePickerThemeData(
      surfaceTintColor: Colors.transparent,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      dayStyle: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontWeight: FontWeight.w500,
      ),
      weekdayStyle: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontWeight: FontWeight.w500,
      ),
      yearStyle: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontWeight: FontWeight.w500,
      ),
      headerHelpStyle: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontWeight: FontWeight.w500,
      ),
      headerHeadlineStyle: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontWeight: FontWeight.w700,
        fontSize: 32,
      ),
      cancelButtonStyle: const ButtonStyle(
        enableFeedback: true,
        textStyle: MaterialStatePropertyAll<TextStyle>(
          TextStyle(
            fontFamily: FontFamily.plusJakartaSans,
          ),
        ),
      ),
      confirmButtonStyle: const ButtonStyle(
        enableFeedback: true,
        textStyle: MaterialStatePropertyAll<TextStyle>(
          TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: FontFamily.plusJakartaSans,
          ),
        ),
      ),
    );
  }

  TextTheme get _textTheme => uiTextTheme;

  /// The UI text theme based on [UITextStyle].
  static final uiTextTheme = TextTheme(
    displayLarge: UITextStyle.displayLarge,
    displayMedium: UITextStyle.displayMedium,
    displaySmall: UITextStyle.displaySmall,
    headlineLarge: UITextStyle.headlineLarge,
    headlineMedium: UITextStyle.headlineMedium,
    headlineSmall: UITextStyle.headlineSmall,
    titleMedium: UITextStyle.titleMedium,
    titleSmall: UITextStyle.titleSmall,
    bodyLarge: UITextStyle.bodyLarge,
    bodyMedium: UITextStyle.bodyMedium,
    bodySmall: UITextStyle.bodySmall,
    labelLarge: UITextStyle.labelLarge,
    labelMedium: UITextStyle.label,
    labelSmall: UITextStyle.labelSmall,
  ).apply(
    bodyColor: AppColors.black,
    displayColor: AppColors.black,
    decorationColor: AppColors.black,
  );

  InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      suffixIconColor: const Color(0xFF667085),
      prefixIconColor: const Color(0xFF667085),
      hoverColor: AppColors.inputHover,
      focusColor: AppColors.inputFocused,
      fillColor: AppColors.inputEnabled,
      enabledBorder: _textFieldBorder,
      focusedBorder: _textFieldFocusBorder,
      disabledBorder: _textFieldBorder,
      errorBorder: _textFieldErrorBorder,
      focusedErrorBorder: _textFieldErrorBorder,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      isDense: true,
      filled: true,
      errorStyle: UITextStyle.inputError,
      floatingLabelBehavior: FloatingLabelBehavior.never,
    );
  }

  ButtonThemeData get _buttonTheme {
    return ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
    );
  }

  SearchBarThemeData get _searchBarTheme {
    return SearchBarThemeData(
      elevation: MaterialStateProperty.resolveWith((states) => 0.5),
      surfaceTintColor:
          MaterialStateColor.resolveWith((states) => Colors.white),
      side: MaterialStateBorderSide.resolveWith(
        (states) => const BorderSide(
          color: AppColors.pastelGrey,
        ),
      ),
      shape: MaterialStateProperty.resolveWith(
        (states) => const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: Color(0xffe0e0e0), width: 0.8),
        ),
      ),
    );
  }

  CardTheme get _cardTheme {
    return CardTheme(
      color: AppColors.white,
      surfaceTintColor: AppColors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.pastelGrey, width: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
    );
  }

  ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: EdgeInsets.zero,
        textStyle: _textTheme.labelLarge,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.pastelGrey,
        surfaceTintColor: AppColors.transparent,
        minimumSize: const Size(100, 48),
        shadowColor: AppColors.shadow,
      ),
    );
  }

  TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: _textTheme.bodyMedium?.copyWith(
          fontWeight: AppFontWeight.regular,
          height: 0,
        ),
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.primary,
        backgroundColor: AppColors.transparent,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        enableFeedback: true,
      ),
    );
  }

  BottomSheetThemeData get _bottomSheetTheme {
    return const BottomSheetThemeData(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.transparent,
      //clipBehavior: Clip.hardEdge,
      constraints: BoxConstraints(
        minWidth: double.maxFinite,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    );
  }

  ListTileThemeData get _listTileTheme {
    return ListTileThemeData(
        tileColor: AppColors.white,
        iconColor: AppColors.lightBlack,
        contentPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        titleTextStyle: _textTheme.headlineMedium,
        subtitleTextStyle: const TextStyle(
          color: AppColors.lightBlack,
          fontSize: 11.5,
          fontWeight: AppFontWeight.medium,
          fontFamily: FontFamily.plusJakartaSans,
        ),
        enableFeedback: true);
  }

  SwitchThemeData get _switchTheme {
    return SwitchThemeData(
      thumbColor:
          MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.darkAqua;
        }
        return AppColors.eerieBlack;
      }),
      trackColor:
          MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryContainer;
        }
        return AppColors.paleSky;
      }),
    );
  }

  ProgressIndicatorThemeData get _progressIndicatorTheme {
    return const ProgressIndicatorThemeData(
      color: AppColors.darkAqua,
      circularTrackColor: AppColors.borderOutline,
    );
  }

  TabBarTheme get _tabBarTheme {
    return TabBarTheme(
        labelStyle: UITextStyle.titleMedium,
        unselectedLabelStyle: UITextStyle.titleMedium,
        labelColor: AppColors.white,
        labelPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md - AppSpacing.xxs,
        ),
        unselectedLabelColor: AppColors.grey,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.primary,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerHeight: 0);
  }

  DialogTheme get _dialogTheme {
    return DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      actionsPadding: const EdgeInsets.only(right: 20, bottom: 15),
      surfaceTintColor: Colors.white,
      titleTextStyle: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: AppColors.lightBlack,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: FontFamily.plusJakartaSans,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.lightBlack,
      ),
    );
  }
}

InputBorder get _textFieldBorder => OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
      borderRadius: BorderRadius.circular(7),
    );

InputBorder get _textFieldFocusBorder => OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primary),
      borderRadius: BorderRadius.circular(7),
    );

InputBorder get _textFieldErrorBorder => OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.red),
      borderRadius: BorderRadius.circular(7),
    );

BottomNavigationBarThemeData get _bottomAppBarTheme {
  return BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkBackground,
    selectedItemColor: AppColors.white,
    unselectedItemColor: AppColors.white.withOpacity(0.74),
  );
}

ChipThemeData get _chipTheme {
  return ChipThemeData(
    labelStyle: UITextStyle.label.copyWith(
      fontWeight: AppFontWeight.semiBold,
    ),
    surfaceTintColor: Colors.white,
    backgroundColor: Colors.white,
    selectedColor: AppColors.primaryLight.withOpacity(0.4),
    secondarySelectedColor: Colors.white,
    disabledColor: Colors.grey.shade100,
    showCheckmark: false,
    side: BorderSide.none,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );
}

/// {@template app_dark_theme}
/// Dark Mode App [ThemeData].
/// {@endtemplate}
class AppDarkTheme extends AppTheme {
  /// {@macro app_dark_theme}
  const AppDarkTheme();

  @override
  ColorScheme get _colorScheme {
    return const ColorScheme.dark().copyWith(
      primary: AppColors.white,
      secondary: AppColors.secondary,
      background: AppColors.grey.shade900,
    );
  }

  @override
  SnackBarThemeData get _snackBarTheme {
    return SnackBarThemeData(
      contentTextStyle: UITextStyle.bodyLarge.copyWith(
        color: AppColors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      actionTextColor: AppColors.lightBlue.shade300,
      backgroundColor: AppColors.grey.shade300,
      elevation: 4,
      behavior: SnackBarBehavior.floating,
    );
  }

  @override
  TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: _textTheme.labelLarge?.copyWith(
          fontWeight: AppFontWeight.light,
        ),
        foregroundColor: AppColors.white,
      ),
    );
  }

  @override
  Color get _backgroundColor => AppColors.grey.shade900;

  @override
  IconThemeData get _iconTheme {
    return const IconThemeData(color: AppColors.black);
  }

  @override
  DividerThemeData get _dividerTheme {
    return const DividerThemeData(
      color: AppColors.brightGrey,
      space: AppSpacing.lg,
      thickness: AppSpacing.xxxs,
      indent: AppSpacing.lg,
      endIndent: AppSpacing.lg,
    );
  }
}
