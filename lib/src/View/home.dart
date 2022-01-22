// ignore: import_of_legacy_library_into_null_safe
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:kominfo/src/Controller/absen_controller.dart';
import 'package:kominfo/src/Model/absen_model.dart';
import 'package:kominfo/src/View/pdf.dart';
import 'package:kominfo/src/View/tampil_file.dart';
import 'package:kominfo/src/View/tampil_libur.dart';
import 'package:kominfo/src/View/toast.dart';
import 'package:kominfo/src/Widget/progress_dialog.dart';
import 'package:kominfo/src/Widget/shared_preferences.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'dart:core';

// ignore: import_of_legacy_library_into_null_safe
import 'package:progress_dialog/progress_dialog.dart';


class Home extends StatefulWidget {
  final DateTime initialDate;
  const Home({Key? key, required this.initialDate}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  DateTime? selectedDate;
  FutureBuilder<List<AbsenModel>>? futureBuilder;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    futureBuilder = builder();
  }

  FutureBuilder<List<AbsenModel>> builder(){
    String date = selectedDate!.toString().substring(0,8);
    if(date == DateTime.now().toString().substring(0,8)){
      selectedDate = DateTime(selectedDate!.year,selectedDate!.month,DateTime.now().day);
    }
    else{
      selectedDate = DateTime(selectedDate!.year,selectedDate!.month,DateUtil().daysInMonth(selectedDate!.month, selectedDate!.year));
    }
    date = selectedDate.toString().substring(0,10);
    return FutureBuilder<List<AbsenModel>>(
      future: AbsenController().fetchAbsen('1',date),
      builder: (context, snapshot) {
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
            AbsenModel absens = snapshot.data!.elementAt(index);
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                child:ListTile(
                  title: Text(absens.tgl_presensi),
                  subtitle: RichText(
                    text: TextSpan(
                      text: 'Status : Absen ',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: absens.id_pengguna != null ? 'Telah' : 'Belum',
                          style: TextStyle(
                            color: absens.id_pengguna != null  ? Colors.greenAccent[700] : Colors.redAccent[700],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const TextSpan(
                          text: ' Terdaftarkan',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDialOpen = ValueNotifier(false);
    bool pressAttention = false;
    ProgressDialog? pr = PG(context).setPg("menunggu...");

    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status Kehadiran Hari Ini',
                    style:  TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child:ListTile(
                        title: Text(DateTime.now().toString().substring(0,10)),
                        subtitle: RichText(
                          text: TextSpan(
                            text: 'Status : ',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: pressAttention ? 'Sudah' : 'Belum',
                                style: TextStyle(
                                  color: pressAttention ? Colors.greenAccent : Colors.redAccent,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const TextSpan(
                                text: ' Absen',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:  const EdgeInsets.fromLTRB(5, 10, 5, 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const TampilLibur()),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: Column(
                                    children: const [
                                      Icon(
                                        Icons.list,
                                        color: Colors.blueAccent,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                        child: Text("daftar Libur"),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:  const EdgeInsets.fromLTRB(3, 10, 3, 10),
                            child: GestureDetector(
                              onTap: () async {
                                await pr!.show();
                                await Pdf().createAbsenPDF(selectedDate);
                                await pr.hide();
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding:  const EdgeInsets.fromLTRB(3, 5, 3, 5),
                                  child: Column(
                                    children: const [
                                      Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.redAccent,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                        child: Text("absen pdf"),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:  const EdgeInsets.fromLTRB(3, 10, 3, 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const TampilFile()),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding:  const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: Column(
                                    children: const [
                                      Icon(
                                        Icons.list,
                                        color: Colors.greenAccent,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                        child: Text("dafta file"),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Riwayat Kehadiran Bulan: ${selectedDate!.month} ${selectedDate!.year}',
                          style:  const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: ElevatedButton.icon(
                              icon: const Icon(Icons.calendar_today),
                              label: const Text('pilih bulan'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white10
                              ),
                              onPressed: () {
                                showMonthPicker(
                                  context: context,
                                  firstDate: DateTime(DateTime.now().year - 1, 5),
                                  lastDate: DateTime(DateTime.now().year + 1, 9),
                                  initialDate: selectedDate ?? widget.initialDate,
                                  locale: const Locale("id"),
                                ).then((date) {
                                  if (date != null) {
                                    setState(() {
                                      selectedDate = date;
                                      futureBuilder = builder();
                                    });
                                  }
                                });
                              },
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child:futureBuilder!,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await pr!.show();
            DateTime d = DateTime.now();
            if(Pdf().isWeekend(d.day, d)){
              Toasting().showToast('absensi dihentikan "weekend"');
            }
            else if(d.hour > 9){
              Toasting().showToast('anda terlambat absensi');
            }
            else{
              String? id_pengguna = await SP().getSPref("id_pengguna");
              await AbsenController().createAbsen(id_pengguna!);
            }
            await pr.hide();
          },
          child: const Icon(Icons.add),
        )
    );
  }
}