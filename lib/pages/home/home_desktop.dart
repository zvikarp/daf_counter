import 'package:flutter/material.dart';

import 'package:daf_plus_plus/widgets/home/appBar.dart';
import 'package:daf_plus_plus/pages/settings.dart';
import 'package:daf_plus_plus/pages/allShas.dart';
import 'package:daf_plus_plus/pages/dafYomi.dart';
import 'package:daf_plus_plus/pages/todaysDaf.dart';

class HomeDesktop extends StatelessWidget {
  HomeDesktop({
    @required this.isDafYomi,
  });

  final bool isDafYomi;

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> _widgets = {
      if (isDafYomi) 'daf_yomi': DafYomiPage(),
      if (!isDafYomi) 'todays_daf': TodaysDafPage(),
      'all_shas': AllShasPage(),
      // 'settings': SettingsPage()
    };
    return DefaultTabController(
      length: _widgets.length,
      child: Scaffold(
        appBar: AppBarWidget(),
        body: Row(
          children: _widgets.values.toList(),
        ),
      ),
    );
  }
}
