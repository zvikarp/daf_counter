// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProgressStore on _ProgressStore, Store {
  Computed<ObservableMap<String, ProgressModel>> _$getProgressMapComputed;

  @override
  ObservableMap<String, ProgressModel> get getProgressMap =>
      (_$getProgressMapComputed ??=
              Computed<ObservableMap<String, ProgressModel>>(
                  () => super.getProgressMap))
          .value;

  final _$progressMapAtom = Atom(name: '_ProgressStore.progressMap');

  @override
  ObservableMap<String, ProgressModel> get progressMap {
    _$progressMapAtom.context.enforceReadPolicy(_$progressMapAtom);
    _$progressMapAtom.reportObserved();
    return super.progressMap;
  }

  @override
  set progressMap(ObservableMap<String, ProgressModel> value) {
    _$progressMapAtom.context.conditionallyRunInAction(() {
      super.progressMap = value;
      _$progressMapAtom.reportChanged();
    }, _$progressMapAtom, name: '${_$progressMapAtom.name}_set');
  }

  final _$_ProgressStoreActionController =
      ActionController(name: '_ProgressStore');

  @override
  void setProgress(String masechetId, ProgressModel progress) {
    final _$actionInfo = _$_ProgressStoreActionController.startAction();
    try {
      return super.setProgress(masechetId, progress);
    } finally {
      _$_ProgressStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProgressMap(Map<String, ProgressModel> progressMap) {
    final _$actionInfo = _$_ProgressStoreActionController.startAction();
    try {
      return super.setProgressMap(progressMap);
    } finally {
      _$_ProgressStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string = 'getProgressMap: ${getProgressMap.toString()}';
    return '{$string}';
  }
}
