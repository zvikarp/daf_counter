import 'package:flutter/material.dart';

import 'package:daf_plus_plus/enums/progressType.dart';
import 'package:daf_plus_plus/widgets/home/dafYomiFab.dart';
import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/widgets/shared/masechet/masechet.dart';
import 'package:daf_plus_plus/models/daf.dart';

class DafYomiPage extends StatelessWidget {
  DafYomiPage({@required this.preferredCalendar});
  final String preferredCalendar;

  @override
  Widget build(BuildContext context) {
    DateTime today = dateConverterUtil.getToday();
    DafModel daf = dafsDatesStore.getDafByDate(today);

    return Scaffold(
      body: MasechetWidget(
        position: daf,
        inList: false,
        preferredCalendar: preferredCalendar,
        dafYomi: daf.number,
        progressType: ProgressType.PROGRESS_TB,
      ),
      floatingActionButton: DafYomiFabWidget(dafYomi: daf),
    );
  }
}
