import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/dafLocation.dart';
import 'package:daf_plus_plus/models/masechet.dart';

class DafsDatesStore {
  // the _masechetsDates is a map of masechets ids
  // and a list of datetimes of the dafs in the masechet
  Map<String, List<DateTime>> _masechetsDates = {};

  void _getMasechetDates() {
    Map<String, List<DateTime>> masechetsDates = {};
    DateTime nextDate = DateTime.parse(Consts.DAF_YOMI_START_DATE);
    MasechetsData.THE_MASECHETS.forEach((MasechetModel masechet) {
      masechetsDates[masechet.id] = List.generate(
        masechet.numOfDafs,
        ((int dafIndex) => nextDate.add(Duration(days: dafIndex))),
      );
      nextDate = nextDate.add(Duration(days: masechet.numOfDafs));
    });
    _masechetsDates = masechetsDates;
  }

  DateTime getDateByDaf(DafLocationModel daf) {
    if (_masechetsDates.length < 1) _getMasechetDates();
    return _masechetsDates[daf.masechetId][daf.dafIndex];
  }

  DafLocationModel getDafByDate(DateTime date) {
    // TODO: return error if no matching date
    DafLocationModel dafLocation = DafLocationModel();
    _masechetsDates.forEach((String masechetId, List<DateTime> dates) {
      if (dates.contains(date)) {
        dafLocation = DafLocationModel(
            masechetId: masechetId, dafIndex: dates.indexOf(date));
      }
    });
    return dafLocation;
  }

  List<DateTime> getAllMasechetDates(String masechetId) {
    if (_masechetsDates.length < 1) _getMasechetDates();
    return _masechetsDates[masechetId];
  }
}

final DafsDatesStore dafsDatesStore = DafsDatesStore();