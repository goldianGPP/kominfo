import 'package:flutter/material.dart';
import 'package:kominfo/src/Controller/absen_controller.dart';
import 'package:kominfo/src/Controller/arsip_controller.dart';
import 'package:kominfo/src/DAO/dao.dart';
import 'package:kominfo/src/Model/absen_model.dart';
import 'package:kominfo/src/Model/arsip_model.dart';
import 'package:kominfo/src/View/pdf_view.dart';
import 'package:kominfo/src/Widget/shared_preferences.dart';

class TampilLibur extends StatefulWidget {
  const TampilLibur({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TampilLiburState();
  }
}

class _TampilLiburState extends State<TampilLibur> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Libur"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder <List<AbsenModel>>(
        future: AbsenController().fetchLibur(),
        builder: (context, snapshot){
          if(snapshot.connectionState != ConnectionState.done){
            return const Center(child:CircularProgressIndicator());
          }
          else if(snapshot.hasError){
            return const Center(child:Text("Mengalami Masalah Jaringan"));
          }
          return ListView.builder(
              itemCount: snapshot.data!.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                AbsenModel absen = snapshot.data!.elementAt(index);
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child:ListTile(
                      title: Text('tanggal : ${absen.tgl_libur}'),
                      subtitle: Text('deskripsi : ${absen.deskripsi}'),
                      onTap: () {
                      },
                    ),
                  ),
                );
              }
          );
        },
      ),
    );
  }
}
