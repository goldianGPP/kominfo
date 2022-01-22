import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kominfo/src/Model/absen_model.dart';
import 'package:kominfo/src/Model/arsip_model.dart';
import 'package:kominfo/src/Model/pengguna_model.dart';
import 'package:kominfo/src/View/toast.dart';
import 'package:path/path.dart';

class DAO{
  final String base_url = "http://192.168.107.41:8082/kp/arsipIn/";

  //Absen
  Future<List<AbsenModel>> fetchAbsen(id, date) async {
    final response = await http.get(
      Uri.parse('${base_url}api/absen/$id/$date'),
    );

    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      return List<AbsenModel>.from(list.map((model)=> AbsenModel.fromJson(model)));
    } else {
      Toasting().showToast('gagal mendapatkan histori absen');
      throw Exception('gagal mendapatkan histori absen');
    }
  }

  Future<List<AbsenModel>> fetchAllAbsen(month, year) async {
    final response = await http.get(
      Uri.parse('${base_url}api/absen/data/$year/$month'),
    );

    if (response.statusCode == 200) {
      var list = jsonDecode(response.body) as List;
      return List<AbsenModel>.from(list.map((model)=> AbsenModel.fromJson(model)));
    } else {
      Toasting().showToast('gagal mendapatkan data absen');
      throw Exception('gagal mendapatkan data absen');
    }
  }
  Future<List<AbsenModel>> fetchLibur() async {
    final response = await http.get(
      Uri.parse('${base_url}api/absen/libur'),
    );

    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      return List<AbsenModel>.from(list.map((model)=> AbsenModel.fromJson(model)));
    } else {
      Toasting().showToast('gagal mendapatkan libur');
      throw Exception('gagal mendapatkan libur');
    }
  }

  Future<String> createAbsen(String id_pengguna) async {
    final response = await http.post(
      Uri.parse('${base_url}api/absen/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id_pengguna': id_pengguna,
      }),
    );

    if (response.statusCode == 200) {
      Toasting().showToast('absen dimasukkan');
      return "absen dimasukkan";
    } else {
      Toasting().showToast('absen tidak dimasukkan');
      throw Exception('absen tidak dimasukkan');
    }
  }

  //Pengguna
  Future<PenggunaModel> fetchPengguna(String nip) async {
    final response = await http.get(
      Uri.parse('${base_url}api/pengguna/$nip'),
    );

    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      return PenggunaModel.fromJson(list);
    } else {
      Toasting().showToast('gagal mendapatkan profil');
      throw Exception('gagal mendapatkan profil');
    }
  }

  Future<void> uploadSignature(File imageFile, String id_pengguna) async {
    var stream  = http.ByteStream(imageFile.openRead()); stream.cast();
    var length = await imageFile.length();

    var uri = Uri.parse('${base_url}api/pengguna/image');

    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile(
      'image',
      stream,
      length,
      filename: basename(imageFile.path),

    );

    request.files.add(multipartFile);
    request.fields["id_pengguna"] = id_pengguna;
    var response = await request.send();

    if (response.statusCode == 200) {
      Toasting().showToast('tandatangan disimpan');
    } else {
      Toasting().showToast('tandatangan gagal disimpan');
    }
  }

  //Arsip
  Future<List<ArsipModel>> fetchFile() async {
    final response = await http.get(
      Uri.parse('${base_url}api/arsip'),
    );

    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      return List<ArsipModel>.from(list.map((model)=> ArsipModel.fromJson(model)));
    } else {
      Toasting().showToast('gagal mendapatkan file');
      throw Exception('gagal mendapatkan file');
    }
  }

  Future<bool> uploadsArsip(File pdfFile, ArsipModel arsip) async {
    var stream  = http.ByteStream(pdfFile.openRead()); stream.cast();
    var length = await pdfFile.length();

    var uri = Uri.parse('${base_url}api/arsip/');

    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile(
      'image',
      stream,
      length,
      filename: basename(pdfFile.path),

    );

    request.files.add(multipartFile);
    request.fields["id_pengguna"] = arsip.id_pengguna!;
    request.fields["nama"] = arsip.nama!;
    request.fields["tipe"] = arsip.tipe!;
    var response = await request.send();

    if (response.statusCode == 200) {
      Toasting().showToast('file disimpan');
      return true;
    } else {
      Toasting().showToast('file gagal disimpan');
      return false;
    }
  }
}