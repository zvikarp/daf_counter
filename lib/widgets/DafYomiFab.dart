import 'package:daf_plus_plus/models/progress.dart';
import 'package:flutter/material.dart';

import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/toast.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/core/infoDialog.dart';

// TODO: oh, wow, there is a lot that can be improved here:
// 1. what if the button is pressed, do we undo it, tell him something about it
// 2. what if he didn't press the button but the daf was learned, is it any differant?
// 3. should we tell him what daf it is today?
// 4. an undo option in the toast (maybe snackbar)
// 5. if not doing the daf yomi, dont show

class DafYomiFabWidget extends StatelessWidget {
  DafModel _getTodaysDaf() {
    return dafsDatesStore.getDafByDate(dateConverterUtil.getToday());
  }

  void _displayInfo(BuildContext context) async {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => InfoDialogWidget(
          title: localizationUtil.translate('plus_plus_dialog_title'),
          text: localizationUtil.translate('plus_plus_dialog_text'),
          actionText: localizationUtil.translate('confirm_button'),
        ),
      ),
    );
  }

  // TODO: the next two functions are from masechetCHildren.dart, it should be in one place only.
  // ProgressModel _generateNewProgress() => ProgressModel.empty(masechet.numOfDafs);

  ProgressModel _getMasechetProgress(String masechetId) {
    ProgressModel progress =
        hiveService.progress.getProgress(masechetId);
    return progress;
    // return encodedProgress != null
    //     ? masechetConverterUtil.decode(encodedProgress)
    //     : _generateNewProgress(masechetId);
  }

  void _learnedTodaysDaf(BuildContext context) {
    DafModel todaysDaf = _getTodaysDaf();
    ProgressModel progress = _getMasechetProgress(todaysDaf.masechetId);
    progress.data[todaysDaf.number] = 1; // TODO: really not ideal.
    progressAction.update(context, todaysDaf.masechetId, progress);
    hiveService.settings.setLastDaf(todaysDaf);
    toastUtil.showInformation(localizationUtil.translate('plus_plus_toast'));
  }

  void _checkIfFirstTime(BuildContext context) {
    bool isFirst = !hiveService.settings.getUsedFab();
    if (isFirst) {
      _displayInfo(context);
      hiveService.settings.setUsedFab(true);
    } else
      _learnedTodaysDaf(context);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _checkIfFirstTime(context),
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(
        "++",
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}
