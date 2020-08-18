import 'package:flutter/material.dart';

import 'package:daf_plus_plus/widgets/home/appBar.dart';
import 'package:daf_plus_plus/pages/settings.dart';
import 'package:daf_plus_plus/pages/allShas.dart';
import 'package:daf_plus_plus/pages/dafYomi.dart';
import 'package:daf_plus_plus/pages/todaysDaf.dart';

class HomeMobile extends StatelessWidget {
  HomeMobile({
    @required this.isDafYomi,
  });

  final bool isDafYomi;

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> _tabs = {
      if (isDafYomi) 'daf_yomi': DafYomiPage(),
      if (!isDafYomi) 'todays_daf': TodaysDafPage(),
      'all_shas': AllShasPage(),
      'settings': SettingsPage()
    };
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBarWidget(
          displaySettings: false,
          tabs: _tabs.keys.toList(),
        ),
        body: TabBarView(children: _tabs.values.toList()),
      ),
    );
  }
}
