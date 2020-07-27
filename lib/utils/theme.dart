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
        canvasColor: Colors.blueGrey[50],
        errorColor: Color(0xFFED4337).withOpacity(0.7),
        disabledColor: Colors.teal[300],

        // typography
        textTheme: GoogleFonts.alefTextTheme(
          Theme.of(context).textTheme,
        ).merge(
          TextTheme(
            button: TextStyle(
              fontSize: 18,
              color: Colors.black,
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
              color: Colors.black,
            ),
            caption: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ),

      // dark theme
      "dark_theme": ThemeData(
        // colors
        brightness: Brightness.dark,
        primaryColor: Colors.indigo[700],
        accentColor: Colors.teal[700],
        canvasColor: Colors.blueGrey[900],
        backgroundColor: Colors.blueGrey[900],
        errorColor: Color(0xFFED4337).withOpacity(0.7),

        // typography
        textTheme: GoogleFonts.alefTextTheme(
          Theme.of(context).textTheme,
        ).merge(
          TextTheme(
            button: TextStyle(
              fontSize: 18,
              color: Colors.white,
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
              color: Colors.white,
            ),
            caption: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ),
    };

    return themes[themeName];
  }
}

ThemeUtil themeUtil = ThemeUtil();
