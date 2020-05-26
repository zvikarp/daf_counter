import 'package:flutter/material.dart';

import 'package:daf_plus_plus/utils/gematriaConverter.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:kosher_dart/hebrewcalendar/jewish_date.dart';

class DateConverterUtil {
  DateTime getToday() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  String getDayInWeek(DateTime date) {
    return localizationUtil.translate(
        "calendar", "days_in_week")[date.weekday % 7];
  }

  String toEnglishDate(DateTime date) {
    int month = date?.month ?? -1;
    int day = date?.day ?? -1;
    if (month + day < 0) return "";
    String monthName =
        localizationUtil.translate("calendar", "english_months")[month - 1];
    return monthName + " " + day.toString();
  }

  String toHebrewDate(DateTime date) {
    int month = date?.month ?? -1;
    int day = date?.day ?? -1;
    if (month + day < 0) return "";
    JewishDate hebrewDate = JewishDate.fromDateTime(date);
    int hebrewMonth = hebrewDate.jewishMonth;
    bool useGematria = localizationUtil.translate(
        "calendar", "display_hebrew_dates_as_gematria");
    String hebrewDay = useGematria
        ? gematriaConverterUtil.toGematria(hebrewDate.jewishDay)
        : hebrewDate.jewishDay.toString();
    String monthName = localizationUtil.translate(
        "calendar", "hebrew_months")[hebrewMonth - 1];
    return hebrewDay + " " + monthName;
  }

  int getReletiveDateIndex(DateTime date) {
    return -1;
  }

  String timeToString(TimeOfDay time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  TimeOfDay stringToTime(String time, [TimeOfDay defaultTime]) {
    try {
      List<String> hourAndMinutes = time.split(':');
      return TimeOfDay(
          hour: int.parse(hourAndMinutes[0]),
          minute: int.parse(hourAndMinutes[1]));
    } catch (err) {
      return defaultTime;
    }
  }
}

final DateConverterUtil dateConverterUtil = DateConverterUtil();
