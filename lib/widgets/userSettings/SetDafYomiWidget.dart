import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/pages/home.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/toast.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class SetDafYomiWidget extends StatefulWidget {
  @override
  _SetDafYomiWidgetState createState() => _SetDafYomiWidgetState();
}

class _SetDafYomiWidgetState extends State<SetDafYomiWidget> {
  bool _shouldShowNotifications = false;
  TimeOfDay _notificationsTime = Consts.DEFAULT_NOTIFICATION_TIME;
  bool _doesDafYomi = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void _changeDafYomi(bool doesDaf) async {
    hiveService.settings.setIsDafYomi(doesDaf);
    _getDoesDaf();
  }

  void _getDoesDaf() {
    setState(() => _doesDafYomi = hiveService.settings.getIsDafYomi());
  }

  void _changeShowNotifications(bool showNotifications) async {
    hiveService.settings.setShowNotifications(showNotifications);
    _getShowNotifications();
  }

  void _getShowNotifications() {
    setState(() =>
    _shouldShowNotifications = hiveService.settings.getShowNotifications());
  }

  void _changeNotificationsTime() async {
    TimeOfDay time =
    await showTimePicker(context: context, initialTime: _notificationsTime);
    if (time != null) {
      hiveService.settings.setNotificationsTime(time);
      _getNotificationsTime();
      setRepeatingNotification();
    }
  }

  void _getNotificationsTime() {
    setState(() => _notificationsTime =
        hiveService.settings.getNotificationsTime() ??
            Consts.DEFAULT_NOTIFICATION_TIME);
  }

  void _initNotificationInfo() {
    final initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');
    final initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    final categories = [
      NotificationCategory(
        "MY_NOTIFICATION_CATEGORY",
        [
          NotificationAction("Mark as Read", "ACTION_YAY"),
          NotificationAction("Not Yet", "ACTION_NAY"),
        ],
      ),
    ];
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
      onSelectNotificationAction: onSelectNotificationAction,
      categories: categories,
    );
  }

  Future onDidReceiveLocalNotification(int id, String title, String body,
      String payload) {
  }


  Future<void> setRepeatingNotification() async {
    var androidDetails = AndroidNotificationDetails(
      'notification with actions channel id',
      'notification with actions channel name',
      'notification with actions channel description',
    );
    var iosDetails = IOSNotificationDetails();
    var details = NotificationDetails(androidDetails, iosDetails);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
        613,
        'Did the Daf?',
        'Did you learn today\'s daf?',
        Time(_notificationsTime.hour, _notificationsTime.minute),
        details,
        categoryIdentifier: "MY_NOTIFICATION_CATEGORY",
        payload: '');
    toastUtil.showInformation(
        localizationUtil.translate("settings", "notification_set"));
  }


  Future<void> onSelectNotificationAction(NotificationActionData data) async {
    print("Payload is: ********  " + data.payload + "***********");
    print(data);
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    if (data.actionIdentifier == "ACTION_YAY") {
      DateTime dateTime = dateFormat.parse(data.payload);
      DafModel todaysDaf = dafsDatesStore.getDafByDate(
          DateTime(dateTime.year, dateTime.month, dateTime.day));
      ProgressModel progress = progressAction.get(todaysDaf.masechetId);
      progress.data[todaysDaf.number] = 1; // TODO: really not ideal.
      progressAction.update(todaysDaf.masechetId, progress, 5);
      hiveService.settings.setLastDaf(todaysDaf);
    }
  }

  Future onSelectNotification(String payload) async {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => HomePage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getDoesDaf();
    _getShowNotifications();
    _getNotificationsTime();
    _initNotificationInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              localizationUtil.translate("settings", "do_you_daf"),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Switch(
              value: _doesDafYomi,
              activeColor: Theme.of(context).primaryColor,
              onChanged: _changeDafYomi,
            ),
          ),
          if (_doesDafYomi) ListTile(
            title: Text(
              localizationUtil.translate(
                  "settings", "should_show_notifications"),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Switch(
              value: _shouldShowNotifications,
              activeColor: Theme.of(context).primaryColor,
              onChanged: _changeShowNotifications,
            ),
          ),
          if (_doesDafYomi && _shouldShowNotifications)
            ListTile(
              title: Text(
                localizationUtil.translate("settings", "notifications_time"),
                style: Theme.of(context).textTheme.bodyText2,
              ),
              trailing: ButtonWidget(
                onPressed: _changeNotificationsTime,
                text: dateConverterUtil.timeToString(_notificationsTime),
                buttonType: ButtonType.Outline,
                color: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
