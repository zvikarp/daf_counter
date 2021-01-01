import 'package:mobx/mobx.dart';

import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/enums/progressType.dart';
import 'package:daf_plus_plus/models/progress.dart';

// flutter packages pub run build_runner build

// Include generated file
part 'progress.g.dart';

// This is the class used by rest of your codebase
class ProgressStore = _ProgressStore with _$ProgressStore;

// The store-class
abstract class _ProgressStore with Store {
  @observable
  ObservableMap<String, ProgressModel> progressMap =
      ObservableMap<String, ProgressModel>.of({});

  @action
  void setProgress(String masechetId, ProgressModel progress) {
    String progressKey = progress.getEncodedKey(masechetId);
    progressMap.remove(progressKey);
    progressMap.putIfAbsent(progressKey, () => progress);
  }

  @action
  void setProgressMap(Map<String, ProgressModel> updatedProgressMap) {
    progressMap = ObservableMap<String, ProgressModel>.linkedHashMapFrom(
        updatedProgressMap);
  }

  @computed
  ObservableMap<String, ProgressModel> get getProgressMap => progressMap;

  ProgressModel getProgress(String masechetId, ProgressType progressType) =>
      getProgressMap[Consts.PROGRESS_PREFIXES[progressType] + masechetId];
}
