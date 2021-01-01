import 'package:flutter/material.dart';

import 'package:daf_plus_plus/enums/progressType.dart';
import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/enums/learnType.dart';
import 'package:daf_plus_plus/utils/transparentRoute.dart';
import 'package:daf_plus_plus/widgets/core/questionDialog.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/utils/localization.dart';

class DeleteAllWidget extends StatefulWidget {
  @override
  _DeleteAllWidgetState createState() => _DeleteAllWidgetState();
}

class _DeleteAllWidgetState extends State<DeleteAllWidget> {
  bool _deleteAllLoading = false;

  void _comfirmFormatProgress(BuildContext context) async {
    bool shouldFormatProgress = await Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => QuestionDialogWidget(
          icon: Icons.warning,
          text: localizationUtil.translate(
              "settings", "settings_reset_warning_text"),
          trueActionText: localizationUtil.translate("general", "yes"),
          falseActionText: localizationUtil.translate("general", "no"),
        ),
      ),
    );
    if (shouldFormatProgress) _formatProgress();
  }

  void _formatProgress() {
    List<String> masechetsIdsMap = MasechetsData.THE_MASECHETS.keys.toList();

    Map<String, LearnType> learnMap = masechetsIdsMap.asMap().map(
        (int index, String masechetId) =>
            MapEntry(masechetId, LearnType.UnlearndMasechetExactlyZero));
    progressAction.updateAll(learnMap, ProgressType.PROGRESS_TB);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListTile(
        title: Text(
          localizationUtil.translate("settings", "settings_reset_text"),
          style: Theme.of(context).textTheme.bodyText2,
        ),
        trailing: ButtonWidget(
          text: localizationUtil.translate("settings", "reset_button"),
          buttonType: ButtonType.Outline,
          color: Theme.of(context).primaryColor,
          loading: _deleteAllLoading,
          disabled: _deleteAllLoading,
          onPressed: () => _comfirmFormatProgress(context),
        ),
      ),
    );
  }
}
