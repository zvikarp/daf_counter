import 'package:hive/hive.dart';

import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/enums/progressType.dart';
import 'package:daf_plus_plus/consts/hive.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/services/hive/index.dart';

class ProgressBox {
  Future<void> open() async {
    await Hive.openBox(HiveConsts.PROGRESS_BOX);
  }

  void close() {
    Hive.box(HiveConsts.PROGRESS_BOX).close();
  }

  Stream<ProgressModel> listenToProgress(String masechetId, ProgressType type) {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_BOX);
    // TODO: who said we didn't delete it and not update?
    String progressKey = Consts.PROGRESS_PREFIXES[type] + masechetId;
    return progressBox.watch(key: progressKey).map((BoxEvent progress) =>
        (ProgressModel.fromString(progress.value, type)));
  }

  ProgressModel getProgress(String masechetId, ProgressType type) {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_BOX);
    String progressKey = Consts.PROGRESS_PREFIXES[type] + masechetId;
    String encodedProgress = progressBox.get(progressKey);
    return ProgressModel.fromString(encodedProgress, type, masechetId);
  }

  void setProgress(String masechetId, ProgressModel progress) {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_BOX);
    String progressKey = progress.getEncodedKey(masechetId);
    progressBox.put(progressKey, progress.toString());
    hiveService.settings.setLastUpdatedNow();
  }

  void setProgressMap(Map<String, ProgressModel> progressMap) {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_BOX);
    progressMap.forEach((String progressKey, ProgressModel progress) {
      progressBox.put(progressKey, progress.toString());
    });
    hiveService.settings.setLastUpdatedNow();
  }

  Map<String, ProgressModel> getProgressMap() {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_BOX);
    Map<String, ProgressModel> progressMap = {};
    Map<dynamic, dynamic> progressKeysMap = progressBox.toMap();
    progressKeysMap.keys.forEach((dynamic key) {
      progressMap[key] =
          ProgressModel.fromEncodedString(progressKeysMap[key], key);
    });
    return progressMap;
  }
}

final ProgressBox progressBox = ProgressBox();
