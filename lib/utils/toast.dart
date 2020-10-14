import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  void showInformation(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        fontSize: 16.0,
        webBgColor: "#4DB6AC",
        webPosition: "center"
    );
  }
}

final ToastUtil toastUtil = ToastUtil();