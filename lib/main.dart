import 'dart:async';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/stores/progress.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/utils/theme.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/pages/splash.dart';

void main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  Crashlytics.instance.enableInDevMode = false;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  await hiveService.initHive();
  await hiveService.settings.open();
  await hiveService.progress.open();
  await localizationUtil.init();
  runZoned(() {
    runApp(Provider<ProgressStore>(
        create: (_) => ProgressStore(), child: MyApp()));
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = localizationUtil.locale;

  _onLocaleChanged() {
    setState(() => _locale = localizationUtil.locale);
  }

  @override
  void initState() {
    super.initState();
    progressAction.setProgressContext(context);
    localizationUtil.onLocaleChangedCallback = _onLocaleChanged;
  }

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (Brightness brightness) {
          String currentTheme = hiveService.settings.getPreferredTheme() ??
              Consts.DEFAULT_THEME_TYPE;
          print(currentTheme);
          return themeUtil.getTheme(context, currentTheme);
        },
        themedWidgetBuilder: (context, theme) {
          print(theme);
          return MaterialApp(
            title: 'Daf++',
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: Consts.LOCALES,
            locale: _locale,
            builder: (context, widget) => ResponsiveWrapper.builder(
                BouncingScrollWrapper.builder(context, widget),
                maxWidth: 750,
                minWidth: 450,
                defaultScale: true,
                breakpoints: [
                  ResponsiveBreakpoint.resize(450, name: MOBILE),
                  ResponsiveBreakpoint.autoScale(800, name: TABLET),
                  ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                  ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                  ResponsiveBreakpoint.autoScale(2460, name: "4K"),
                ],
                background: Container(color: Color(0xFFF5F5F5))),
            home: SplashPage(),
            theme: theme,
          );
        });
  }
}
