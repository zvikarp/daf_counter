// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProgressStore on _ProgressStore, Store {
  Computed<ObservableMap<String, ProgressModel>> _$getProgressMapComputed;

  @override
  ObservableMap<String, ProgressModel> get getProgressMap =>
      (_$getProgressMapComputed ??=
              Computed<ObservableMap<String, ProgressModel>>(
                  () => super.getProgressMap,
                  name: '_ProgressStore.getProgressMap'))
          .value;

  final _$progressMapAtom = Atom(name: '_ProgressStore.progressMap');

  @override
  ObservableMap<String, ProgressModel> get progressMap {
    _$progressMapAtom.reportRead();
    return super.progressMap;
  }

  @override
  set progressMap(ObservableMap<String, ProgressModel> value) {
    _$progressMapAtom.reportWrite(value, super.progressMap, () {
      super.progressMap = value;
    });
  }

  final _$_ProgressStoreActionController =
      ActionController(name: '_ProgressStore');

  @override
  void setProgress(String masechetId, ProgressModel progress) {
    final _$actionInfo = _$_ProgressStoreActionController.startAction(
        name: '_ProgressStore.setProgress');
    try {
      return super.setProgress(masechetId, progress);
    } finally {
      _$_ProgressStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProgressMap(Map<String, ProgressModel> updatedProgressMap) {
    final _$actionInfo = _$_ProgressStoreActionController.startAction(
        name: '_ProgressStore.setProgressMap');
    try {
      return super.setProgressMap(updatedProgressMap);
    } finally {
      _$_ProgressStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
progressMap: ${progressMap},
getProgressMap: ${getProgressMap}
    ''';
  }
}
