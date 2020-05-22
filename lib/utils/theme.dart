import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/scheduler.dart';

class ThemeUtil {
  ThemeData getTheme(BuildContext context, String themeName) {
    if (themeName == "default_theme") {
      try {
        var brightness = SchedulerBinding.instance.window.platformBrightness;
        bool darkModeOn = brightness == Brightness.dark;
        if (darkModeOn)
          themeName = "dark_theme";
        else
          themeName = "light_theme";
      } catch (err) {
        themeName = "light_mode";
      }
    }

    Map<String, ThemeData> themes = {
      "light_theme": ThemeData(
        // colors
        brightness: Brightness.light,
        primaryColor: Colors.indigo[500],
        accentColor: Colors.teal[300],
        backgroundColor: Colors.blueGrey[50],

        // typography
        textTheme: GoogleFonts.alefTextTheme(
          Theme.of(context).textTheme,
        ).merge(
          TextTheme(
            button: TextStyle(
              fontSize: 18,
            ),
            bodyText1: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            bodyText2: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            headline3: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
            headline5: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            headline6: TextStyle(
              fontSize: 24,
            ),
            caption: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ),

      // dark theme
      "dark_theme": ThemeData(
        // colors
        brightness: Brightness.dark,
        primaryColor: Colors.red[500],
        accentColor: Colors.yellow[300],
        backgroundColor: Colors.blueGrey[50],

        // typography
        textTheme: GoogleFonts.alefTextTheme(
          Theme.of(context).textTheme,
        ).merge(
          TextTheme(
            button: TextStyle(
              fontSize: 18,
            ),
            bodyText1: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            bodyText2: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            headline3: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
            headline5: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            headline6: TextStyle(
              fontSize: 24,
            ),
            caption: TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ),
    };

    return themes[themeName];
  }
}

ThemeUtil themeUtil = ThemeUtil();
