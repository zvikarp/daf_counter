import 'package:daf_plus_plus/actions/progress.dart';
import 'package:daf_plus_plus/data/masechets.dart';
import 'package:daf_plus_plus/models/masechet.dart';
import 'package:daf_plus_plus/pages/home.dart';
import 'package:daf_plus_plus/services/hive/index.dart';
import 'package:daf_plus_plus/utils/localization.dart';
import 'package:daf_plus_plus/utils/masechetConverter.dart';
import 'package:daf_plus_plus/widgets/simpleMesechetWidget.dart';
import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/dialog.dart';
import 'package:flutter/material.dart';

class FirstUseDialogFillIn extends StatefulWidget {
  @override
  _FirstUseDialogFillInState createState() => _FirstUseDialogFillInState();
}

class _FirstUseDialogFillInState extends State<FirstUseDialogFillIn> {
  List<bool> _progress = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _progress = List.filled(MasechetsData.THE_MASECHETS.length, false);
    });
  }

  _done(BuildContext context) {
    for (int i = 0; i < _progress.length; i++) {
      if (_progress[i]) {
        MasechetModel masechetModel = MasechetsData.THE_MASECHETS[i];
        List<int> progressMap = List.filled(masechetModel.numOfDafs, 1);
        String progressString =
        masechetConverterUtil.encode(progressMap.map((daf) => 1).toList());
        progressAction.update(masechetModel.id, progressString);
      }
    }

    hiveService.settings.setHasOpened(true);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()));
  }

  void _onClickDaf(int masechetIndex, bool state) {
    _updateDafCount(masechetIndex, state);
  }

  void _updateDafCount(int masechetIndex, bool state) {
    setState(() {
      _progress[masechetIndex] = state;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      hasShadow: false,
      onTapBackground: () => Navigator.pop(context),
      child: Center(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(localizationUtil.translate("what_have_you_learned"),
                    textScaleFactor: 1.2),
              ),
              Expanded(
                  child: ListView.builder(
                shrinkWrap: true,
                itemCount: MasechetsData.THE_MASECHETS.length,
                itemBuilder: (context, dafIndex) => SimpleMesechetWidget(
                  name: localizationUtil
                      .translate(MasechetsData.THE_MASECHETS[dafIndex].id),
                  checked: _progress[dafIndex],
                  onChange: (bool state) => _onClickDaf(dafIndex, state),
                ),
              )),
              ListTile(
                title: ButtonWidget(
                  text: localizationUtil.translate("done"),
                  buttonType: ButtonType.Outline,
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _done(context),
                ),
              ),
            ]),
      ),
    );
  }
}
