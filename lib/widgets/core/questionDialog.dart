import 'package:daf_counter/widgets/core/button.dart';
import 'package:daf_counter/widgets/core/dialog.dart';
import 'package:daf_counter/widgets/core/title.dart';
import 'package:flutter/material.dart';

class QuestionDialogWidget extends StatelessWidget {
  QuestionDialogWidget({
    @required this.title,
    @required this.text,
    @required this.trueActionText,
    this.falseActionText,
  });

  final String title;
  final String text;
  final String trueActionText;
  final String falseActionText;

  Widget _actionSection(BuildContext context) {
    return Row(
      children: <Widget>[
        ButtonWidget(
          onPressed: () => Navigator.pop(context, true),
          text: this.trueActionText,
        ),
        ButtonWidget(
          onPressed: () => Navigator.pop(context, false),
          text: this.falseActionText,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      margin: EdgeInsets.symmetric(horizontal: 64, vertical: 124),
      onTapBackground: () => Navigator.pop(context, false),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TitleWidget(
              title: this.title,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Text(this.text),
            ),
            _actionSection(context),
          ],
        
      ),
    );
  }
}