import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:daf_plus_plus/utils/platform.dart';
import 'package:daf_plus_plus/utils/notifications.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';

class SetDafYomiWidget extends StatefulWidget {
  @override
  _SetDafYomiWidgetState createState() => _SetDafYomiWidgetState();
}

class _SetDafYomiWidgetState extends State<SetDafYomiWidget> {
  bool _shouldShowNotifications = false;
  TimeOfDay _notificationsTime = Consts.DEFAULT_NOTIFICATION_TIME;
  bool _doesDafYomi = false;

  void _changeDafYomi(bool doesDaf) async {
    hiveService.settings.setIsDafYomi(doesDaf);
    _getDoesDaf();
  }

  void _getDoesDaf() {
    setState(() => _doesDafYomi = hiveService.settings.getIsDafYomi());
  }

  Future<void> _changeShowNotifications(bool showNotifications) async {
    await notificationsUtil.cancelDailyNotification();
    if (showNotifications) {
      await notificationsUtil.setDailyNotification(_notificationsTime);
    }
    hiveService.settings.setShowNotifications(showNotifications);
    _getShowNotifications();
  }

  void _getShowNotifications() {
    setState(() =>
        _shouldShowNotifications = hiveService.settings.getShowNotifications());
  }

  void _changeNotificationsTime() async {
    TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: _notificationsTime,
    );
    if (time != null) {
      hiveService.settings.setNotificationsTime(time);
      await notificationsUtil.cancelDailyNotification();
      if (_shouldShowNotifications) {
        await notificationsUtil.setDailyNotification(time);
      }
      _getNotificationsTime();
    }
  }

  void _getNotificationsTime() {
    setState(() => _notificationsTime =
        hiveService.settings.getNotificationsTime() ??
            Consts.DEFAULT_NOTIFICATION_TIME);
  }

  @override
  void initState() {
    super.initState();
    _getDoesDaf();
    _getShowNotifications();
    _getNotificationsTime();
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
            trailing: PlatformSwitch(
              value: _doesDafYomi,
              activeColor: Theme.of(context).primaryColor,
              onChanged: _changeDafYomi,
            ),
          ),
          if (_doesDafYomi && platformUtil.isAndroid())
            ListTile(
              title: Text(
                localizationUtil.translate(
                    "settings", "should_show_notifications"),
                style: Theme.of(context).textTheme.bodyText2,
              ),
              trailing: PlatformSwitch(
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
                buttonType: ButtonType.Underline,
                color: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
