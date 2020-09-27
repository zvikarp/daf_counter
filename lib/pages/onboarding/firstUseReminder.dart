import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
  TimeOfDay _timeOfDay;
  String _formattedTime;

  @override
  void initState() {
    super.initState();
    setState(() {
      _formattedTime =
          localizationUtil.translate("onboarding", "select_time") + ":";
    });
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
    await notificationsUtil.setDailyNotification(_timeOfDay);
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
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );
    if (pickedTime != null) {
      setState(() {
        _timeOfDay = pickedTime;
        _formattedTime = dateConverterUtil.timeOfDayToString(pickedTime);
      });
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
                  padding: EdgeInsets.only(top: 16),
                  child: Text(localizationUtil.translate(
                      "onboarding", "set_reminder"))),
              ListTile(
                title: Text(_formattedTime),
                leading: Icon(Icons.access_time),
                onTap: _selectTime,
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
