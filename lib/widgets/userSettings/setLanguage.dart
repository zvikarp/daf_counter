import 'package:flutter/material.dart';

import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/notifications.dart';

class SetLanguageWidget extends StatefulWidget {
  @override
  _SetLanguageWidgetState createState() => _SetLanguageWidgetState();
}

class _SetLanguageWidgetState extends State<SetLanguageWidget> {
  String _currentLanguage = "";
  List<String> _listOfLanguages = [""];

  void _changeLanguage(String language) async {
    await localizationUtil.setPreferredLanguage(language);
    setState(() {
      _currentLanguage = localizationUtil.locale.languageCode;
    });
    if (hiveService.settings.getShowNotifications()) {
      await _updateNotificationLanguage();
    }
  }

  Future<void> _updateNotificationLanguage() async {
    TimeOfDay notificationsTime = hiveService.settings.getNotificationsTime();
    await notificationsUtil.cancelDailyNotification();
    await notificationsUtil.setDailyNotification(notificationsTime);
  }

  void _getLanguages() {
    List<String> listOfLanguages =
        Consts.LOCALES.map((Locale language) => language.languageCode).toList();
    setState(() {
      _currentLanguage = localizationUtil.locale.languageCode;
      _listOfLanguages = listOfLanguages;
    });
  }

  @override
  void initState() {
    super.initState();
    _getLanguages();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListTile(
        title: Text(
          localizationUtil.translate("settings", "settings_lang_text"),
          style: Theme.of(context).textTheme.bodyText2,
        ),
        trailing: DropdownButton<String>(
          value: _currentLanguage,
          underline: Container(
            height: 2,
            color: Theme.of(context).primaryColor,
          ),
          onChanged: _changeLanguage,
          items:
              _listOfLanguages.map<DropdownMenuItem<String>>((String language) {
            return DropdownMenuItem<String>(
              value: language,
              child: Text(
                localizationUtil.translate("settings", language),
                style: Theme.of(context).textTheme.bodyText2,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
