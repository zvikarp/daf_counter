import 'package:daf_plus_plus/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/consts/hive.dart';
import 'package:daf_plus_plus/models/daf.dart';

class SettingsBox {
  Future<void> open() async {
    await Hive.openBox(HiveConsts.SETTINGS_BOX);
  }

  void close() {
    Hive.box(HiveConsts.SETTINGS_BOX).close();
  }

  void _setByKey(dynamic key, dynamic value) {
    Box settingsBox = Hive.box(HiveConsts.SETTINGS_BOX);
    settingsBox.put(key, value);
  }

  dynamic _getByKey(dynamic key) {
    Box settingsBox = Hive.box(HiveConsts.SETTINGS_BOX);
    return settingsBox.get(key);
  }

  // last daf
  DafModel getLastDaf() => DafModel.fromString(_getByKey(HiveConsts.LAST_DAF));
  void setLastDaf(DafModel lastDaf) {
    _setByKey(HiveConsts.LAST_DAF, lastDaf.toString());
    setLastUpdatedNow();
  }

  // last updated
  void setLastUpdatedNow() => setLastUpdated(DateTime.now());
  void setLastUpdated(DateTime lastUpdated) =>
      _setByKey(HiveConsts.LAST_UPDATED, lastUpdated);
  DateTime getLastUpdated() => _getByKey(HiveConsts.LAST_UPDATED);

  // last backup
  void setLastBackupNow() => setLastBackup(DateTime.now());
  void setLastBackup(DateTime lastBackup) =>
      _setByKey(HiveConsts.LAST_BACKUP, lastBackup);
  DateTime getLastBackup() => _getByKey(HiveConsts.LAST_BACKUP);

  // preferred language
  void setPreferredLanguage(String preferredLanguage) =>
      _setByKey(HiveConsts.PREFERRED_LANGUAGE, preferredLanguage);
  String getPreferredLanguage() => _getByKey(HiveConsts.PREFERRED_LANGUAGE);

  // preferred calendar
  void setPreferredCalendar(String preferredCalendar) =>
      _setByKey(HiveConsts.PREFERRED_CALENDAR, preferredCalendar);
  String getPreferredCalendar() => _getByKey(HiveConsts.PREFERRED_CALENDAR);

  // preferred theme
  void setPreferredTheme(String preferredTheme) =>
      _setByKey(HiveConsts.PREFERRED_THEME, preferredTheme);
  String getPreferredTheme() => _getByKey(HiveConsts.PREFERRED_THEME);

  // show notifications
  void setShowNotifications(bool showNotifications) =>
      _setByKey(HiveConsts.SHOW_NOTIFICATIONS, showNotifications);
  bool getShowNotifications() => _getByKey(HiveConsts.SHOW_NOTIFICATIONS);

  // notifications time
  void setNotificationsTime(TimeOfDay notificationsTime) => _setByKey(
      HiveConsts.NOTIFICATIONS_TIME,
      dateConverterUtil.timeToString(notificationsTime));
  TimeOfDay getNotificationsTime() =>
      dateConverterUtil.stringToTime(_getByKey(HiveConsts.NOTIFICATIONS_TIME));

  // is daf yomi
  void setIsDafYomi(bool isDaf) => _setByKey(HiveConsts.IS_DAF_YOMI, isDaf);
  bool getIsDafYomi() => _getByKey(HiveConsts.IS_DAF_YOMI) ?? false;

  Stream<bool> listenToIsDafYomi() {
    Box settingsBox = Hive.box(HiveConsts.SETTINGS_BOX);
    return settingsBox
        .watch(key: HiveConsts.IS_DAF_YOMI)
        .map((BoxEvent setting) => setting.value);
  }

  // has opened
  void setHasOpened(bool hasOpened) =>
      _setByKey(HiveConsts.HAS_OPENED, hasOpened);
  bool getHasOpened() => _getByKey(HiveConsts.HAS_OPENED) ?? false;

  // used fab
  void setUsedFab(bool usedFab) => _setByKey(HiveConsts.USED_FAB, usedFab);
  bool getUsedFab() => _getByKey(HiveConsts.USED_FAB) ?? false;

  // used fab
  void setLastUpdatedBuildNumber(int lastUpdatedBuildNumber) =>
      _setByKey(HiveConsts.LAST_UPDATED_BUILD_NUMBER, lastUpdatedBuildNumber);
  int getLastUpdatedBuildNumber() =>
      _getByKey(HiveConsts.LAST_UPDATED_BUILD_NUMBER) ??
      Consts.DEFAULT_BUILD_NUMBER;
}

final SettingsBox settingsBox = SettingsBox();
