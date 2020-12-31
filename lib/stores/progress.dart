import 'package:daf_plus_plus/models/progress.dart';
import 'package:mobx/mobx.dart';

// flutter packages pub run build_runner build

// Include generated file
part 'progress.g.dart';

// This is the class used by rest of your codebase
class ProgressStore = _ProgressStore with _$ProgressStore;

// The store-class
abstract class _ProgressStore with Store {
  @observable
  ObservableMap<String, ProgressModel> progressTBMap =
      ObservableMap<String, ProgressModel>.of({});

  @observable
  ObservableMap<String, ProgressModel> progressMishnaMap =
      ObservableMap<String, ProgressModel>.of({});

  @action
  void setProgressTB(String masechetId, ProgressModel progressTB) {
    progressTBMap.remove(masechetId);
    progressTBMap.putIfAbsent(masechetId, () => progressTB);
  }

  @action
  void setProgressMishna(String masechetId, ProgressModel progressMishna) {
    progressMishnaMap.remove(masechetId);
    progressMishnaMap.putIfAbsent(masechetId, () => progressMishna);
  }

  @action
  void setProgressTBMap(Map<String, ProgressModel> updatedProgressTBMap) {
    progressTBMap = ObservableMap<String, ProgressModel>.linkedHashMapFrom(
        updatedProgressTBMap);
  }

  @action
  void setProgressMishnaMap(
      Map<String, ProgressModel> updatedProgressMishnaMap) {
    progressMishnaMap = ObservableMap<String, ProgressModel>.linkedHashMapFrom(
        updatedProgressMishnaMap);
  }

  @computed
  ObservableMap<String, ProgressModel> get getProgressTBMap => progressTBMap;

  @computed
  ObservableMap<String, ProgressModel> get getProgressMishnaMap =>
      progressMishnaMap;
}
