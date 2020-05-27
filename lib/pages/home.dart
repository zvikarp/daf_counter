import 'package:daf_plus_plus/utils/backwardCompatibility.dart';
import 'package:flutter/material.dart';

import 'package:daf_plus_plus/pages/settings.dart';
import 'package:daf_plus_plus/widgets/home/appBar.dart';
import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/pages/onboarding/welcome.dart';
import 'package:daf_plus_plus/pages/allShas.dart';
import 'package:daf_plus_plus/pages/dafYomi.dart';
import 'package:daf_plus_plus/pages/todaysDaf.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:flutter/scheduler.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, Widget> _tabs = {};

  Future<void> _loadProgress() async {
    progressAction.backup();
  }

  Future<bool> _exitApp() async {
    return Future.value(true);
  }

  bool _isFirstRun() {
    return !hiveService.settings.getHasOpened();
  }

  void _loadFirstRun() {
    localizationUtil
        .setPreferredLanguage(Localizations.localeOf(context).languageCode);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => WelcomeOnboardingPage(),
      ),
    );
  }

  void _loadApp() async {
    await _loadProgress();
    if (_isFirstRun()) {
      _loadFirstRun();
    }
    _listenToIsDafYomiUpdate();
    progressAction.localToStore();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      backwardCompatibilityUtil.actUponBuildNumber(context);
    });
  }

  void _listenToIsDafYomiUpdate() {
    bool isDafYomi = hiveService.settings.getIsDafYomi();
    _updateIsDafYomi(isDafYomi);
    hiveService.settings.listenToIsDafYomi().listen((bool isDafYomi) {
      _updateIsDafYomi(isDafYomi);
    });
  }

  void _updateIsDafYomi(isDafYomi) {
    Map<String, Widget> tabs = {};
    if (isDafYomi)
      tabs['daf_yomi'] = DafYomiPage();
    else
      tabs['todays_daf'] = TodaysDafPage();
    tabs['all_shas'] = AllShasPage();
    tabs['settings'] = SettingsPage();
    setState(() {
      _tabs = tabs;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadApp();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: WillPopScope(
          onWillPop: _exitApp,
          child: Scaffold(
            appBar: AppBarWidget(
              tabs: _tabs.keys.toList(),
            ),
            body: TabBarView(children: _tabs.values.toList()),
          )),
    );
  }
}
