import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:daf_plus_plus/pages/settings.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/core/dialog.dart';
import 'package:daf_plus_plus/utils/localization.dart';

class AppBarWidget extends StatefulWidget with PreferredSizeWidget {
  AppBarWidget({
    this.displaySettings = false,
    this.tabs = const [],
  });

  final bool displaySettings;
  final List<String> tabs;

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(tabs.isNotEmpty ? 92 : 48);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  double _plusPlusWidth = 0;

  void _openSettings() {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => DialogWidget(
          onTapBackground: () => Navigator.pop(context),
          child: SettingsPage(),
        ),
      ),
    );
  }

  Widget _textTab(String text, double width) {
    return Container(
      width: width,
      child: Tab(
          child: Text(
        localizationUtil.translate("home", text),
        style: Theme.of(context).textTheme.headline5,
      )),
    );
  }

  Widget _iconTab(IconData icon, double width) {
    return Container(width: width, child: Tab(child: Icon(icon)));
  }

  Widget _appBarTitle() {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Image.asset(
          "assets/icon/daf-white-on-transperant.png",
          width: 30,
          height: 36,
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 150),
          width: _plusPlusWidth,
          height: 36,
          child: Image.asset(
            "assets/icon/pp-white-on-transperant.png",
            width: 36,
            height: 36,
            fit: BoxFit.fitHeight,
            alignment: Alignment.centerLeft,
          ),
        ),
      ],
    );
  }

  Widget _tabBar() {
    double screenWidth = MediaQuery.of(context).size.width;
    double settingsButtonWidth = 56;
    int numOfTextTabs = widget.tabs.length == 3 ? 2 : 3;
    double textTabWidth = (screenWidth - settingsButtonWidth) / numOfTextTabs;

    return TabBar(
      indicatorWeight: 3,
      isScrollable: true,
      indicatorColor: Theme.of(context).textTheme.headline5.color,
      labelPadding: EdgeInsets.all(0),
      tabs: widget.tabs
          .map(
            (text) => text != "settings"
                ? _textTab(text, textTabWidth)
                : _iconTab(Icons.settings, settingsButtonWidth),
          )
          .toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() => _plusPlusWidth = 30);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _appBarTitle(),
      centerTitle: true,
      leading: Container(),
      actions: [
        if (widget.displaySettings)
          IconButton(icon: Icon(Icons.settings), onPressed: _openSettings)
      ],
      bottom: widget.tabs.isNotEmpty ? _tabBar() : null,
    );
  }
}
