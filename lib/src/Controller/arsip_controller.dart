import 'dart:io';

import 'package:kominfo/src/DAO/dao.dart';
import 'package:kominfo/src/Model/arsip_model.dart';

class ArsipController {
  late ArsipModel absenModel;

  Future<void> uploadsArsip(File pdfFile, ArsipModel arsip) async {
    return await DAO().uploadsArsip(pdfFile, arsip);
  }
}