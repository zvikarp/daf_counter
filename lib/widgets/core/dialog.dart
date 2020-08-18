import 'package:flutter/material.dart';

import 'package:daf_plus_plus/enums/deviceScreenType.dart';
import 'package:daf_plus_plus/widgets/shared/responsive/responsive.dart';

class DialogWidget extends StatelessWidget {
  DialogWidget({
    @required this.child,
    this.onTapBackground,
    this.alignment = Alignment.center,
    this.margin,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.hasShadow = true,
  });

  final Widget child;
  final Alignment alignment;
  final Function onTapBackground;
  final EdgeInsets margin;
  final BorderRadius borderRadius;
  final bool hasShadow;

  Widget build(BuildContext context) {
    return ResponsiveWidget(builder: (context, sizingInformation) {
      bool isMobile = sizingInformation.deviceType == DeviceScreenType.Mobile;
      EdgeInsets responsiveMargin = margin;
      if (margin == null) {
        responsiveMargin = isMobile
            ? EdgeInsets.symmetric(horizontal: 16, vertical: 48)
            : EdgeInsets.symmetric(horizontal: 256, vertical: 124);
      }
      return Scaffold(
        backgroundColor: hasShadow ? Color(0xBB000000) : Colors.transparent,
        body: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onTapBackground != null ? onTapBackground : () {},
            child: Container(
              alignment: alignment,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  margin: responsiveMargin,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: borderRadius,
                    boxShadow: [
                      new BoxShadow(
                        color: Color(0x6a000000),
                        blurRadius: 20.0,
                      )
                    ],
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
