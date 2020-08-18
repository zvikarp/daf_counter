import 'dart:math';

import 'package:daf_plus_plus/dialogs/masechetOptions.dart';
import 'package:daf_plus_plus/enums/deviceScreenType.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/shared/responsive/responsive.dart';
import 'package:flutter/material.dart';

import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/utils/localization.dart';

class MasechetTitleWidget extends StatelessWidget {
  MasechetTitleWidget({
    @required this.masechet,
    @required this.progress,
    @required this.inList,
    @required this.isExpanded,
    @required this.onChangeExpanded,
  });

  final MasechetModel masechet;
  final ProgressModel progress;
  final bool inList;
  final bool isExpanded;
  final Function(bool) onChangeExpanded;

  void _changeExpandedState() {
    this.onChangeExpanded(!this.isExpanded);
  }

  void _openMasechetOptions(BuildContext context) {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => MasechetOptionsDialog(
          masechetId: this.masechet.id,
          progress: this.progress,
        ),
      ),
    );
  }

  Widget _gapWidget(BuildContext context, int gaps) {
    if (gaps > 0) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).errorColor,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(gaps.toString()),
      );
    } else
      return Container();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(builder: (context, sizingInformation) {
      bool isMobile = sizingInformation.deviceType == DeviceScreenType.Mobile;
      return GestureDetector(
        onTap: inList ? _changeExpandedState : () {},
        onLongPress: () => _openMasechetOptions(context),
        child: Container(
          padding: isMobile ? EdgeInsets.only(top: 16) : EdgeInsets.zero,
          margin: isMobile
              ? EdgeInsets.only(right: 8, left: 8, bottom: 8)
              : EdgeInsets.zero,
          child: Container(
            padding: isMobile
                ? EdgeInsets.symmetric(vertical: 8, horizontal: 12)
                : !inList
                    ? EdgeInsets.symmetric(vertical: 24, horizontal: 36)
                    : EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius:
                  isMobile ? BorderRadius.circular(5) : BorderRadius.zero,
              color: isMobile
                  ? Theme.of(context).accentColor
                  : Theme.of(context).cardColor.withOpacity(0.5),
            ),
            child: Row(
              children: <Widget>[
                inList
                    ? Transform.rotate(
                        angle: this.isExpanded ? pi / 1 : 0,
                        child: IconButton(
                          icon: Icon(Icons.keyboard_arrow_down),
                          onPressed: _changeExpandedState,
                        ),
                      )
                    : Container(),
                Expanded(
                  child: Text(
                    localizationUtil.translate("general", "masechet") +
                        " " +
                        localizationUtil.translate("shas", this.masechet.id),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    progress.countDone().toString() +
                        "/" +
                        progress.data.length.toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                _gapWidget(context, progress.countGaps()),
              ],
            ),
          ),
        ),
      );
    });
  }
}
