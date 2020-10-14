import 'package:package_info/package_info.dart';

import 'package:daf_plus_plus/consts/consts.dart';

class AppVersionUtil {
  Future<int> getBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);
    return buildNumber ?? Consts.DEFAULT_BUILD_NUMBER;
  }
}

final AppVersionUtil appVersionUtil = AppVersionUtil();
