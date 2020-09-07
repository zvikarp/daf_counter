import 'package:flutter/material.dart';

import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/consts/routes.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/spacer.dart';

class Onboarding1Page extends StatelessWidget {
  _yesAndFill(BuildContext context) {
    hiveService.settings.setIsDafYomi(true);
    _fillIn();
    Navigator.of(context).pushNamed(RoutesConsts.REMINDER_PAGE);
  }

  _fillIn() {
    DafModel todaysDaf =
        dafsDatesStore.getDafByDate(dateConverterUtil.getToday());
    int mesechtIndex = MasechetsData.THE_MASECHETS[todaysDaf.masechetId].index;
    if (mesechtIndex > 0) {
      for (int index = 0; index < mesechtIndex; index++) {
        MasechetModel masechet = MasechetsData.THE_MASECHETS.values
            .firstWhere((MasechetModel masechet) => masechet.index == index);
        ProgressModel progress =
            ProgressModel(data: List.filled(masechet.numOfDafs, 1));
        progressAction.update(masechet.id, progress);
      }
    }
    MasechetModel currentMasechet =
        MasechetsData.THE_MASECHETS[todaysDaf.masechetId];
    ProgressModel progress =
        ProgressModel(data: List.filled(currentMasechet.numOfDafs, 0));
    for (int i = 0; i < todaysDaf.number; i++) {
      progress.data[i] = 1;
    }
    progressAction.update(currentMasechet.id, progress);
  }

  _justYes(BuildContext context) {
    hiveService.settings.setIsDafYomi(true);
    Navigator.of(context).pushNamed(RoutesConsts.ONBOARDING2_PAGE);
  }

  _no(BuildContext context) {
    hiveService.settings.setIsDafYomi(false);
    Navigator.of(context).pushNamed(RoutesConsts.ONBOARDING2_PAGE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: "onboardingHero",
              child: Container(
                color: Theme.of(context).primaryColor,
                child: SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 48, horizontal: 32),
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          localizationUtil.translate(
                              "onboarding", "onboarding1_title"),
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        SpacerWidget(height: 24),
                        Text(
                          localizationUtil.translate(
                              "onboarding", "onboarding1_subtitle"),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SpacerWidget(height: 42),
          ButtonWidget(
            text: localizationUtil.translate(
                "onboarding", "learning_daf_in_sync"),
            subtext: localizationUtil.translate(
                "onboarding", "learning_daf_in_sync_subtext"),
            buttonType: ButtonType.Outline,
            color: Theme.of(context).primaryColor,
            onPressed: () => _yesAndFill(context),
          ),
          SpacerWidget(height: 24),
          ButtonWidget(
            text:
                localizationUtil.translate("onboarding", "learning_daf_alone"),
            buttonType: ButtonType.Outline,
            color: Theme.of(context).primaryColor,
            onPressed: () => _justYes(context),
          ),
          SpacerWidget(height: 24),
          ButtonWidget(
            text: localizationUtil.translate("onboarding", "not_learning_daf"),
            buttonType: ButtonType.Outline,
            color: Theme.of(context).primaryColor,
            onPressed: () => _no(context),
          ),
          SpacerWidget(height: 42),
        ],
      ),
    );
  }
}
