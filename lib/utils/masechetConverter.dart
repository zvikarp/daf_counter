import 'dart:math';

import 'package:daf_plus_plus/consts/consts.dart';

class MasechetConverterUtil {
  int firstCharValue = 'a'.codeUnitAt(0);

  String encode(List<int> masechetProgress) {
    List<String> encodedMasechetProgress =
        masechetProgress.map(_numberToString).toList();
    return encodedMasechetProgress.join();
  }

  List<int> decode(String masechetProgress) {
    List<String> encodedMasechetProgress = masechetProgress.split('');
    return encodedMasechetProgress.map(_stringToNumber).toList();
  }

  double toPercent(List<int> masechetProgress) {
    int masechetDone = countDone(masechetProgress);
    return masechetDone / masechetProgress.length;
  }

  int countDone(List<int> masechetProgress) => masechetProgress.where((int daf) => daf > 0).length;

  String _numberToString(int number) {
    number = numberInRange(number);
    return String.fromCharCode(firstCharValue + number);
  }

  int _stringToNumber(String string) {
    int number = string.codeUnitAt(0);
    return numberInRange(number - firstCharValue);
  }

  int numberInRange(int number) =>
      max(0, min(number, Consts.MAX_REVISIONS));
}

final MasechetConverterUtil masechetConverterUtil = MasechetConverterUtil();
