
import 'package:fluttertoast/fluttertoast.dart';

class Toasting{

  void showToast(String text){
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      gravity: ToastGravity.CENTER,
    );
  }
}