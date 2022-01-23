import 'package:flutter/material.dart';
import 'package:kominfo/src/Controller/arsip_controller.dart';
import 'package:kominfo/src/DAO/dao.dart';
import 'package:kominfo/src/Model/arsip_model.dart';
import 'package:kominfo/src/View/pdf_view.dart';
import 'package:kominfo/src/Widget/shared_preferences.dart';

class TampilFile extends StatefulWidget {
  const TampilFile({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TampilFileState();
  }
}

class _TampilFileState extends State<TampilFile> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar File"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder <List<ArsipModel>>(
        future: ArsipController().fetchFile(),
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
                ArsipModel arsips = snapshot.data!.elementAt(index);
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child:ListTile(
                      title: Text('nama : ${arsips.nama!}'),
                      subtitle: Text('tipe : ${arsips.tipe!}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TampilPdf(path: arsips.path!,)),
                        );
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
