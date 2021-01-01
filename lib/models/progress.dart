import 'package:flutter/material.dart';

import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/enums/learnType.dart';
import 'package:daf_plus_plus/enums/progressType.dart';
import 'package:daf_plus_plus/models/masechet.dart';

class ProgressModel {
  ProgressModel({
    @required this.type,
    this.data = const <int>[],
  });

  ProgressType type;
  List<int> data;

  bool isTBType() => type == ProgressType.PROGRESS_TB;
  bool isMishnaType() => type == ProgressType.PROGRESS_MISHNA;

  factory ProgressModel.fromString(String data, ProgressType type,
      [String masechetId]) {
    if (data == null || data == "") {
      return ProgressModel.empty(0, type, masechetId);
    }
    List<int> dataAsList = data
        .split(Consts.DATA_DIVIDER)
        .map((String string) => int.parse(string))
        .toList();
    return ProgressModel(data: dataAsList, type: type);
  }

  factory ProgressModel.fromEncodedString(
      String data, String encodedTypeAndMasechetId) {
    List<String> encodedTypeAndMasechetIdAsList =
        encodedTypeAndMasechetId.split(Consts.PROGRESS_PREFIX_DIVIDER);
    ProgressType progressType = Consts.DEFAULT_PROGRESS_TYPE;
    String masechetId = encodedTypeAndMasechetId.toString();
    if (encodedTypeAndMasechetIdAsList.length > 1) {
      progressType = Consts.PROGRESS_PREFIXES.keys.firstWhere(
          (ProgressType progressType) =>
              Consts.PROGRESS_PREFIXES[progressType] ==
              (encodedTypeAndMasechetIdAsList[0] +
                  Consts.PROGRESS_PREFIX_DIVIDER));
      masechetId = encodedTypeAndMasechetIdAsList[1];
    }
    return ProgressModel.fromString(data, progressType, masechetId);
  }

  factory ProgressModel.empty(int length, ProgressType type,
      [String masechetId]) {
    if (length == null || length < 1) {
      if (masechetId == null) {
        length = 0;
      } else {
        MasechetModel masechet = MasechetModel.byMasechetId(masechetId);
        length = type == ProgressType.PROGRESS_TB
            ? masechet.numOfDafsTB
            : masechet.numOfPerakim;
      }
    }
    return ProgressModel(
        data: List.filled(length, Consts.DEFAUT_DAF), type: type);
  }

  String toString() => data
      .map((int number) => number.toString())
      .toList()
      .join(Consts.DATA_DIVIDER);

  String getEncodedKey(String masechetId) =>
      Consts.PROGRESS_PREFIXES[type] + masechetId;

  int countDone() => data.where((int daf) => daf > 0)?.length;

  int countGaps() {
    int gaps = 0;
    int count = 0;
    data.forEach((daf) {
      if (daf > 0) {
        gaps += count;
        count = 0;
      } else {
        count++;
      }
    });
    return gaps;
  }

  void updateByLearnType(LearnType learnType, [int daf = 0]) {
    int dafCount = data[daf];
    switch (learnType) {
      case LearnType.LearnedDafOnce:
        data[daf] = dafCount + 1;
        break;
      case LearnType.LearnedDafExactlyOnce:
        data[daf] = 1;
        break;
      case LearnType.LearnedDafAtLeastOnce:
        data[daf] = dafCount > 0 ? dafCount : 1;
        break;
      case LearnType.LearnedUntilDafExactlyOnce:
        data = data
            .asMap()
            .map((int index, int dafProgress) =>
                MapEntry(index, index <= daf ? 1 : 0))
            .values
            .toList();
        break;
      case LearnType.UnlearnedDafOnce:
        data[daf] = dafCount > 0 ? dafCount - 1 : 0;
        break;
      case LearnType.LearnedMasechetOnce:
        data = data.map((int dafProgress) => dafProgress++).toList();
        break;
      case LearnType.LearnedMasechetExactlyOnce:
        data = data.map((int dafProgress) => 1).toList();
        break;
      case LearnType.LearnedMasechetAtLeastOnce:
        data =
            data.map((int dafProgress) => dafCount > 0 ? dafCount : 1).toList();
        break;
      case LearnType.UnlearndMasechetExactlyZero:
        data = data.map((int dafProgress) => 0).toList();
        break;
      default:
        break;
    }
  }
}
