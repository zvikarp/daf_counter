import 'package:flutter/material.dart';

import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/appVersion.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/core/infoDialog.dart';

class BackwardCompatibilityUtil {
  void _newFeatureNotifications(BuildContext context) async {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => InfoDialogWidget(
          text: localizationUtil.translate(
              "home", "notifications_options_dialog_text"),
          actionText: localizationUtil.translate("general", "confirm_button"),
        ),
      ),
    );
  }

  void actUponBuildNumber(BuildContext context) async {
    int buildNumber = await appVersionUtil.getBuildNumber();
    int lastUpdatedBuildNumber =
        hiveService.settings.getLastUpdatedBuildNumber();

    if (lastUpdatedBuildNumber <= 8) {
      _newFeatureNotifications(context);
    }

    hiveService.settings.setLastUpdatedBuildNumber(buildNumber);
  }
}

final BackwardCompatibilityUtil backwardCompatibilityUtil =
    BackwardCompatibilityUtil();
