import 'package:flutter/material.dart';
import 'package:sdeng/utils/constants.dart';

final ThemeData themeData = ThemeData(
  useMaterial3: true,
  fontFamily: 'ProductSans',
  dialogBackgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xffE7E6FF),
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Color(0xff4D46B2),
      fontFamily: 'ProductSans',
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    iconTheme: IconThemeData(
      color: Color(0xff4D46B2),
    ),
  ),
  colorScheme: const ColorScheme.light(
    primary: primaryColor,
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
        fontFamily: 'ProductSans',
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
      fontFamily: 'ProductSans',
    ),
    contentTextStyle: TextStyle(
      fontFamily: 'ProductSans',
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
          fontFamily: 'ProductSans',
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
    backgroundColor: const Color(0xffe8e8e8),
    collapsedBackgroundColor: const Color(0xffe8e8e8),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
    ),
    collapsedShape: RoundedRectangleBorder(
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
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7)
    ),
    tileColor: Colors.transparent,
    titleTextStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontFamily: 'ProductSans'
    ),
  ),
  menuButtonTheme: MenuButtonThemeData(
      style: MenuItemButton.styleFrom(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        textStyle: const TextStyle(
            fontSize: 16,
            fontFamily: 'ProductSans'
        ),
      )
  ),
  searchBarTheme: SearchBarThemeData(
      elevation: MaterialStateProperty.resolveWith((states) => 0.5),
      surfaceTintColor: MaterialStateColor.resolveWith((states) => Colors.white),
      side: MaterialStateBorderSide.resolveWith((states) => const BorderSide(color: Color(0xffcccccc),)),
      shape: MaterialStateProperty.resolveWith((states) => const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
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
          fontFamily: 'ProductSans',
          fontWeight: FontWeight.bold,
          fontSize: 15
      ),
      unselectedLabelStyle: const TextStyle(
          fontFamily: 'ProductSans',
          fontWeight: FontWeight.bold,
          fontSize: 15
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 10)
  ),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6)
        ),
      )
  ),
);