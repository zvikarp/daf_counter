import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import 'package:daf_plus_plus/utils/platform.dart';
import 'package:daf_plus_plus/stores/navigatorKey.dart';
import 'package:daf_plus_plus/utils/notifications.dart';
import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/consts/routes.dart';
import 'package:daf_plus_plus/utils/routes.dart';
import 'package:daf_plus_plus/stores/progress.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/utils/theme.dart';
import 'package:daf_plus_plus/utils/localization.dart';

void main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await hiveService.initHive();
  await hiveService.settings.open();
  await hiveService.progress.open();
  await localizationUtil.init();
  await notificationsUtil.init();
  if (platformUtil.isMobile()) {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runZonedGuarded(() {
      runApp(Provider<ProgressStore>(
          create: (_) => ProgressStore(), child: MyApp()));
    }, FirebaseCrashlytics.instance.recordError);
  } else {
    runApp(Provider<ProgressStore>(
        create: (_) => ProgressStore(), child: MyApp()));
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Locale _locale = localizationUtil.locale;

  _onLocaleChanged() {
    setState(() => _locale = localizationUtil.locale);
  }

  @override
  void initState() {
    super.initState();
    progressAction.setProgressContext(context);
    localizationUtil.onLocaleChangedCallback = _onLocaleChanged;
    navigatorKeyStore.setNavigatorKey(navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (Brightness brightness) {
          String currentTheme = hiveService.settings.getPreferredTheme() ??
              Consts.DEFAULT_THEME_TYPE;
          return themeUtil.getTheme(context, currentTheme);
        },
        themedWidgetBuilder: (context, theme) {
          return PlatformProvider(
            builder: (BuildContext context) => MaterialApp(
              title: 'Daf++',
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: Consts.LOCALES,
              locale: _locale,
              initialRoute: RoutesConsts.INITIAL_PAGE,
              routes: routesUtil.routes,
              navigatorKey: navigatorKey,
              theme: theme,
            ),
          );
        });
  }
}
