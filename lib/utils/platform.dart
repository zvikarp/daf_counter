import 'dart:io';

import 'package:daf_plus_plus/enums/platformType.dart';

class PlatformUtil {
  PlatformType getPlatform() {
    try {
      if (Platform.isAndroid) return PlatformType.Android;
      return PlatformType.Web;
    } catch (e) {
      return PlatformType.Web;
    }
  }

  bool isAndroid() => getPlatform() == PlatformType.Android;
  bool isWeb() => getPlatform() == PlatformType.Web;
}

final PlatformUtil platformUtil = PlatformUtil();
