import 'package:flutter/material.dart';

import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/widgets/shared/masechet/masechet.dart';

class TodaysDafPage extends StatelessWidget {
  TodaysDafPage({@required this.preferredCalendar});
  final String preferredCalendar;

  @override
  Widget build(BuildContext context) {
    DafModel daf = hiveService.settings.getLastDaf();

    return MasechetWidget(
      daf: daf,
      inList: false,
      preferredCalendar: preferredCalendar,
    );
  }
}
