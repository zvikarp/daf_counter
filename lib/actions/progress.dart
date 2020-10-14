import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/utils/gematriaConverter.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/toast.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/models/Response.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/services/firestore/index.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/stores/actionCounter.dart';
import 'package:daf_plus_plus/stores/progress.dart';
import 'package:daf_plus_plus/enums/learnType.dart';

class ProgressAction {
  BuildContext _progressContext;

  DafModel _getTodaysDaf() {
    return dafsDatesStore.getDafByDate(dateConverterUtil.getToday());
  }

  String _getDafNumber(dafNumber) {
    if (localizationUtil.translate("calendar", "display_dapim_as_gematria"))
      return gematriaConverterUtil
          .toGematria((dafNumber + Consts.FIST_DAF))
          .toString();
    return (dafNumber + Consts.FIST_DAF).toString();
  }

  void learnedTodaysDaf() {
    DafModel todaysDaf = _getTodaysDaf();
    update(todaysDaf.masechetId, LearnType.LearnedDafOnce, todaysDaf.number, 5);
    hiveService.settings.setLastDaf(todaysDaf);
    String masechet =
        '${localizationUtil.translate("general", "masechet")} ${localizationUtil.translate("shas", todaysDaf.masechetId)}';
    String daf =
        '${localizationUtil.translate("general", "daf")} ${_getDafNumber(todaysDaf.number)}';
    toastUtil.showInformation(
        '$masechet $daf ${localizationUtil.translate("home", "daf_yomi_toast")}');
  }

  void setProgressContext(BuildContext progressContext) =>
      _progressContext = progressContext;
  BuildContext getProgressContext() => _progressContext;

  /// return the progress store object
  ProgressStore _getProgressStore([bool listen = false]) =>
      Provider.of<ProgressStore>(_progressContext, listen: listen);

  void update(String masechetId, LearnType learnType,
      [int daf = 0, int incrementCounterBy = 5]) {
    ProgressStore progressStore = _getProgressStore();
    actionCounterStore.increment(incrementCounterBy);
    ProgressModel progress = hiveService.progress.getProgress(masechetId);
    progress.updateByLearnType(learnType, daf);
    hiveService.progress.setProgress(masechetId, progress);
    progressStore.setProgress(masechetId, progress);
    _checkIfShouldBackup();
  }

  void updateAll(Map<String, LearnType> learnMap,
      [int incrementCounterBy = 5]) {
    ProgressStore progressStore = _getProgressStore();
    actionCounterStore.increment(incrementCounterBy);
    Map<String, ProgressModel> progressMap = {};
    learnMap.forEach((String masechetId, LearnType learnType) {
      ProgressModel progress = hiveService.progress.getProgress(masechetId);
      progress.updateByLearnType(learnType);
      progressMap[masechetId] = progress;
    });
    hiveService.progress.setProgressMap(progressMap);
    progressStore.setProgressMap(progressMap);
    _checkIfShouldBackup();
  }

  ProgressModel get(String masechetId) {
    ProgressStore progressStore = _getProgressStore();
    return progressStore.getProgressMap[masechetId];
  }

  void localToStore() {
    ProgressStore progressStore = _getProgressStore();
    Map<String, ProgressModel> progressMap =
        hiveService.progress.getProgressMap();
    progressStore.setProgressMap(progressMap);
  }

  Future<void> backup() async {
    Map<String, ProgressModel> progressMap =
        hiveService.progress.getProgressMap();
    ResponseModel backupResponse =
        await firestoreService.progress.setProgressMap(progressMap);
    if (backupResponse.isSuccessful()) {
      hiveService.settings.setLastBackupNow();
    }
  }

  Future<void> restore() async {
    ResponseModel progressResponse =
        await firestoreService.progress.getProgressMap();
    if (progressResponse.isSuccessful()) {
      hiveService.settings.setLastBackupNow();
      Map<String, ProgressModel> progressMap = progressResponse.data.map(
          (String masechetId, dynamic progress) => MapEntry(
              masechetId, ProgressModel.fromString(progress.toString())));
      hiveService.progress.setProgressMap(progressMap);
    }
  }

  void _checkIfShouldBackup() {
    if (actionCounterStore.numberOfActions >=
        Consts.PROGRESS_BACKUP_THRESHOLD) {
      backup();
      actionCounterStore.clear();
    }
  }
}

final ProgressAction progressAction = ProgressAction();
