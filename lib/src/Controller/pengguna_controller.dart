import 'dart:io';

import 'package:kominfo/src/DAO/dao.dart';
import 'package:kominfo/src/Model/absen_model.dart';
import 'package:kominfo/src/Model/pengguna_model.dart';

class PenggunaController {
  late PenggunaModel penggunaModel;

  Future<void> upload(File file, String id_pengguna) async {
    await DAO().uploadSignature(file, id_pengguna);
  }

  Future<PenggunaModel> fetchPengguna(String nip) async {
    return await DAO().fetchPengguna(nip);
  }
}