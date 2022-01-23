import 'dart:io';

import 'package:kominfo/src/DAO/dao.dart';
import 'package:kominfo/src/Model/absen_model.dart';
import 'package:kominfo/src/Model/pengguna_model.dart';

class PenggunaController {
  late PenggunaModel penggunaModel;

  Future<bool> upload(File file, String id_pengguna) async {
    return await DAO().uploadSignature(file, id_pengguna);
  }

  Future<PenggunaModel> fetchPengguna(String id_pengguna) async {
    return await DAO().fetchPengguna(id_pengguna);
  }
}