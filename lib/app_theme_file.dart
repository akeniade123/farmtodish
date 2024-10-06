// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class FarmToDishTheme {
  static Color highlightBlue = Color(0xff017CC6);
  static Color scaffoldBackgroundColor = Color(0xffE8FCEF);
  static Color accentLightColor = Color(0xffC0E5C9);
  static Color faintGreen = Color(0xff029534);
  static Color deepGreen = Color(0xff315227);
  static Color borderColor = Color(0xffD9D9D9);
  static Color themeRed = Color(0xffCC000E);

  static TextStyle listMainText =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black);
  static TextStyle listSubText =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black);

// CC000E
  static TextTheme lightTextTheme = TextTheme(
    // bodyMedium: ,
    bodyLarge: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
    displayLarge: TextStyle(
        fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
    displayMedium: TextStyle(
        fontSize: 21, fontWeight: FontWeight.w700, color: Colors.black),
    displaySmall: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
    titleLarge: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodySmall: TextStyle(
        fontSize: 10.0, fontWeight: FontWeight.w600, color: Colors.white),
    bodyLarge: TextStyle(
        fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.white),
    displayLarge: TextStyle(
        fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
    displayMedium: TextStyle(
        fontSize: 21.0, fontWeight: FontWeight.w700, color: Colors.white),
    displaySmall: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
    titleLarge: TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
  );
  static AppBarTheme lightAppBarTheme = AppBarTheme(
      // color: Colors.black,
      actionsIconTheme: IconThemeData(color: Colors.black),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: (Colors.white),
      elevation: 0,
      titleTextStyle: TextStyle(
          color: Colors.black, fontWeight: FontWeight.normal, fontSize: 18.0));
  static AppBarTheme darkAppBarTheme = AppBarTheme(
      actionsIconTheme: IconThemeData(color: Colors.black),
      backgroundColor: (Colors.white),
      elevation: 0,
      titleTextStyle: TextStyle(
          color: Colors.black, fontWeight: FontWeight.normal, fontSize: 18.0));
  static BottomNavigationBarThemeData lightBottomNavigationBarThemeData =
      BottomNavigationBarThemeData(
    selectedItemColor: Color.fromARGB(255, 188, 66, 174),
  );
  static BottomNavigationBarThemeData darkBottomNavigationBarThemeData =
      BottomNavigationBarThemeData(selectedItemColor: Colors.amber);
  static TextSelectionThemeData lightTextSelectionThemeData =
      TextSelectionThemeData(
    cursorColor: faintGreen,
    //  Color.fromARGB(255, 188, 66, 174),
  );
  static TextButtonThemeData lightTextButtonThemeData = TextButtonThemeData(
    style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(highlightBlue
            // Color.fromARGB(255, 188, 66, 174),
            )),
  );

  static ThemeData light() {
    return ThemeData(
      // inputDecorationTheme: InputDecorationTheme(border: ),
      // datePickerTheme: DatePickerThemeData(color),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStatePropertyAll(faintGreen
            // Color.fromARGB(255, 69, 22, 147),
            ),
      ),
      // radioTheme: RadioThemeData(
      //     fillColor: MaterialStateColor.resolveWith(
      //         (states) => Color.fromARGB(255, 69, 22, 147))),
      disabledColor: Colors.grey,
      buttonTheme: ButtonThemeData(disabledColor: Colors.grey),
      textButtonTheme: lightTextButtonThemeData,
      primaryColorLight: Color.fromARGB(255, 188, 66, 174),
      textSelectionTheme: lightTextSelectionThemeData,
      hoverColor: Colors.transparent,
      appBarTheme: lightAppBarTheme,
      bottomNavigationBarTheme: lightBottomNavigationBarThemeData,
      // colorSchemeSeed:
      brightness: Brightness.light,
      // primaryColor: Color.fromARGB(255, 69, 22, 147),
      colorSchemeSeed: Color.fromARGB(255, 69, 22, 147),
      hintColor: Colors.black,
      // textSelectionTheme:
      //     const TextSelectionThemeData(selectionColor: Colors.green),
      textTheme: lightTextTheme,
    );
  }

  static TextStyle iStyle = TextStyle(
      fontSize: 10.0, fontWeight: FontWeight.w600, color: Colors.black);
  static BoxShadow genericBoxShadow = BoxShadow(
      blurRadius: 2, offset: Offset(0, 1), color: Color.fromRGBO(0, 0, 0, .06));

  static ThemeData dark() {
    return ThemeData(
      textButtonTheme: lightTextButtonThemeData,
      appBarTheme: lightAppBarTheme,
      bottomNavigationBarTheme: lightBottomNavigationBarThemeData,
      brightness: Brightness.dark,
      primaryColor: Colors.grey[900],
      hintColor: Colors.green[600],
      textTheme: darkTextTheme,
    );
  }
}
