import 'package:daf_plus_plus/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:daf_plus_plus/enums/deviceScreenType.dart';
import 'package:daf_plus_plus/pages/home/home_desktop.dart';
import 'package:daf_plus_plus/pages/home/home_mobile.dart';
import 'package:daf_plus_plus/widgets/shared/responsive/responsive.dart';
import 'package:daf_plus_plus/consts/routes.dart';
import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/backwardCompatibility.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDafYomi = true;
  String _preferredCalendar = Consts.DEFAULT_CALENDAR_TYPE;

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
    _listenToPreferredCalendarState();
    progressAction.localToStore();
  }

  void _listenToIsDafYomiUpdate() {
    bool isDafYomi = hiveService.settings.getIsDafYomi();
    setState(() => _isDafYomi = isDafYomi);
    hiveService.settings.listenToIsDafYomi().listen((bool isDafYomi) {
      setState(() => _isDafYomi = isDafYomi);
    });
  }

  void _listenToPreferredCalendarState() {
    String preferredCalendar = hiveService.settings.getPreferredCalendar() ??
        Consts.DEFAULT_CALENDAR_TYPE;
    setState(() => _preferredCalendar = preferredCalendar);
    hiveService.settings
        .listenToPreferredCalendar()
        .listen((String preferredCalendar) {
      setState(() => _preferredCalendar = preferredCalendar);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadApp();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      backwardCompatibilityUtil.actUponBuildNumber(context);
    });
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
      child: ResponsiveWidget(builder: (context, sizingInformation) {
        if (sizingInformation.deviceType == DeviceScreenType.Mobile) {
          return HomeMobile(
            isDafYomi: _isDafYomi,
            preferredCalendar: _preferredCalendar,
          );
        }
        return HomeDesktop(
          isDafYomi: _isDafYomi,
          preferredCalendar: _preferredCalendar,
        );
      }),
    );
  }
}
