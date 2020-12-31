import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'package:daf_plus_plus/enums/progressType.dart';
import 'package:daf_plus_plus/enums/learnType.dart';
import 'package:daf_plus_plus/models/daf.dart';
import 'package:daf_plus_plus/models/progress.dart';
import 'package:daf_plus_plus/stores/progress.dart';
import 'package:daf_plus_plus/widgets/shared/masechet/checkbox.dart';
import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/core/infoDialog.dart';

// TODO: oh, wow, there is a lot that can be improved here:
// 1. what if the button is pressed, do we undo it, tell him something about it
// 2. what if he didn't press the button but the daf was learned, is it any differant?
// 3. should we tell him what daf it is today?
// 4. an undo option in the toast (maybe snackbar)
// 5. if not doing the daf yomi, dont show

class DafYomiFabWidget extends StatefulWidget {
  DafYomiFabWidget({
    @required this.dafYomi,
  });

  final DafModel dafYomi;

  @override
  _DafYomiFabWidgetState createState() => _DafYomiFabWidgetState();
}

class _DafYomiFabWidgetState extends State<DafYomiFabWidget> {
  void _displayInfo(BuildContext context) async {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => InfoDialogWidget(
          text: localizationUtil.translate("home", "daf_yomi_dialog_text"),
          actionText: localizationUtil.translate("general", "confirm_button"),
        ),
      ),
    );
  }

  void _onPress() async {
    bool isFirst = !hiveService.settings.getUsedFab();
    if (isFirst) {
      _displayInfo(context);
      hiveService.settings.setUsedFab(true);
    } else {
      progressAction.learnedTodaysDaf();
    }
  }

  void _onLongPress() async {
    progressAction.update(widget.dafYomi.masechetId, LearnType.UnlearnedDafOnce,
        ProgressType.PROGRESS_TB, widget.dafYomi.number);
  }

  Widget button(int dafYomiProgress) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(0, 0),
          )
        ],
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: CheckboxWidget(
          onPress: _onPress,
          onLongPress: _onLongPress,
          selectedColor: Theme.of(context).primaryColor,
          borderColor: Theme.of(context).accentColor,
          size: 56,
          value: dafYomiProgress,
          emptyState: Icon(
            Icons.check,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BuildContext progressContext = progressAction.getProgressContext();
    return Observer(builder: (context) {
      ProgressStore progressStore = Provider.of<ProgressStore>(progressContext);
      ProgressModel progress =
          progressStore.getProgressTBMap[widget.dafYomi.masechetId];
      if (progress != null) {
        int dafYomiProgress = progress.data[widget.dafYomi.number];
        return button(dafYomiProgress);
      } else {
        return Container();
      }
    });
  }
}
