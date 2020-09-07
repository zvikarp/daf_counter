import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/consts/routes.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/utils/gematriaConverter.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/toast.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/spacer.dart';

class FirstUseReminder extends StatefulWidget {
  @override
  _FirstUseReminderState createState() => _FirstUseReminderState();
}

class _FirstUseReminderState extends State<FirstUseReminder> {
  TimeOfDay _timeOfDay;
  String _formattedTime;

  @override
  void initState() {
    super.initState();
    setState(() {
      _formattedTime =
          localizationUtil.translate("onboarding", "select_time") + ":";
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _set() async {
    await setNotification();
    _done();
  }

  _done() {
    hiveService.settings.setHasOpened(true);
    Navigator.of(context).pushNamedAndRemoveUntil(
        RoutesConsts.HOME_PAGE, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: "onboardingHero",
              child: Container(
                color: Theme.of(context).primaryColor,
                child: SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 48, horizontal: 32),
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          localizationUtil.translate(
                              "onboarding", "set_reminder_title"),
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        SpacerWidget(height: 24),
                        Text(
                          localizationUtil.translate(
                              "onboarding", "set_reminder_description"),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SpacerWidget(height: 42),
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(16),
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(localizationUtil.translate(
                      "onboarding", "set_reminder"))),
              ListTile(
                title: Text(_formattedTime),
                leading: Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay pickedTime = await selectTime();
                  if (pickedTime != null) {
                    setState(() {
                      _timeOfDay = pickedTime;
                      _formattedTime =
                          dateConverterUtil.timeOfDayToString(pickedTime);
                    });
                  }
                },
              ),
              ListTile(
                title: ButtonWidget(
                  text: localizationUtil.translate("onboarding", "set"),
                  buttonType: ButtonType.Outline,
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _set(),
                ),
              ),
              ListTile(
                title: ButtonWidget(
                  text: localizationUtil.translate("onboarding", "dont_set"),
                  buttonType: ButtonType.Outline,
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _done(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future setNotification() async {
    if (_timeOfDay != null) {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('ic_launcher');
      IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings(
              onDidReceiveLocalNotification: onDidReceiveLocalNotification);
      InitializationSettings initializationSettings = InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);

      Time time = Time(_timeOfDay.hour, _timeOfDay.minute, 0);
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
              'repeatDailyAtTime channel id',
              'repeatDailyAtTime channel name',
              'repeatDailyAtTime description');
      IOSNotificationDetails iOSPlatformChannelSpecifics =
          IOSNotificationDetails();
      NotificationDetails platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          0,
          localizationUtil.translate("onboarding", "did_you_daf"),
          localizationUtil.translate("onboarding", "mark_daf"),
          time,
          platformChannelSpecifics);
    } else {
      toastUtil.showInformation(
          localizationUtil.translate("onboarding", "select_time"));
    }
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  String _getDafNumber(int daf) {
    if (localizationUtil.translate("calendar", "display_dapim_as_gematria"))
      return gematriaConverterUtil
          .toGematria((daf + Consts.FIST_DAF))
          .toString();
    return (daf + Consts.FIST_DAF).toString();
  }

  String _getTodaysDaf() {
    DateTime today = dateConverterUtil.getToday();
    DafModel todaysDaf = dafsDatesStore.getDafByDate(today);

    String masechet = localizationUtil.translate("shas", todaysDaf.masechetId);
    String daf = _getDafNumber(todaysDaf.number);
    return masechet + " " + daf;
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(_getTodaysDaf()),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child:
                Text(localizationUtil.translate("general", "confirm_button")),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }

  Future<TimeOfDay> selectTime() async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );
    if (picked != null) {
      return picked;
    }

    return null;
  }
}
