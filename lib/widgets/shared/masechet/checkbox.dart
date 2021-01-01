import 'package:flutter/material.dart';

class CheckboxWidget extends StatelessWidget {
  CheckboxWidget({
    @required this.onPress,
    @required this.onLongPress,
    @required this.value,
    @required this.selectedColor,
    this.size = 24,
    this.emptyState,
    this.borderColor = Colors.black54,
  });

  final Function onPress;
  final Function onLongPress;
  final int value;
  final Color selectedColor;
  final double size;
  final Widget emptyState;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    bool selected = value > 0 ? true : false;
    return AnimatedContainer(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: selected ? selectedColor : Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(size / 8),
        border: Border.all(
          color: selected ? selectedColor : borderColor,
          width: 2,
        ),
      ),
      duration: Duration(milliseconds: 100),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onPress,
        onLongPress: onLongPress,
        child: Container(
          width: size,
          height: size,
          child: selected
              ? Center(
                  child: value != 1
                      ? Text(
                          value.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              height: 1.2,
                              fontWeight: FontWeight.bold),
                        )
                      : Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                )
              : emptyState != null
                  ? emptyState
                  : Container(),
        ),
      ),
    );
  }
}
