import 'package:flutter/material.dart';

import 'package:daf_plus_plus/widgets/core/button.dart';
import 'package:daf_plus_plus/widgets/core/dialog.dart';
import 'package:daf_plus_plus/widgets/core/title.dart';

class InfoDialogWidget extends StatelessWidget {
  InfoDialogWidget({
    this.title,
    this.icon,
    @required this.text,
    @required this.actionText,
  });

  final String title;
  final IconData icon;
  final String text;
  final String actionText;

  Widget _actionSection(BuildContext context) {
    return ButtonWidget(
      onPressed: () => Navigator.pop(context, true),
      text: this.actionText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      responsiveMargin: 0.4,
      margin: EdgeInsets.symmetric(horizontal: 32, vertical: 124),
      onTapBackground: () => Navigator.pop(context, false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TitleWidget(
            title: this.title,
            icon: this.icon,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              this.text,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          _actionSection(context),
        ],
      ),
    );
  }
}
