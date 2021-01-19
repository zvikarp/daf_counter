import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:daf_plus_plus/dialogs/signin.dart';
import 'package:daf_plus_plus/services/auth.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/toast.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';

class AccountWidget extends StatefulWidget {
  @override
  _AccountWidgetState createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  bool _isAuthed = false;
  bool _connectionLoading = false;

  void _onDisconnectGoogleAccount() async {
    setState(() => _connectionLoading = true);
    await authService.signOut();
    await _getAuthedState();
    toastUtil.showInformation(localizationUtil.translate(
        "settings", "toast_success_disconnect_account"));
    setState(() => _connectionLoading = false);
  }

  Future<void> _getAuthedState() async {
    setState(() => _connectionLoading = true);
    bool isAuthed = await authService.isAuthed();
    setState(() {
      _isAuthed = isAuthed;
      _connectionLoading = false;
    });
  }

  void _openSigninDialog() async {
    setState(() => _connectionLoading = true);
    await Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => SigninDialog(),
      ),
    );
    await _getAuthedState();
    setState(() => _connectionLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _getAuthedState();
  }

  Widget _connectAccountWidget() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListTile(
        title: Text(
          localizationUtil.translate("settings", "settings_not_backedup_text"),
          style: Theme.of(context).textTheme.bodyText2,
        ),
        subtitle: Text(
          localizationUtil.translate(
              "settings", "settings_not_backedup_subtext"),
          style: Theme.of(context).textTheme.bodyText2,
        ),
        trailing: ButtonWidget(
          text: localizationUtil.translate("settings", "connect_button"),
          buttonType: ButtonType.Filled,
          color: Theme.of(context).primaryColor,
          loading: _connectionLoading,
          disabled: _connectionLoading,
          onPressed: _openSigninDialog,
        ),
      ),
    );
  }

  Widget _disconnectAccountWidget() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListTile(
        title: Text(
          localizationUtil.translate("settings", "settings_backuped_text"),
          style: Theme.of(context).textTheme.bodyText2,
        ),
        subtitle: Text(
          hiveService.settings.getLastBackup() != null
              ? localizationUtil.translate(
                      "settings", "settings_backuped_subtext") +
                  DateFormat.yMd()
                      .add_Hm()
                      .format(hiveService.settings.getLastBackup())
              : "",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        trailing: ButtonWidget(
          text: localizationUtil.translate("settings", "disconnect_button"),
          buttonType: ButtonType.Outline,
          color: Theme.of(context).primaryColor,
          loading: _connectionLoading,
          disabled: _connectionLoading,
          onPressed: _onDisconnectGoogleAccount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isAuthed ? _disconnectAccountWidget() : _connectAccountWidget();
  }
}
