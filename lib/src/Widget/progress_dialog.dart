import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PG {
  ProgressDialog? pr;
  BuildContext? context;

  PG(BuildContext contex){
    context = contex;
    pr = ProgressDialog(
      contex,
      isDismissible: true,
    );
  }

  ProgressDialog? setPg(String s){
    pr!.style(
        message: s,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );

    return pr;
  }
}