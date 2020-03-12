import 'package:flutter/material.dart';

import 'package:daf_plus_plus/models/dafLocation.dart';
import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/dialogs/FirstUseDialogFillIn.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/utils/gematriaConverter.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/dialog.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/pages/home.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';

class FirstUseDialogTwo extends StatelessWidget {
  _yes(BuildContext context) {
    hiveService.settings.setHasOpened(true);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    // TODO Set all daf done till current
  }

  _no(BuildContext context) {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => FirstUseDialogFillIn(),
      ),
    );
  }

  String _getDafNumber(int daf) {
    if (localizationUtil.translate('display_dapim_as_gematria'))
      return gematriaConverterUtil
          .toGematria((daf + Consts.FIST_DAF))
          .toString();
    return (daf + Consts.FIST_DAF).toString();
  }

  String getYesterdaysDaf() {
    DateTime yesterday =
        dateConverterUtil.getToday().subtract(Duration(days: -1));
    DafLocationModel yesterdaysDaf = dafsDatesStore.getDafByDate(yesterday);

    String masechet = localizationUtil.translate(yesterdaysDaf.masechetId);
    String daf = _getDafNumber(yesterdaysDaf.dafIndex);
    return masechet + " " + daf;
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      hasShadow: false,
      onTapBackground: () => Navigator.pop(context),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TitleWidget(
              title: localizationUtil.translate("welcome"),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      localizationUtil.translate("daf_holding"),
                      textScaleFactor: 1.2,
                    )),
                Text(
                    localizationUtil.translate("daf_yesterday") +
                        getYesterdaysDaf(),
                    style: TextStyle(
                        color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    textScaleFactor: 0.8),
                ListTile(
                  title: ButtonWidget(
                    text: localizationUtil.translate("yes"),
                    buttonType: ButtonType.Outline,
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _yes(context),
                  ),
                ),
                ListTile(
                  title: ButtonWidget(
                    text: localizationUtil.translate("no"),
                    buttonType: ButtonType.Outline,
                    color: Theme.of(context).primaryColor,
                    onPressed: () => _no(context),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}