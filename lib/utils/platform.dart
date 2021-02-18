import 'dart:io';

import 'package:daf_plus_plus/enums/platformType.dart';

class PlatformUtil {
  PlatformType getPlatform() {
    try {
      if (Platform.isAndroid) {
        return PlatformType.ANDROID;
      } else if (Platform.isIOS) {
        return PlatformType.IOS;
      }
      return PlatformType.WEB;
    } catch (e) {
      return PlatformType.WEB;
    }
  }

  bool isAndroid() => getPlatform() == PlatformType.ANDROID;
  bool isIos() => getPlatform() == PlatformType.IOS;
  bool isMobile() => isIos() || isAndroid();
  bool isWeb() => getPlatform() == PlatformType.WEB;
}

final PlatformUtil platformUtil = PlatformUtil();
