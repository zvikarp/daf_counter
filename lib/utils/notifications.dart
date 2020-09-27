import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/utils/platform.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/utils/localization.dart';

class NotificationsUtil {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Future _onSelectNotification(String payload) async {
    if (platformUtil.isAndroid() && payload != null) {
      if (payload == Consts.DAILY_REMINDER_NOTIFICATION_PAYLOAD) {
        progressAction.learnedTodaysDaf();
      }
    } else {
      return false;
    }
  }

  void init() {
    if (platformUtil.isAndroid()) {
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('ic_stat_white_logo');
      InitializationSettings initializationSettings = InitializationSettings(
          initializationSettingsAndroid, IOSInitializationSettings());
      _flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: _onSelectNotification);
    }
  }

  Future<void> setDailyNotification(TimeOfDay time) async {
    if (platformUtil.isAndroid() && _flutterLocalNotificationsPlugin != null) {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        Consts.DAILY_REMINDER_NOTIFICATION_CHANNEL_ID,
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
          platformChannelSpecifics,
          payload: Consts.DAILY_REMINDER_NOTIFICATION_PAYLOAD);
    }
  }

  Future<void> cancelDailyNotification() async {
    if (platformUtil.isAndroid() && _flutterLocalNotificationsPlugin != null) {
      await _flutterLocalNotificationsPlugin
          .cancel(Consts.DAILY_REMINDER_NOTIFICATION_ID);
    } else {
      return false;
    }
  }
}

final NotificationsUtil notificationsUtil = NotificationsUtil();
