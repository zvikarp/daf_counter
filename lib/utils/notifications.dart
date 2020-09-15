import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/utils/localization.dart';

class NotificationsUtil {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future _onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
  }

  Future<void> setDailyNotification(TimeOfDay time) async {
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
    print("notification set for");
    print(time.hour);
    print(time.minute);
    await _flutterLocalNotificationsPlugin.showDailyAtTime(
        Consts.DAILY_REMINDER_NOTIFICATION_ID,
        localizationUtil.translate("onboarding", "did_you_daf"),
        localizationUtil.translate("onboarding", "mark_daf"),
        Time(time.hour, time.minute, 0),
        platformChannelSpecifics);
  }

  Future<void> cancelDailyNotification() async {
    await _flutterLocalNotificationsPlugin
        .cancel(Consts.DAILY_REMINDER_NOTIFICATION_ID);
  }
}

final NotificationsUtil notificationsUtil = NotificationsUtil();
