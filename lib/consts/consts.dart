import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:daf_plus_plus/enums/progressType.dart';

class Consts {
  static const double MASECHET_LIST_HEIGHT = 400;

  static const int PROGRESS_BACKUP_THRESHOLD = 5;
  static const int FIST_DAF = 2;
  static const int FIST_PEREK = 1;
  static const String DAF_YOMI_START_DATE = '2020-01-05';
  static const String DEFAUT_MASECHET = 'brachos';
  static const bool DEFAULT_IS_DAF_YOMI = true;
  static const bool DEFAULT_IS_MISHNA = false;
  static const int DEFAUT_DAF = 0;
  static const String DATA_DIVIDER = ',';
  static const int MAX_REVISIONS = 10000;
  static const int DEFAULT_BUILD_NUMBER = 9;

  static const String PROJECT_URL =
      "https://github.com/capslock-bmdc/daf_plus_plus";

  static const List<Locale> LOCALES = [Locale("he", "IL"), Locale("en", "US")];
  static const Locale DEFAULT_LOCALE = Locale("he", "IL");
  static const String DEFAULT_CALENDAR_TYPE = "english_calendar";
  static const String DEFAULT_THEME_TYPE = "light_theme";
  static const TimeOfDay DEFAULT_NOTIFICATION_TIME =
      TimeOfDay(hour: 19, minute: 0);

  static const int DAILY_REMINDER_NOTIFICATION_ID = 0;
  static const String DAILY_REMINDER_NOTIFICATION_PAYLOAD = "daily_reminder";
  static const String DAILY_REMINDER_NOTIFICATION_CHANNEL_ID = "daily_reminder";

  static const ProgressType DEFAULT_PROGRESS_TYPE = ProgressType.PROGRESS_TB;
  static const String PROGRESS_PREFIX_DIVIDER = ":";
  static const Map<ProgressType, String> PROGRESS_PREFIXES = {
    DEFAULT_PROGRESS_TYPE: "",
    ProgressType.PROGRESS_MISHNA: "mishna$PROGRESS_PREFIX_DIVIDER",
  };
}
