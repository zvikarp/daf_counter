import 'package:flutter/material.dart';

import 'package:daf_plus_plus/consts/deviceTypes.dart';
import 'package:daf_plus_plus/models/sizingInformation.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget Function(
      BuildContext context, SizingInformationModel sizingInformation) builder;
  const ResponsiveWidget({Key key, this.builder}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var sizingInformation = SizingInformationModel(
      orientation: mediaQuery.orientation,
      deviceType: getDeviceType(mediaQuery),
      screenSize: mediaQuery.size,
    );
    return builder(context, sizingInformation);
  }
}
