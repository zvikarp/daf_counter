import 'package:flutter/material.dart';

enum ButtonType {
  Default,
  Filled,
  Outline,
  Underline,
  Link,
}

class ButtonColors {
  ButtonColors({
    this.backgroundColor = const Color(0x00000000),
    this.outlineColor = const Color(0x00000000),
    this.textColor = const Color(0x00000000),
  });

  final Color backgroundColor;
  final Color outlineColor;
  final Color textColor;
}

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.subtext,
    this.onPressedDisabled,
    this.margin = const EdgeInsets.all(0),
    this.disabled = false,
    this.loading = false,
    this.buttonType = ButtonType.Default,
    this.color,
  });

  final String text;
  final Function onPressed;
  final String subtext;
  final Function onPressedDisabled;
  final bool disabled;
  final bool loading;
  final EdgeInsets margin;
  final ButtonType buttonType;
  final Color color;

  ButtonColors _getButtonColors() {
    Map<ButtonType, ButtonColors> typeMap = {
      ButtonType.Default: ButtonColors(
        textColor: this.color,
      ),
      ButtonType.Outline: ButtonColors(
        outlineColor: this.color,
        textColor: this.color,
      ),
      ButtonType.Underline: ButtonColors(
        outlineColor: this.color,
        textColor: this.color,
      ),
      ButtonType.Filled: ButtonColors(
        backgroundColor: this.color,
        outlineColor: this.color,
        textColor: Colors.white,
      ),
      ButtonType.Link: ButtonColors(
        textColor: this.color,
      ),
    };
    return typeMap[buttonType];
  }

  Widget _buttonContent(BuildContext context, ButtonColors buttonColors) {
    if (subtext != null)
      return Column(
        children: <Widget>[
          Text(
            text,
            style: Theme.of(context).textTheme.button.merge(
                  TextStyle(color: buttonColors.textColor),
                ),
          ),
          Text(
            subtext,
            style: Theme.of(context).textTheme.caption.merge(
                  TextStyle(color: buttonColors.textColor),
                ),
          ),
        ],
      );
    else
      return Text(
        text,
        style: buttonType == ButtonType.Link
            ? Theme.of(context).textTheme.caption.merge(
                  TextStyle(color: buttonColors.textColor),
                )
            : Theme.of(context).textTheme.button.merge(
                  TextStyle(color: buttonColors.textColor),
                ),
      );
  }

  Widget _loadingButton(ButtonColors buttonColors) {
    return Container(
      height: 16,
      width: 16,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(buttonColors.textColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ButtonColors buttonColors = _getButtonColors();
    return Padding(
      padding: margin,
      child: FlatButton(
        onPressed: disabled ? onPressedDisabled : onPressed,
        disabledColor: Theme.of(context).disabledColor,
        color: buttonColors.backgroundColor,
        shape: buttonType == ButtonType.Underline
            ? UnderlineInputBorder(
                borderSide: BorderSide(
                    color: disabled
                        ? Theme.of(context).disabledColor
                        : buttonColors.outlineColor,
                    width: 2))
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(
                    color: disabled
                        ? Theme.of(context).disabledColor
                        : buttonColors.outlineColor,
                    width: 2),
              ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: loading
              ? _loadingButton(buttonColors)
              : _buttonContent(context, buttonColors),
        ),
      ),
    );
  }
}
