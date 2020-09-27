import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/utils/platform.dart';
import 'package:daf_plus_plus/utils/notifications.dart';
import 'package:daf_plus_plus/consts/routes.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/spacer.dart';

class FirstUseReminder extends StatefulWidget {
  @override
  _FirstUseReminderState createState() => _FirstUseReminderState();
}

class _FirstUseReminderState extends State<FirstUseReminder> {
  TimeOfDay _notificationsTime = Consts.DEFAULT_NOTIFICATION_TIME;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (platformUtil.isWeb()) {
        _done();
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _set() async {
    await notificationsUtil.setDailyNotification(_notificationsTime);
    _done();
  }

  _done() {
    hiveService.settings.setHasOpened(true);
    Navigator.of(context).pushNamedAndRemoveUntil(
        RoutesConsts.HOME_PAGE, ModalRoute.withName('/'));
  }

  Future<TimeOfDay> _selectTime() async {
    TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: _notificationsTime,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );
    if (pickedTime != null) {
      setState(() => _notificationsTime = pickedTime);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (platformUtil.isWeb()) {
      return Container();
    }

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
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(localizationUtil.translate(
                      "onboarding", "set_reminder"))),
              ListTile(
                title: Text(
                  localizationUtil.translate("onboarding", "select_time") + ":",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                trailing: ButtonWidget(
                  onPressed: _selectTime,
                  text: dateConverterUtil.timeToString(_notificationsTime),
                  buttonType: ButtonType.Underline,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              ButtonWidget(
                text: localizationUtil.translate("onboarding", "set"),
                buttonType: ButtonType.Outline,
                margin: EdgeInsets.symmetric(horizontal: 16),
                color: Theme.of(context).primaryColor,
                onPressed: () => _set(),
              ),
              ButtonWidget(
                text: localizationUtil.translate("onboarding", "dont_set"),
                buttonType: ButtonType.Outline,
                margin: EdgeInsets.symmetric(horizontal: 16),
                color: Theme.of(context).primaryColor,
                onPressed: () => _done(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
