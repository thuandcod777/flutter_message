import 'package:flutter/material.dart';
import 'package:flutter_message/colors.dart';
import 'package:google_fonts/google_fonts.dart';

final appBarTheme = AppBarTheme(
    centerTitle: false, elevation: 0, backgroundColor: Colors.white);

ThemeData lightTheme(BuildContext context) => ThemeData.light().copyWith(
    primaryColor: kPrimary,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme,
    iconTheme: IconThemeData(color: kIconLight),
    textTheme: GoogleFonts.comfortaaTextTheme(Theme.of(context).textTheme)
        .apply(displayColor: Colors.black),
    visualDensity: VisualDensity.adaptivePlatformDensity);

ThemeData darkTheme(BuildContext context) => ThemeData.dark().copyWith(
    primaryColor: kPrimary,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: appBarTheme,
    iconTheme: IconThemeData(color: kAppBarDark),
    textTheme: GoogleFonts.comfortaaTextTheme(Theme.of(context).textTheme)
        .apply(displayColor: Colors.white),
    visualDensity: VisualDensity.adaptivePlatformDensity);

bool isLightTheme(BuildContext context) {
  return MediaQuery.of(context).platformBrightness == Brightness.light;
}
