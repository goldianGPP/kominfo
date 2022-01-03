import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kominfo/src/Controller/arsip_controller.dart';
import 'package:kominfo/src/Model/arsip_model.dart';
import 'package:kominfo/src/View/pdf.dart';
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
    ProgressDialog? pg = PG(context).setPg("menunggu...");
    File file;

    return Scaffold(
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
                  child: Scaffold(
                    body: files.isEmpty ?
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
                                  setState(() async{
                                    await pg!.show();
                                    files.removeAt(index);
                                    await pg.hide();
                                  })
                                }),
                                child: const Icon(Icons.delete, color: Colors.red),
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
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
                    floatingActionButton:
                    files.isEmpty ? Container() :
                    FloatingActionButton(
                      onPressed: (() async => {
                        file = await Pdf().createImagePDF(files),

                        showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MyDialog(file: file,);
                        })
                      }),
                      child: const Icon(Icons.check),
                      mini: true,
                    ),
                  ),
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 2),
            child: ElevatedButton(
                onPressed: (){
                  pickImage(ImageSource.gallery);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                ),
                child: const Text("Galeri")
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 5),
            child: ElevatedButton(
                onPressed: (){
                  pickImage(ImageSource.camera);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                ),
                child: const Text("Kamera")
            ),
          ),
        ],
      ),
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

  @override
  void initState() {
    super.initState();
    file = widget.file;
  }

  @override
  Widget build(BuildContext context) {
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
                  String? id_pengguna = await SP().getSPref("id_pengguna");
                  ArsipController()
                      .uploadsArsip(
                      file!, ArsipModel.none()
                      .setId_pengguna(id_pengguna!)
                      .setNama(nama.text)
                      .setTipe(tipe!)
                  );
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