import 'package:flutter/material.dart';

import 'package:daf_plus_plus/enums/learnType.dart';
import 'package:daf_plus_plus/widgets/shared/masechet/checkbox.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/gematriaConverter.dart';

class DafWidget extends StatelessWidget {
  DafWidget({
    @required this.dafNumber,
    @required this.dafCount,
    @required this.onChangeCount,
    @required this.dafDate,
    @required this.preferredCalendar,
    this.isDafYomi = false,
  });

  final int dafNumber;
  final int dafCount;
  final Function(LearnType) onChangeCount;
  final DateTime dafDate;
  final String preferredCalendar;
  final bool isDafYomi;

  void _onPressCheckbox() {
    onChangeCount(LearnType.LearnedDafOnce);
  }

  void _onLongPressCheckbox() {
    onChangeCount(LearnType.UnlearnedDafOnce);
  }

  String _getDafNumber() {
    if (localizationUtil.translate("calendar", "display_dapim_as_gematria"))
      return gematriaConverterUtil
          .toGematria((dafNumber + Consts.FIST_DAF))
          .toString();
    return (dafNumber + Consts.FIST_DAF).toString();
  }

  String _theDate(dafDate) {
    if (preferredCalendar == "english_calendar")
      return dateConverterUtil.toEnglishDate(dafDate);
    else if (preferredCalendar == "hebrew_calendar")
      return dateConverterUtil.toHebrewDate(dafDate);
    return "";
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
          value: dafCount,
          selected: dafCount > 0 ? true : false,
        ),
        trailing: Text(
          dateConverterUtil.getDayInWeek(dafDate) + ", " + _theDate(dafDate),
          style: Theme.of(context).textTheme.bodyText2,
        ),
        title: Text(
            localizationUtil.translate("general", "daf") +
                " " +
                _getDafNumber(),
            style: Theme.of(context).textTheme.bodyText2),
      ),
    );
  }
}
