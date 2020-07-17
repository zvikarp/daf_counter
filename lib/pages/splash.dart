import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:daf_plus_plus/stores/navigatorKey.dart';
import 'package:daf_plus_plus/consts/routes.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      NavigatorState currentState =
          navigatorKeyStore.getNavigatorKey().currentState;
      currentState.pushReplacementNamed(RoutesConsts.HOME_PAGE);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Theme.of(context).primaryColor);
  }
}
