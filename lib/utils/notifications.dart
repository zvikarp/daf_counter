import 'package:daf_plus_plus/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/utils/localization.dart';

class NotificationsUtil {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      platformUtil.isAndroid() ? FlutterLocalNotificationsPlugin() : null;

  Future _onSelectNotification(String payload) async {
    if (platformUtil.isAndroid() && payload != null) {
      print('notification payload: ' + payload);
    } else {
      return false;
    }
  }

  Future<void> setDailyNotification(TimeOfDay time) async {
    if (platformUtil.isAndroid()) {
      AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('ic_launcher');
      InitializationSettings initializationSettings = InitializationSettings(
          initializationSettingsAndroid, IOSInitializationSettings());
      _flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: _onSelectNotification);

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description',
      );
      NotificationDetails platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, IOSNotificationDetails());
      await _flutterLocalNotificationsPlugin.showDailyAtTime(
          Consts.DAILY_REMINDER_NOTIFICATION_ID,
          localizationUtil.translate("onboarding", "did_you_daf"),
          localizationUtil.translate("onboarding", "mark_daf"),
          Time(time.hour, time.minute, 0),
          platformChannelSpecifics);
    } else {
      return false;
    }
  }

  Future<void> cancelDailyNotification() async {
    if (platformUtil.isAndroid()) {
      await _flutterLocalNotificationsPlugin
          .cancel(Consts.DAILY_REMINDER_NOTIFICATION_ID);
    } else {
      return false;
    }
  }
}

final NotificationsUtil notificationsUtil = NotificationsUtil();
