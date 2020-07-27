import 'package:daf_plus_plus/pages/home/home_mobile.dart';
import 'package:flutter/material.dart';

import 'package:daf_plus_plus/consts/routes.dart';
import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDafYomi = true;

  Future<void> _loadProgress() async {
    progressAction.backup();
  }

  Future<bool> _exitApp() async {
    return Future.value(true);
  }

  bool _isFirstRun() {
    return !hiveService.settings.getHasOpened();
  }

  _loadFirstRun() {
    localizationUtil
        .setPreferredLanguage(Localizations.localeOf(context).languageCode);
    Navigator.of(context).pushReplacementNamed(RoutesConsts.WELCOME_PAGE);
  }

  void _loadApp() async {
    await _loadProgress();
    if (_isFirstRun()) {
      _loadFirstRun();
    }
    _listenToIsDafYomiUpdate();
    progressAction.localToStore();
  }

  void _listenToIsDafYomiUpdate() {
    bool isDafYomi = hiveService.settings.getIsDafYomi();
    setState(() => _isDafYomi = isDafYomi);
    hiveService.settings.listenToIsDafYomi().listen((bool isDafYomi) {
      setState(() => _isDafYomi = isDafYomi);
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
    return WillPopScope(
      onWillPop: _exitApp,
      child: HomeMobile(
        isDafYomi: _isDafYomi,
      ),
    );
  }
}
