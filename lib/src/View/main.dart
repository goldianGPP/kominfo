import 'package:flutter/material.dart';
import 'package:kominfo/src/View/bottom_nav.dart';
import 'package:kominfo/src/View/login.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kominfo/src/Widget/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);

  String? nip = await SP().getSPref("cek");
  runApp(MaterialApp(
      home: Login(nip: nip!,)
  ));

}

class Main extends StatelessWidget {
  const Main({Key? key, required this.id_pengguna}) : super(key: key);
  final String? id_pengguna;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
        child: BottomNav(id_pengguna: id_pengguna,),
      ),
    );
  }
}
