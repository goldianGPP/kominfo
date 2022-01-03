import 'package:kominfo/src/DAO/dao.dart';
import 'package:kominfo/src/Model/absen_model.dart';

class AbsenController {
  late AbsenModel absenModel;

  Future<String> createAbsen(String id_pengguna) async {
    return await DAO().createAbsen(id_pengguna);
  }

  Future<List<AbsenModel>> fetchAbsen(id, date) async {
    return await DAO().fetchAbsen(id, date);
  }

  Future<List<AbsenModel>> fetchAllAbsen() async {
    return await DAO().fetchAllAbsen();
  }
}