import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:daf_plus_plus/services/hive/progressMishnaBox.dart';
import 'package:daf_plus_plus/services/hive/progressTBBox.dart';
import 'package:daf_plus_plus/services/hive/settingsBox.dart';

class HiveService {
  ProgressTBBox progressTB = progressTBBox;
  ProgressMishnaBox progressMishna = progressMishnaBox;
  SettingsBox settings = settingsBox;

  Future<void> initHive() async {
    await Hive.initFlutter();
  }
}

final HiveService hiveService = HiveService();
