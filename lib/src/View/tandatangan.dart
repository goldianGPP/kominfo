import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:kominfo/src/Controller/pengguna_controller.dart';
import 'package:kominfo/src/View/mobile.dart';
import 'package:kominfo/src/Widget/progress_dialog.dart';
import 'package:kominfo/src/Widget/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Tandatangan extends StatefulWidget {
  const Tandatangan({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TandatanganState();
  }
}

class TandatanganState extends State<Tandatangan> {
  List<Offset> _points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    ProgressDialog? pr = PG(context).setPg("menunggu...");

    final isDialOpen = ValueNotifier(false);
    return WillPopScope(
        onWillPop: () async {
          if(isDialOpen.value){
            return isDialOpen.value = false;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Masukkan Tandatangan"),
            centerTitle: true,
            backgroundColor: Colors.blueAccent,
            automaticallyImplyLeading: true,
          ),
          body:  GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                RenderBox? object = context.findRenderObject() as RenderBox?;
                Offset _localPosition =
                object!.globalToLocal(details.globalPosition);
                _points = List.from(_points)..add(_localPosition);
              });
            },
            onPanEnd: (DragEndDetails details) => _points.add(Offset.zero),
            child: CustomPaint(
              painter: Signature(points: _points),
              size: Size.infinite,
            ),
          ),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            backgroundColor: Colors.blueAccent,
            openCloseDial: isDialOpen,
            children: [
              SpeedDialChild(
                  child: const Icon(Icons.restart_alt_rounded),
                  label: "gambar ulang",
                  backgroundColor: Colors.white,
                  labelBackgroundColor: Colors.white10,
                  onTap: () {_points.clear();}
              ),
              SpeedDialChild(
                  child: const Icon(Icons.save),
                  label: "simpan",
                  backgroundColor: Colors.white,
                  labelBackgroundColor: Colors.white10,
                  onTap: () async {
                    await pr!.show();
                    bool cek = await setRenderedImage(context);
                    if(cek){
                      Navigator.pop(context);
                    }
                    await pr.hide();
                  }
              ),
            ],
          ),
        )
    );
  }

  Future<ui.Image> get rendered {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    Signature painter = Signature(points: _points);
    var size = context.size;
    painter.paint(canvas, size!);
    return recorder.endRecording()
        .toImage(size.width.floor(), size.height.floor());
  }

  Future<bool> setRenderedImage(BuildContext context) async {
    ui.Image image = await rendered;
    var pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);
    var id = await SP().getSPref('id_pengguna');
    return await PenggunaController().upload(await imageSave(pngBytes!, 'signature.png'),  id!);
  }
}


class Signature extends CustomPainter {
  List<Offset> points;

  Signature({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}
