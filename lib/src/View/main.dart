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
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("kominfo"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: const BottomNav(),

    );
  }
}
