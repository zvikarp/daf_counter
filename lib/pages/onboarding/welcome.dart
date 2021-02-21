import 'package:flutter/material.dart';

import 'package:daf_plus_plus/consts/routes.dart';
import 'package:daf_plus_plus/widgets/core/spacer.dart';
import 'package:daf_plus_plus/consts/consts.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/onboarding/pageTemplate.dart';

class WelcomeOnboardingPage extends StatefulWidget {
  @override
  _WelcomeOnboardingPageState createState() => _WelcomeOnboardingPageState();
}

class _WelcomeOnboardingPageState extends State<WelcomeOnboardingPage> {
  List<String> _listOfLanguages = [""];

  void _changeLanguage(BuildContext context, String language) async {
    await localizationUtil.setPreferredLanguage(language);
    Navigator.of(context).pushNamed(RoutesConsts.ONBOARDING1_PAGE);
  }

  void _getLanguages() {
    List<String> listOfLanguages =
        Consts.LOCALES.map((Locale language) => language.languageCode).toList();
    setState(() {
      _listOfLanguages = listOfLanguages;
    });
  }

  @override
  void initState() {
    super.initState();
    _getLanguages();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> headerChildren = [
      Text(
        localizationUtil.translate("onboarding", "welcome"),
        style: Theme.of(context).textTheme.headline3,
      ),
      SpacerWidget(height: 24),
      Text(
        localizationUtil.translate("onboarding", "welcome_subtitle"),
        style: Theme.of(context).textTheme.bodyText1,
      ),
    ];
    List<Widget> actionChildren = [
      ..._listOfLanguages
          .map(
            (language) => ButtonWidget(
              text: localizationUtil.translate(
                  "onboarding", "choose_" + language),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              buttonType: ButtonType.Outline,
              color: Theme.of(context).primaryColor,
              onPressed: () => _changeLanguage(context, language),
            ),
          )
          .toList(),
      ButtonWidget(
        text: "Privacy Policy",
        onPressed: () =>
            Navigator.of(context).pushNamed(RoutesConsts.POLICY_PAGE),
        buttonType: ButtonType.Link,
      ),
    ];
    return OnboardingPageTemplate(
        headerChildren: headerChildren, actionChildren: actionChildren);
  }
}
