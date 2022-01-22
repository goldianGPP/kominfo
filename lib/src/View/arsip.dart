import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kominfo/src/Controller/arsip_controller.dart';
import 'package:kominfo/src/Model/arsip_model.dart';
import 'package:kominfo/src/View/pdf.dart';
import 'package:kominfo/src/View/tampil_file.dart';
import 'dart:core';

import 'package:kominfo/src/Widget/progress_dialog.dart';
import 'package:kominfo/src/Widget/shared_preferences.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:progress_dialog/progress_dialog.dart';

class ArsipIn extends StatefulWidget {
  const ArsipIn({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ArsipInState();
  }
}

class _ArsipInState extends State<ArsipIn> {
  List<File> files = [];

  Future pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if(image == null){
      return;
    }
    final file = File(image.path);
    setState(() {
      files.add(file);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDialOpen = ValueNotifier(false);
    File file;

    return WillPopScope(
        onWillPop: () async {
          if(isDialOpen.value){
            return isDialOpen.value = false;
          }
          return true;
        },
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      child: files.isEmpty ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Center(child: Icon(Icons.image),),
                          Center(child: Text("masukkan gambar")),
                        ],
                      ) :
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: files.length,
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Center(child: Image.file(files.elementAt(index)))
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: ElevatedButton(
                                  onPressed: (() => {
                                    setState((){
                                      files.removeAt(index);
                                    })
                                  }),
                                  child: const Icon(Icons.delete, color: Colors.red),
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    primary: Colors.white,
                                    onPrimary: Colors.red,
                                    fixedSize:  const Size(30, 30),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                ),
              ),
            ],
          ),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            backgroundColor: Colors.blueAccent,
            overlayColor: Colors.black,
            overlayOpacity: 0.4,
            openCloseDial: isDialOpen,
            children: [
              files.isEmpty ? SpeedDialChild() :
              SpeedDialChild(
                  child: const Icon(Icons.save),
                  label: "simpan",
                  backgroundColor: Colors.white,
                  labelBackgroundColor: Colors.white10,
                  onTap: () async {
                    file = await Pdf().createImagePDF(files);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MyDialog(file: file,);
                        }
                    ).then((cek) => {
                      files = [],
                    });
                  }
              ),
              SpeedDialChild(
                  child: const Icon(Icons.image),
                  label: "galeri",
                  backgroundColor: Colors.pinkAccent,
                  labelBackgroundColor: Colors.white10,
                  onTap: ()  {
                    pickImage(ImageSource.gallery);
                  }
              ),
              SpeedDialChild(
                  child: const Icon(Icons.camera),
                  label: "kamera",
                  backgroundColor: Colors.lightBlueAccent,
                  labelBackgroundColor: Colors.white10,
                  onTap: () {
                    pickImage(ImageSource.camera);
                  }
              ),
              SpeedDialChild(
                  child: const Icon(Icons.list),
                  label: "list file",
                  backgroundColor: Colors.lightBlueAccent,
                  labelBackgroundColor: Colors.white10,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TampilFile()),
                    );
                  }
              ),
            ],
          ),
        )
    );
  }
}

class MyDialog extends StatefulWidget {
  File file;
  MyDialog({Key? key, required this.file}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyDialogState();
  }
}

class _MyDialogState extends State<MyDialog> {
  String? tipe;
  File? file;
  bool isEnable = false;

  TextEditingController nama = TextEditingController();
  TextEditingController tipe2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    file = widget.file;
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog? pg = PG(context).setPg("menunggu...");

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextFormField(
                textInputAction: TextInputAction.go,
                controller: nama,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Nama File',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: DropdownButton<String>(
                hint: const Text("Pilih"),
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black, fontSize: 18),
                underline: Container(
                  height: 2,
                  color: Colors.black,
                ),
                onChanged: (String? value) {
                  setState(() {
                    tipe = value!;
                    value == "Lainnya" ? isEnable = true : isEnable = false;
                  });
                },
                value: tipe,
                items: <String>['Laporan', 'Kerja', 'Undangan', 'Lainnya']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            isEnable ?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: TextFormField(
                textInputAction: TextInputAction.go,
                controller: tipe2,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'tipe',
                ),
              ),
            ) : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: ElevatedButton(
                onPressed: () async {
                  await pg!.show();
                  String? id_pengguna = await SP().getSPref("id_pengguna");
                  bool cek = await ArsipController()
                      .uploadsArsip(
                      file!, ArsipModel.none()
                      .setId_pengguna(id_pengguna!)
                      .setNama(nama.text)
                      .setTipe(tipe! != 'Lainnya' ? tipe! : tipe2.text)
                  );
                  Navigator.pop(context, cek);
                  await pg.hide();

                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  primary: Colors.greenAccent,
                ),
                child: const Text("SIMPAN"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}