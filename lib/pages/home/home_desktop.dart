import 'package:flutter/material.dart';

import 'package:daf_plus_plus/widgets/home/appBar.dart';
import 'package:daf_plus_plus/pages/allShas.dart';
import 'package:daf_plus_plus/pages/dafYomi.dart';
import 'package:daf_plus_plus/pages/todaysDaf.dart';

class HomeDesktop extends StatelessWidget {
  HomeDesktop({
    @required this.isDafYomi,
    @required this.preferredCalendar,
  });

  final bool isDafYomi;
  final String preferredCalendar;

  Widget _sideBar(BuildContext context, Widget child) {
    return Container(
        width: 300,
        color: Theme.of(context).cardColor.withOpacity(0.5),
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> _widgets = {
      'all_shas':
          _sideBar(context, AllShasPage(preferredCalendar: preferredCalendar)),
      if (isDafYomi)
        'daf_yomi':
            Flexible(child: DafYomiPage(preferredCalendar: preferredCalendar)),
      if (!isDafYomi)
        'todays_daf': Flexible(
            child: TodaysDafPage(preferredCalendar: preferredCalendar)),
    };
    return DefaultTabController(
      length: _widgets.length,
      child: Scaffold(
        appBar: AppBarWidget(displaySettings: true),
        body: Row(
          children: _widgets.values.toList(),
        ),
      ),
    );
  }
}
