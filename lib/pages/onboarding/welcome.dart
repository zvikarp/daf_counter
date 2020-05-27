import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/widgets/core/spacer.dart';
import 'package:flutter/material.dart';

import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/pages/onboarding/onboarding1.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class WelcomeOnboardingPage extends StatefulWidget {
  @override
  _WelcomeOnboardingPageState createState() => _WelcomeOnboardingPageState();
}

class _WelcomeOnboardingPageState extends State<WelcomeOnboardingPage> {
  List<String> _listOfLanguages = [""];
  int count = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void _changeLanguage(BuildContext context, String language) async {
    await localizationUtil.setPreferredLanguage(language);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => Onboarding1Page(),
      ),
    );
  }

  void _getLanguages() {
    List<String> listOfLanguages =
    Consts.LOCALES.map((Locale language) => language.languageCode).toList();
    setState(() {
      _listOfLanguages = listOfLanguages;
    });
  }

  @override
  void initState() {
    super.initState();
    _getLanguages();
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

  Future<void> _showNotificationWithActions() async {
    var androidDetails = AndroidNotificationDetails(
      'notification with actions channel id',
      'notification with actions channel name',
      'notification with actions channel description',
    );
    var iosDetails = IOSNotificationDetails();
    var details = NotificationDetails(androidDetails, iosDetails);
    var scheduledNotificationDateTime =  DateTime.now().add(Duration(minutes: 1, seconds: 05));
    var time = Time(scheduledNotificationDateTime.hour, scheduledNotificationDateTime.minute + 1, 0);
    count = count + 1;
    await flutterLocalNotificationsPlugin.schedule(
        count,
        'Did the Daf?',
        'Did you learn today\'s daf?',
        scheduledNotificationDateTime,
        details,
        categoryIdentifier: "MY_NOTIFICATION_CATEGORY",
        payload: '');
  }


  Future<void> onSelectNotificationAction(NotificationActionData data) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    if (data.actionIdentifier == "ACTION_YAY") {
      DateTime dateTime = dateFormat.parse(data.payload);
      DafModel todaysDaf = dafsDatesStore.getDafByDate(DateTime(dateTime.year, dateTime.month, dateTime.day));
      ProgressModel progress = progressAction.get(todaysDaf.masechetId);
      progress.data[todaysDaf.number] = 1; // TODO: really not ideal.
      progressAction.update(todaysDaf.masechetId, progress, 5);
      hiveService.settings.setLastDaf(todaysDaf);
    }
  }

  Future onSelectNotification(String payload) async {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          localizationUtil.translate("onboarding", "welcome"),
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        SpacerWidget(height: 24),
                        Text(
                          localizationUtil.translate(
                              "onboarding", "welcome_subtitle"),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 48, horizontal: 32),
            children: _listOfLanguages
                .map((language) => ListTile(
              title: ButtonWidget(
                text: localizationUtil.translate(
                    "onboarding", "choose_" + language),
                buttonType: ButtonType.Outline,
                color: Theme.of(context).primaryColor,
                onPressed: () =>  _showNotificationWithActions(),
              ),
            ))
                .toList(),
          )
        ],
      ),
    );
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) {
  }
}
