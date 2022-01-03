
class ArsipModel{
  String? id_file, id_pengguna, nama, path, tgl_masuk, tgl_ubah, tipe;



  ArsipModel.none();

  ArsipModel({
    required this.id_file,
    required this.id_pengguna,
    required this.nama,
    required this.path,
    required this.tgl_masuk,
    required this.tgl_ubah,
    required this.tipe
  });

  ArsipModel setId_file(String id_file){
    this.id_file = id_file;
    return this;
  }

  ArsipModel setId_pengguna(String id_pengguna){
    this.id_pengguna = id_pengguna;
    return this;
  }

  ArsipModel setNama(String nama){
    this.nama = nama;
    return this;
  }

  ArsipModel setPath(String path){
    this.path = path;
    return this;
  }

  ArsipModel setTgl_masuk (String tgl_masuk){
    this.tgl_masuk = tgl_masuk;
    return this;
  }

  ArsipModel setTgl_ubah (String tgl_ubah){
    this.tgl_ubah = tgl_ubah;
    return this;
  }

  ArsipModel setTipe (String tipe){
    this.tipe = tipe;
    return this;
  }

  factory ArsipModel.fromJson(Map<String, dynamic> json) {
    return ArsipModel(
      id_file: json['id_file'],
      id_pengguna: json['id_pengguna'],
      nama: json['nama'],
      path: json['path'],
      tgl_masuk: json['tgl_masuk'],
      tgl_ubah: json['tgl_ubah'],
      tipe: json['tipe'],
    );
  }
}