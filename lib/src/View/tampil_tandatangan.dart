import 'package:flutter/material.dart';
import 'package:kominfo/src/DAO/dao.dart';
import 'package:kominfo/src/Widget/shared_preferences.dart';

class TampilTandatangan extends StatefulWidget {
  const TampilTandatangan({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TampilTandatanganState();
  }
}

class _TampilTandatanganState extends State<TampilTandatangan> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: SP().getSPref('tandatangan'),
          builder: (context, snapshot) {
            return Container(
              color: Colors.white,
              child: Image.network('${DAO().base_url}${snapshot.data}?v=${DateTime.now().millisecondsSinceEpoch}'),
            );
          },
      ),
    );
  }
}
