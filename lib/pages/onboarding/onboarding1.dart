import 'package:flutter/material.dart';

import 'package:daf_plus_plus/enums/progressType.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/enums/learnType.dart';
import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/consts/routes.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/stores/dafsDates.dart';
import 'package:daf_plus_plus/utils/dateConverter.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/spacer.dart';
import 'package:daf_plus_plus/widgets/onboarding/pageTemplate.dart';

class Onboarding1Page extends StatelessWidget {
  _yesAndFill(BuildContext context) {
    hiveService.settings.setIsDafYomi(true);
    _fillIn();
    Navigator.of(context).pushNamed(RoutesConsts.REMINDER_PAGE);
  }

  _fillIn() {
    DafModel todaysDaf =
        dafsDatesStore.getDafByDate(dateConverterUtil.getToday());
    int masechetIndex = MasechetsData.THE_MASECHETS[todaysDaf.masechetId].index;
    if (masechetIndex > 0) {
      Map<String, LearnType> learnMap = {};
      MasechetsData.THE_MASECHETS.values
          .where((MasechetModel masechet) => (masechet.inTB()))
          .toList()
          .asMap()
          .forEach((int index, MasechetModel masechet) {
        if (index < masechetIndex) {
          learnMap[masechet.id] = LearnType.LearnedMasechetExactlyOnce;
        }
        progressAction.updateAll(learnMap, ProgressType.PROGRESS_TB);
      });
    }
    progressAction.update(
        todaysDaf.masechetId,
        LearnType.LearnedUntilDafExactlyOnce,
        ProgressType.PROGRESS_TB,
        todaysDaf.number);
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
    List<Widget> headerChildren = [
      Text(
        localizationUtil.translate("onboarding", "onboarding1_title"),
        style: Theme.of(context).textTheme.headline3,
      ),
      SpacerWidget(height: 24),
      Text(
        localizationUtil.translate("onboarding", "onboarding1_subtitle"),
        style: Theme.of(context).textTheme.bodyText1,
      ),
    ];
    List<Widget> actionChildren = [
      ButtonWidget(
        text: localizationUtil.translate("onboarding", "learning_daf_in_sync"),
        subtext: localizationUtil.translate(
            "onboarding", "learning_daf_in_sync_subtext"),
        buttonType: ButtonType.Outline,
        margin: EdgeInsets.symmetric(horizontal: 16),
        color: Theme.of(context).primaryColor,
        onPressed: () => _yesAndFill(context),
      ),
      SpacerWidget(height: 24),
      ButtonWidget(
        text: localizationUtil.translate("onboarding", "learning_daf_alone"),
        buttonType: ButtonType.Outline,
        margin: EdgeInsets.symmetric(horizontal: 16),
        color: Theme.of(context).primaryColor,
        onPressed: () => _justYes(context),
      ),
      SpacerWidget(height: 24),
      ButtonWidget(
        text: localizationUtil.translate("onboarding", "not_learning_daf"),
        buttonType: ButtonType.Outline,
        margin: EdgeInsets.symmetric(horizontal: 16),
        color: Theme.of(context).primaryColor,
        onPressed: () => _no(context),
      ),
    ];
    return OnboardingPageTemplate(
        headerChildren: headerChildren, actionChildren: actionChildren);
  }
}
