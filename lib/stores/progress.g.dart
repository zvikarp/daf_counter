// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProgressStore on _ProgressStore, Store {
  Computed<ObservableMap<String, ProgressModel>> _$getProgressTBMapComputed;

  @override
  ObservableMap<String, ProgressModel> get getProgressTBMap =>
      (_$getProgressTBMapComputed ??=
              Computed<ObservableMap<String, ProgressModel>>(
                  () => super.getProgressTBMap,
                  name: '_ProgressStore.getProgressTBMap'))
          .value;
  Computed<ObservableMap<String, ProgressModel>> _$getProgressMishnaMapComputed;

  @override
  ObservableMap<String, ProgressModel> get getProgressMishnaMap =>
      (_$getProgressMishnaMapComputed ??=
              Computed<ObservableMap<String, ProgressModel>>(
                  () => super.getProgressMishnaMap,
                  name: '_ProgressStore.getProgressMishnaMap'))
          .value;

  final _$progressTBMapAtom = Atom(name: '_ProgressStore.progressTBMap');

  @override
  ObservableMap<String, ProgressModel> get progressTBMap {
    _$progressTBMapAtom.reportRead();
    return super.progressTBMap;
  }

  @override
  set progressTBMap(ObservableMap<String, ProgressModel> value) {
    _$progressTBMapAtom.reportWrite(value, super.progressTBMap, () {
      super.progressTBMap = value;
    });
  }

  final _$progressMishnaMapAtom =
      Atom(name: '_ProgressStore.progressMishnaMap');

  @override
  ObservableMap<String, ProgressModel> get progressMishnaMap {
    _$progressMishnaMapAtom.reportRead();
    return super.progressMishnaMap;
  }

  @override
  set progressMishnaMap(ObservableMap<String, ProgressModel> value) {
    _$progressMishnaMapAtom.reportWrite(value, super.progressMishnaMap, () {
      super.progressMishnaMap = value;
    });
  }

  final _$_ProgressStoreActionController =
      ActionController(name: '_ProgressStore');

  @override
  void setProgressTB(String masechetId, ProgressModel progressTB) {
    final _$actionInfo = _$_ProgressStoreActionController.startAction(
        name: '_ProgressStore.setProgressTB');
    try {
      return super.setProgressTB(masechetId, progressTB);
    } finally {
      _$_ProgressStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProgressMishna(String masechetId, ProgressModel progressMishna) {
    final _$actionInfo = _$_ProgressStoreActionController.startAction(
        name: '_ProgressStore.setProgressMishna');
    try {
      return super.setProgressMishna(masechetId, progressMishna);
    } finally {
      _$_ProgressStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProgressTBMap(Map<String, ProgressModel> updatedProgressTBMap) {
    final _$actionInfo = _$_ProgressStoreActionController.startAction(
        name: '_ProgressStore.setProgressTBMap');
    try {
      return super.setProgressTBMap(updatedProgressTBMap);
    } finally {
      _$_ProgressStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProgressMishnaMap(
      Map<String, ProgressModel> updatedProgressMishnaMap) {
    final _$actionInfo = _$_ProgressStoreActionController.startAction(
        name: '_ProgressStore.setProgressMishnaMap');
    try {
      return super.setProgressMishnaMap(updatedProgressMishnaMap);
    } finally {
      _$_ProgressStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
progressTBMap: ${progressTBMap},
progressMishnaMap: ${progressMishnaMap},
getProgressTBMap: ${getProgressTBMap},
getProgressMishnaMap: ${getProgressMishnaMap}
    ''';
  }
}
