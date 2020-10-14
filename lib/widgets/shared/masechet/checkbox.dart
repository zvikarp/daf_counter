import 'package:flutter/material.dart';

class CheckboxWidget extends StatelessWidget {
  CheckboxWidget({
    @required this.onPress,
    @required this.onLongPress,
    @required this.selected,
    @required this.value,
  });

  final Function onPress;
  final Function onLongPress;
  final bool selected;
  final int value;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: selected ? Theme.of(context).accentColor : Colors.transparent,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: selected ? Theme.of(context).accentColor : Colors.black54,
          width: 2,
        ),
      ),
      duration: Duration(milliseconds: 100),
      child: GestureDetector(
        onTap: onPress,
        onLongPress: onLongPress,
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
            : Container(),
      ),
    );
  }
}
