import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/theme.dart';

class SetThemeWidget extends StatefulWidget {
  @override
  _SetThemeWidgetState createState() => _SetThemeWidgetState();
}

class _SetThemeWidgetState extends State<SetThemeWidget> {
  String _currentTheme = "";
  List<String> _themesList = [""];

  void _changeTheme(String theme) {
    hiveService.settings.setPreferredTheme(theme);
    setState(() {
      _currentTheme = theme;
    });
    DynamicTheme.of(context).setThemeData(themeUtil.getTheme(context, theme));
  }

  void _getThemes() {
    List<String> themesList =
        localizationUtil.translate("settings", "theme_types").keys.toList();
    String currentTheme = hiveService.settings.getPreferredTheme() ??
        Consts.DEFAULT_THEME_TYPE;
    setState(() {
      _currentTheme = currentTheme;
      _themesList = themesList;
    });
  }

  @override
  void initState() {
    super.initState();
    _getThemes();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListTile(
        title: Text(
            localizationUtil.translate("settings", "settings_theme_text")),
        trailing: DropdownButton<String>(
          value: _currentTheme,
          underline: Container(
            height: 2,
            color: Theme.of(context).primaryColor,
          ),
          onChanged: _changeTheme,
          items:
              _themesList.map<DropdownMenuItem<String>>((String theme) {
            return DropdownMenuItem<String>(
              value: theme,
              child: Text(localizationUtil.translate(
                  "settings", "theme_types")[theme]),
            );
          }).toList(),
        ),
      ),
    );
  }
}
