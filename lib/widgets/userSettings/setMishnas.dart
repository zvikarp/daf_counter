import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';

class SetMishnasWidget extends StatefulWidget {
  @override
  _SetMishnasWidgetState createState() => _SetMishnasWidgetState();
}

class _SetMishnasWidgetState extends State<SetMishnasWidget> {
  bool _doesMishnas = false;

  void _changeMishnas(bool doesMishnas) async {
    hiveService.settings.setIsMishna(doesMishnas);
    _getDoesMishnas();
  }

  void _getDoesMishnas() {
    setState(() => _doesMishnas = hiveService.settings.getIsMishna());
  }

  @override
  void initState() {
    super.initState();
    _getDoesMishnas();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        title: Text(
          localizationUtil.translate("settings", "do_you_mishna"),
          style: Theme.of(context).textTheme.bodyText2,
        ),
        trailing: PlatformSwitch(
          value: _doesMishnas,
          activeColor: Theme.of(context).primaryColor,
          onChanged: _changeMishnas,
        ),
      ),
    );
  }
}
