import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:kominfo/src/View/pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class TampilAbsen extends StatefulWidget {
  final DateTime initialDate;
  const TampilAbsen({Key? key, required this.initialDate}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TampilAbsenState();
  }
}

class _TampilAbsenState extends State<TampilAbsen> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final isDialOpen = ValueNotifier(false);

    return  WillPopScope(
        onWillPop: () async {
          if(isDialOpen.value){
            return isDialOpen.value = false;
          }
          return true;
        },
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          theme: ThemeData(
              primarySwatch: Colors.indigo, accentColor: Colors.pinkAccent
          ),
          home: Scaffold(
            appBar: AppBar(
              title: const Text("tampil absen"),
              centerTitle: true,
              backgroundColor: Colors.blueAccent,
            ),
            body: Container(
              width: double.infinity,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // height: double.infinity,
                        width: double.infinity,
                        child: Text(
                          'Bulan: ${selectedDate?.month} Tahun: ${selectedDate?.year}',
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              backgroundColor: Colors.blueAccent,
              openCloseDial: isDialOpen,
              children: [
                SpeedDialChild(
                    child: const Icon(Icons.import_export),
                    label: "buka pdf",
                    backgroundColor: Colors.white10,
                    labelBackgroundColor: Colors.white10,
                    onTap: () async {
                      await Pdf().createAbsenPDF('${selectedDate?.year}-${selectedDate?.month}');
                    }
                ),
                SpeedDialChild(
                    child: const Icon(Icons.calendar_today),
                    label: "kalender",
                    backgroundColor: Colors.pinkAccent,
                    labelBackgroundColor: Colors.white10,
                    onTap: (){
                      showMonthPicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 1, 5),
                        lastDate: DateTime(DateTime.now().year + 1, 9),
                        initialDate: selectedDate ?? widget.initialDate,
                        locale: Locale("id"),
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      });
                    }
                ),
              ],
            ),
          ),
        ),
    );
  }
}
