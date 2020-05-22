import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/models/masechet.dart';

class ProgressModel {
  const ProgressModel({
    this.data = const <int>[],
  });

  final List<int> data;

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
}
