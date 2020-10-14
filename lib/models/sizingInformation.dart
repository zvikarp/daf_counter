import 'package:flutter/widgets.dart';

import 'package:daf_plus_plus/enums/deviceScreenType.dart';

class SizingInformationModel {
  final Orientation orientation;
  final DeviceScreenType deviceType;
  final Size screenSize;
  final Size localWidgetSize;
  SizingInformationModel({
    this.orientation,
    this.deviceType,
    this.screenSize,
    this.localWidgetSize,
  });
  @override
  String toString() {
    return 'Orientation:$orientation DeviceType:$deviceType ScreenSize:$screenSize LocalWidgetSize:$localWidgetSize';
  }
}
