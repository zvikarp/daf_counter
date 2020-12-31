import 'package:flutter/material.dart';

import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/progress.dart';

class MasechetModel {
  const MasechetModel({
    @required this.index,
    @required this.id,
    @required this.sederId,
    this.numOfDafsTB = 0,
    this.numOfPerakim = 0,
    this.progress,
  });

  final int index;
  final String id;
  final int numOfDafsTB;
  final int numOfPerakim;
  final String sederId;
  final ProgressModel progress;

  bool inTB() => numOfDafsTB > 0;

  factory MasechetModel.byMasechetId(String masechetId) =>
      MasechetsData.THE_MASECHETS[masechetId];
}
