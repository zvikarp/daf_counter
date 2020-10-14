import 'package:flutter/material.dart';

import 'package:daf_plus_plus/enums/deviceScreenType.dart';
import 'package:daf_plus_plus/widgets/shared/responsive/responsive.dart';

class OnboardingPageTemplate extends StatelessWidget {
  OnboardingPageTemplate({
    @required this.headerChildren,
    @required this.actionChildren,
  });

  final List<Widget> headerChildren;
  final List<Widget> actionChildren;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (context, sizingInformation) => Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: "onboardingHero",
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: SafeArea(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 48, horizontal: 32),
                      color: Theme.of(context).primaryColor,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: headerChildren),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 48, horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    sizingInformation.deviceType == DeviceScreenType.Mobile
                        ? CrossAxisAlignment.stretch
                        : CrossAxisAlignment.center,
                children: actionChildren,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
