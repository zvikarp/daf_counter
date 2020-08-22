import 'package:flutter/widgets.dart';

class NavigatorKeyStore {
  GlobalKey<NavigatorState> _navigatorKey;

  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) =>
      _navigatorKey = navigatorKey;

  GlobalKey<NavigatorState> getNavigatorKey() => _navigatorKey;
}

final NavigatorKeyStore navigatorKeyStore = NavigatorKeyStore();