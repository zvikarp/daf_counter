import 'package:flutter/material.dart';

import 'package:daf_plus_plus/enums/progressType.dart';
import 'package:daf_plus_plus/enums/learnType.dart';
import 'package:daf_plus_plus/widgets/shared/masechet/checkbox.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/gematriaConverter.dart';

class PositionWidget extends StatelessWidget {
  PositionWidget({
    @required this.dafNumber,
    @required this.dafCount,
    @required this.onChangeCount,
    @required this.dafDate,
    @required this.preferredCalendar,
    @required this.progressType,
    @required this.displayDate,
    this.isDafYomi = false,
  });

  final int dafNumber;
  final int dafCount;
  final Function(LearnType) onChangeCount;
  final DateTime dafDate;
  final String preferredCalendar;
  final ProgressType progressType;
  final bool displayDate;
  final bool isDafYomi;

  void _onPressCheckbox() {
    onChangeCount(LearnType.LearnedDafOnce);
  }

  void _onLongPressCheckbox() {
    onChangeCount(LearnType.UnlearnedDafOnce);
  }

  String _getPositionNumber() {
    int firstPosition = progressType == ProgressType.PROGRESS_TB
        ? Consts.FIST_DAF
        : Consts.FIST_PEREK;
    if (localizationUtil.translate("calendar", "display_dapim_as_gematria"))
      return gematriaConverterUtil
          .toGematria((dafNumber + firstPosition))
          .toString();
    return (dafNumber + firstPosition).toString();
  }

  String _theDate(dafDate) {
    if (preferredCalendar == "english_calendar")
      return dateConverterUtil.toEnglishDate(dafDate);
    else if (preferredCalendar == "hebrew_calendar")
      return dateConverterUtil.toHebrewDate(dafDate);
    return "";
  }

  String _getPositionHeading() {
    if (progressType == ProgressType.PROGRESS_TB)
      return localizationUtil.translate('general', 'daf');
    return localizationUtil.translate('general', 'perek');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDafYomi
          ? Theme.of(context).accentColor.withOpacity(0.3)
          : Colors.transparent,
      child: ListTile(
        dense: true,
        onTap: _onPressCheckbox,
        onLongPress: _onLongPressCheckbox,
        leading: CheckboxWidget(
          onPress: _onPressCheckbox,
          onLongPress: _onLongPressCheckbox,
          selectedColor: Theme.of(context).accentColor,
          value: dafCount,
        ),
        trailing: displayDate
            ? Text(
                dateConverterUtil.getDayInWeek(dafDate) +
                    ", " +
                    _theDate(dafDate),
                style: Theme.of(context).textTheme.bodyText2,
              )
            : Text(""),
        title: Text("${_getPositionHeading()} ${_getPositionNumber()}",
            style: Theme.of(context).textTheme.bodyText2),
      ),
    );
  }
}
