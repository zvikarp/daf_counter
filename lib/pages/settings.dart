import 'package:daf_plus_plus/enums/deviceScreenType.dart';
import 'package:daf_plus_plus/widgets/shared/responsive/responsive.dart';
import 'package:daf_plus_plus/widgets/userSettings/setMishnas.dart';
import 'package:flutter/material.dart';

import 'package:daf_plus_plus/widgets/userSettings/setDafYomiWidget.dart';
import 'package:daf_plus_plus/widgets/userSettings/about.dart';
import 'package:daf_plus_plus/widgets/userSettings/deleteAll.dart';
import 'package:daf_plus_plus/widgets/userSettings/account.dart';
import 'package:daf_plus_plus/widgets/userSettings/setCalendar.dart';
import 'package:daf_plus_plus/widgets/userSettings/setTheme.dart';
import 'package:daf_plus_plus/widgets/userSettings/setLanguage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(builder: (context, sizingInformation) {
      return ListView(
        children: <Widget>[
          AccountWidget(),
          Divider(),
          SetLanguageWidget(),
          SetCalendarWidget(),
          SetThemeWidget(),
          Divider(),
          SetDafYomiWidget(),
          if (sizingInformation.deviceType == DeviceScreenType.Mobile)
            SetMishnasWidget(),
          Divider(),
          DeleteAllWidget(),
          Divider(),
          AboutWidget(),
        ],
      );
    });
  }
}
