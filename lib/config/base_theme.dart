import 'package:flutter/material.dart';

TextStyle defaultFontStyles = const TextStyle(
    fontFamily: "SansPro",
    fontWeight: FontWeight.w300,
    color: Color(0xff000000));

class BaseTheme {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xffffffff),
    primaryColor: const Color(0xff42889e),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xff42889e),
    ),
    colorScheme: const ColorScheme.light(),
    appBarTheme: AppBarTheme(
      titleTextStyle: defaultFontStyles,
      backgroundColor: Colors.indigoAccent,
    ),
    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.indigoAccent),
    primaryTextTheme: TextTheme(
        headline1: defaultFontStyles.copyWith(fontWeight: FontWeight.w400),
        headline2: defaultFontStyles),
    tabBarTheme: TabBarTheme(
      indicator: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
        color: Color(0xff42889e),
      ),
      unselectedLabelColor: const Color(0xffcccccc),
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: const Color(0xffffffff),
      labelStyle: defaultFontStyles,
    ),
  );
}
