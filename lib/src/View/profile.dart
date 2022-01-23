import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:kominfo/src/Controller/pengguna_controller.dart';
import 'package:kominfo/src/Model/pengguna_model.dart';
import 'package:kominfo/src/View/tampil_tandatangan.dart';
import 'package:kominfo/src/View/tandatangan.dart';
import 'package:kominfo/src/Widget/shared_preferences.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key, required this.id_pengguna}) : super(key: key);
  final String? id_pengguna;

  @override
  Widget build(BuildContext context) {
    final isDialOpen = ValueNotifier(false);

    return WillPopScope(
        onWillPop: () async {
          if(isDialOpen.value){
            return isDialOpen.value = false;
          }
          return true;
        },
        child: Scaffold(
            body: SingleChildScrollView(
              child: Stack(
                children: <Widget> [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(100, 50, 100, 50),
                        child: Image(
                          image: AssetImage("assets/logo.png"),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: PenggunaProfile(id_pengguna: id_pengguna,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              backgroundColor: Colors.blueAccent,
              overlayColor: Colors.black,
              overlayOpacity: 0.4,
              openCloseDial: isDialOpen,
              children: [
                SpeedDialChild(
                    child: const Icon(Icons.add),
                    label: "masukkan tanda tangan",
                    backgroundColor: Colors.white,
                    labelBackgroundColor: Colors.white10,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Tandatangan()),
                      );
                    }
                ),
                SpeedDialChild(
                    child: const Icon(Icons.remove_red_eye),
                    label: "tampil tanda tangan",
                    backgroundColor: Colors.white,
                    labelBackgroundColor: Colors.white10,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TampilTandatangan()),
                      );
                    }
                ),
              ],
            ),
        )
    );
  }
}

class PenggunaProfile extends StatefulWidget {
  const PenggunaProfile({Key? key, required this.id_pengguna}) : super(key: key);
  final String? id_pengguna;

  @override
  _PenggunaProfileState createState() => _PenggunaProfileState();
}

class _PenggunaProfileState extends State<PenggunaProfile> {
  String? id_pengguna;

  @override
  void initState() {
    super.initState();
    id_pengguna = widget.id_pengguna;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PenggunaModel>(
        future: PenggunaController().fetchPengguna(id_pengguna!),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: const Text("NAMA"),
                  subtitle: Text(snapshot.data!.nama),
                ),
                ListTile(
                  title: const Text("JABATAN"),
                  subtitle: Text(snapshot.data!.jabatan),
                ),
                ListTile(
                  title: const Text("NIP"),
                  subtitle: Text(snapshot.data!.nip),
                ),
                ListTile(
                  title: const Text("TUGAS"),
                  subtitle: Text(snapshot.data!.tugas),
                ),
              ],
            );
          }
          return const Center(child:CircularProgressIndicator());
        }
    );
  }
}
