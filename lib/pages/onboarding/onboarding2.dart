import 'package:flutter/material.dart';

import 'package:daf_plus_plus/enums/progressType.dart';
import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/consts/routes.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/shared/simpleMesechetWidget.dart';
import 'package:daf_plus_plus/enums/learnType.dart';

class Onboarding2Page extends StatefulWidget {
  @override
  _Onboarding2PageState createState() => _Onboarding2PageState();
}

class _Onboarding2PageState extends State<Onboarding2Page> {
  List<String> _selectedMasechets = [];

  _done() {
    Map<String, LearnType> learnMap = _selectedMasechets.asMap().map(
        (int index, String masechetId) =>
            MapEntry(masechetId, LearnType.LearnedMasechetExactlyOnce));
    progressAction.updateAll(learnMap, ProgressType.PROGRESS_TB);
    Navigator.of(context).pushNamed(RoutesConsts.REMINDER_PAGE);
  }

  void _onClickMasechet(String masechetId, bool selected) {
    List selectedMasechets = _selectedMasechets;
    selected
        ? selectedMasechets.add(masechetId)
        : selectedMasechets.remove(masechetId);
    setState(() => _selectedMasechets = selectedMasechets);
  }

  @override
  Widget build(BuildContext context) {
    List<String> masechetsList = MasechetsData.THE_MASECHETS.keys.toList();
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: "onboardingHero",
            child: Container(
              color: Theme.of(context).primaryColor,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 48, horizontal: 32),
                  child: Text(
                    localizationUtil.translate(
                        "onboarding", "choose_masechets"),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: masechetsList.length,
              itemBuilder: (context, masechetIndex) => SimpleMesechetWidget(
                name: localizationUtil.translate(
                    "shas", masechetsList[masechetIndex]),
                checked:
                    _selectedMasechets.contains(masechetsList[masechetIndex]),
                onChange: (bool state) =>
                    _onClickMasechet(masechetsList[masechetIndex], state),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Center(
              child: ButtonWidget(
                text: localizationUtil.translate("general", "done"),
                buttonType: ButtonType.Outline,
                margin: EdgeInsets.symmetric(horizontal: 16),
                color: Theme.of(context).primaryColor,
                onPressed: _done,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
