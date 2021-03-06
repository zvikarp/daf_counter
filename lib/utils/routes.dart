import 'package:flutter/widgets.dart';

import 'package:daf_plus_plus/pages/policy.dart';
import 'package:daf_plus_plus/consts/routes.dart';
import 'package:daf_plus_plus/pages/home/home.dart';
import 'package:daf_plus_plus/pages/onboarding/firstUseReminder.dart';
import 'package:daf_plus_plus/pages/onboarding/onboarding1.dart';
import 'package:daf_plus_plus/pages/onboarding/onboarding2.dart';
import 'package:daf_plus_plus/pages/onboarding/welcome.dart';
import 'package:daf_plus_plus/pages/splash.dart';

class RoutesUtil {
  Map<String, Widget Function(BuildContext)> _routes = {
    RoutesConsts.SPLASH_PAGE: (context) => SplashPage(),
    RoutesConsts.WELCOME_PAGE: (context) => WelcomeOnboardingPage(),
    RoutesConsts.ONBOARDING1_PAGE: (context) => Onboarding1Page(),
    RoutesConsts.ONBOARDING2_PAGE: (context) => Onboarding2Page(),
    RoutesConsts.REMINDER_PAGE: (context) => FirstUseReminder(),
    RoutesConsts.HOME_PAGE: (context) => HomePage(),
    RoutesConsts.POLICY_PAGE: (context) => PolicyPage(),
  };

  Map<String, Function> get routes => _routes;
}

final RoutesUtil routesUtil = RoutesUtil();
