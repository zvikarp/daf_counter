import 'package:daf_plus_plus/enums/AccountProvider.dart';
import 'package:daf_plus_plus/utils/platform.dart';
import 'package:flutter/material.dart';

import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/consts/responses.dart';
import 'package:daf_plus_plus/models/Response.dart';
import 'package:daf_plus_plus/services/auth.dart';
import 'package:daf_plus_plus/services/firestore/index.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/toast.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/core/questionDialog.dart';
import 'package:daf_plus_plus/widgets/core/spacer.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/dialog.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';

class SigninDialog extends StatefulWidget {
  @override
  _SigninDialogState createState() => _SigninDialogState();
}

class _SigninDialogState extends State<SigninDialog> {
  bool _loading = false;

  void _exitDialog(BuildContext context) => Navigator.pop(context);

  void _onConnectAccount(BuildContext context, AccountProvider provider) async {
    setState(() => _loading = true);
    String userId = await authService.signin(provider);
    if (userId == null) {
      _onConnectFail();
    } else {
      await _onConnectionSuccess(context);
    }
    setState(() => _loading = false);
    _exitDialog(context);
  }

  void _onConnectFail() {
    toastUtil.showInformation(
        localizationUtil.translate("settings", "toast_fail_connect_account"));
  }

  Future<void> _onConnectionSuccess(BuildContext context) async {
    ResponseModel progressResponse =
        await firestoreService.progress.getProgressMap();
    if (progressResponse.isSuccessful()) {
      await _existingUserHasBackup(context);
    } else if (progressResponse.code ==
        ResponsesConst.DOCUMENT_NOT_FOUND.code) {
      await progressAction.backup();
      toastUtil.showInformation(localizationUtil.translate(
          "settings", "toast_success_connect_account"));
    } else {
      toastUtil.showInformation(
          localizationUtil.translate("settings", "toast_fail_connect_account"));
    }
  }

  Future<void> _existingUserHasBackup(BuildContext context) async {
    DateTime lastUpdated = hiveService.settings.getLastUpdated();
    if (lastUpdated == null)
      await progressAction.restore();
    else {
      bool restore = await Navigator.of(context).push(
        TransparentRoute(
          builder: (BuildContext context) => QuestionDialogWidget(
            icon: Icons.warning,
            text: localizationUtil.translate("settings", "backup_warning_text"),
            trueActionText:
                localizationUtil.translate("settings", "use_backup_button"),
            falseActionText:
                localizationUtil.translate("settings", "delete_backup_button"),
          ),
        ),
      );
      if (restore) await progressAction.restore();
      await progressAction.backup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      responsiveMargin: 0.4,
      onTapBackground: () => _exitDialog(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TitleWidget(
            title: localizationUtil.translate("signin", "title"),
          ),
          if (!_loading)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ButtonWidget(
                  text: localizationUtil.translate(
                      "signin", "signin-with-google"),
                  buttonType: ButtonType.Outline,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  color: Theme.of(context).primaryColor,
                  onPressed: () =>
                      _onConnectAccount(context, AccountProvider.GOOGLE),
                ),
                ButtonWidget(
                  text:
                      localizationUtil.translate("signin", "signin-with-apple"),
                  buttonType: ButtonType.Outline,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  color: Theme.of(context).primaryColor,
                  disabled: !platformUtil.isIos(),
                  onPressed: () =>
                      _onConnectAccount(context, AccountProvider.APPLE),
                ),
              ],
            ),
          if (_loading)
            Container(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
          SpacerWidget(height: 32),
        ],
      ),
    );
  }
}
