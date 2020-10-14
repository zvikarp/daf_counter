import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/enums/learnType.dart';
import 'package:daf_plus_plus/models/masechet.dart';

class ProgressModel {
  ProgressModel({
    this.data = const <int>[],
  });

  List<int> data;

  factory ProgressModel.fromString(String data, [String masechetId]) {
    if (data == null || data == "") {
      int length = masechetId == null
          ? 0
          : MasechetModel.byMasechetId(masechetId).numOfDafs;
      return ProgressModel.empty(length);
    }
    List<int> dataAsList = data
        .split(Consts.DATA_DIVIDER)
        .map((String string) => int.parse(string))
        .toList();
    return ProgressModel(data: dataAsList);
  }

  factory ProgressModel.empty(int length, [String masechetId]) {
    if (length == null || length < 1) {
      length = masechetId == null
          ? 0
          : MasechetModel.byMasechetId(masechetId).numOfDafs;
    }
    return ProgressModel(data: List.filled(length, Consts.DEFAUT_DAF));
  }

  String toString() => data
      .map((int number) => number.toString())
      .toList()
      .join(Consts.DATA_DIVIDER);

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
