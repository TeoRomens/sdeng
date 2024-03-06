import 'package:flutter/material.dart';
import 'package:sdeng/utils/constants.dart';

const defaultFontFamily = 'ProductSans';

final ThemeData themeData = ThemeData(
  useMaterial3: true,
  fontFamily: defaultFontFamily,
  dialogBackgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xffE7E6FF),
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Color(0xff4D46B2),
      fontFamily: defaultFontFamily,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    iconTheme: IconThemeData(
      color: Color(0xff4D46B2),
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    surfaceTintColor: Colors.white,
    backgroundColor: Colors.white,
    constraints: BoxConstraints(
      minWidth: double.maxFinite
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10))
    )
  ),
  colorScheme: const ColorScheme.light(
    primary: primaryColor,
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    surfaceTintColor: Colors.white,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xffcccccc), width: 0.8),
        borderRadius: BorderRadius.circular(12)
    ),
    elevation: 0,
  ),
  chipTheme: ChipThemeData(
      backgroundColor: Colors.grey.shade200,
      selectedColor: Colors.grey.shade200,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      showCheckmark: false,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      labelStyle: const TextStyle(
        fontFamily: defaultFontFamily,
      )
  ),
  checkboxTheme: const CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
    side: BorderSide(
        width: 1
    ),
  ),
  dialogTheme: const DialogTheme(
    surfaceTintColor: Colors.white,
    titleTextStyle: TextStyle(
      fontFamily: defaultFontFamily,
    ),
    contentTextStyle: TextStyle(
      fontFamily: defaultFontFamily,
    ),
  ),
  dividerTheme: DividerThemeData(
      color: Colors.grey.shade300,
      space: 60
  ),
  dropdownMenuTheme: const DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
        surfaceTintColor: MaterialStatePropertyAll<Color>(Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        constraints: BoxConstraints(maxHeight: 48),
        isDense: true,
      )
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.zero,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      textStyle: const TextStyle(
          color: Colors.white,
          fontFamily: defaultFontFamily,
          fontSize: 19,
          fontWeight: FontWeight.bold
      ),
      minimumSize: const Size(100, 48),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
  ),
  expansionTileTheme: ExpansionTileThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: Color(0xffcccccc)),
      borderRadius: BorderRadius.circular(12)
    ),
    collapsedShape: RoundedRectangleBorder(
      side: const BorderSide(color: Color(0xffcccccc)),
      borderRadius: BorderRadius.circular(12)
    ),
    iconColor: Colors.black,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xffe7e6ff),
      shape: CircleBorder(side: BorderSide.none),
      foregroundColor: primaryColor,
      elevation: 1,
      enableFeedback: true
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
    labelStyle: TextStyle(
      color: Colors.grey.shade500,
    ),
    errorStyle: const TextStyle(
      color: Color(0xFFef4444),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: primaryLightColor),
      borderRadius: BorderRadius.circular(7),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xffcccccc),),
      borderRadius: BorderRadius.circular(7),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFef4444),),
      borderRadius: BorderRadius.circular(7),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFef4444),),
      borderRadius: BorderRadius.circular(7),
    ),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: Colors.white,
    iconColor: Colors.grey,
    titleTextStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontFamily: defaultFontFamily
    ),
    subtitleTextStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 13,
        fontFamily: defaultFontFamily
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: Color(0xffe0e0e0), width: 0.8),
    ),
  ),
  menuButtonTheme: MenuButtonThemeData(
      style: MenuItemButton.styleFrom(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        textStyle: const TextStyle(
            fontSize: 16,
            fontFamily: defaultFontFamily
        ),
      )
  ),
  searchBarTheme: SearchBarThemeData(
      elevation: MaterialStateProperty.resolveWith((states) => 0.5),
      surfaceTintColor: MaterialStateColor.resolveWith((states) => Colors.white),
      side: MaterialStateBorderSide.resolveWith((states) => const BorderSide(color: Color(0xffcccccc),)),
      shape: MaterialStateProperty.resolveWith((states) => const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(color: Color(0xffe0e0e0), width: 0.8),
      ),)
  ),
  tabBarTheme: TabBarTheme(
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: primaryLightColor2,
      ),
      labelColor: Colors.white,
      unselectedLabelColor: Colors.black.withOpacity(0.7),
      labelStyle: const TextStyle(
          fontFamily: defaultFontFamily,
          fontWeight: FontWeight.bold,
          fontSize: 15
      ),
      unselectedLabelStyle: const TextStyle(
          fontFamily: defaultFontFamily,
          fontWeight: FontWeight.bold,
          fontSize: 15
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 10)
  ),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          fontFamily: defaultFontFamily
        ),
        foregroundColor: primaryColor,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6)
        ),
      )
  ),
  textTheme: const TextTheme(
    displaySmall: TextStyle(
        fontFamily: defaultFontFamily
    ),
    displayMedium: TextStyle(
      fontFamily: defaultFontFamily
    ),
    displayLarge: TextStyle(
        fontFamily: defaultFontFamily
    ),
  ),
);