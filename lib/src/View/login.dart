import 'package:flutter/material.dart';
import 'package:kominfo/src/Controller/pengguna_controller.dart';
import 'package:kominfo/src/Model/pengguna_model.dart';
import 'package:kominfo/src/View/main.dart';
import 'package:kominfo/src/Widget/progress_dialog.dart';
import 'package:kominfo/src/Widget/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Login extends StatelessWidget {
  String nip;
  Login({Key? key, required this.nip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SP sp = SP();
    ProgressDialog? dialog = PG(context).setPg("memuat data...");
    TextEditingController nip = TextEditingController();
    nip.text = this.nip;
    PenggunaModel penggunaModel;
    CheckBox check = CheckBox(check: true,);

    Future<void> login(nip) async {
      await dialog!.show();
      sp.setPref("nama", "value");
      penggunaModel = await PenggunaController().fetchPengguna(nip);
      if(penggunaModel.nip.isNotEmpty){
        sp.setPref("nip", penggunaModel.nip);
        sp.setPref("id_pengguna", penggunaModel.id_pengguna);;
        sp.setPref("tandatangan", penggunaModel.tandatangan);
        if(check.check){
          sp.setPref("cek", penggunaModel.nip);
        }
        await dialog.hide();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Main()),
        );
      }
      await dialog.hide();
    }

    return Scaffold(
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
                  child: TextFormField(
                    textInputAction: TextInputAction.go,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'NIP',
                    ),
                    controller: nip,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
                  child: ElevatedButton(
                    onPressed: () {
                      login(nip.text);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                      primary: Colors.greenAccent,
                    ),
                    child: const Text("LOGIN"),
                  ),
                ),
                check,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CheckBox extends StatefulWidget {
  bool check = true;
  CheckBox({Key? key, required this.check}) : super(key: key);

  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool check = true;

  @override
  void initState() {
    super.initState();
    check = widget.check;
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 0),
        child: CheckboxListTile(
          title: const Text("ingat saya"),
          value: check,
          onChanged: (newValue) {
            setState(() {
              check = newValue!;
              widget.check = check;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
        )
    );
  }
}
