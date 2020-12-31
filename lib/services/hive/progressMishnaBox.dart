import 'package:hive/hive.dart';

import 'package:daf_plus_plus/enums/progressType.dart';
import 'package:daf_plus_plus/consts/hive.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/services/hive/index.dart';

class ProgressMishnaBox {
  Future<void> open() async {
    await Hive.openBox(HiveConsts.PROGRESS_MISHNA_BOX);
  }

  void close() {
    Hive.box(HiveConsts.PROGRESS_MISHNA_BOX).close();
  }

  Stream<ProgressModel> listenToProgress(String masechetId) {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_MISHNA_BOX);
    // TODO: who said we didn't delete it and not update?
    return progressBox.watch(key: masechetId).map((BoxEvent progress) =>
        (ProgressModel.fromString(
            progress.value, ProgressType.PROGRESS_MISHNA)));
  }

  ProgressModel getProgress(String masechetId) {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_MISHNA_BOX);
    String encodedProgress = progressBox.get(masechetId);
    return ProgressModel.fromString(
        encodedProgress, ProgressType.PROGRESS_MISHNA, masechetId);
  }

  void setProgress(String masechetId, ProgressModel progress) {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_MISHNA_BOX);
    progressBox.put(masechetId, progress.toString());
    hiveService.settings.setLastUpdatedNow();
  }

  void setProgressMap(Map<String, ProgressModel> progressMap) {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_MISHNA_BOX);
    progressMap.forEach((String masechetId, ProgressModel progress) {
      progressBox.put(masechetId, progress.toString());
    });
    hiveService.settings.setLastUpdatedNow();
  }

  Map<String, ProgressModel> getProgressMap() {
    Box progressBox = Hive.box(HiveConsts.PROGRESS_MISHNA_BOX);
    Map<String, ProgressModel> progressMap = {};
    MasechetsData.THE_MASECHETS.keys.forEach((String masechetId) {
      String progress = progressBox.get(masechetId);
      progressMap[masechetId] = ProgressModel.fromString(
          progress, ProgressType.PROGRESS_MISHNA, masechetId);
    });
    return progressMap;
  }
}

final ProgressMishnaBox progressMishnaBox = ProgressMishnaBox();
