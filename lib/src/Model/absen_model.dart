class AbsenModel{
  final String id_absen;
  final String id_pengguna;
  final String nama;
  final String jabatan;
  final String tugas;
  final String tandatangan;
  final String nip;
  final String tgl_presensi;
  final String golongan;
  final String definisi;
  final String id_detail;
  final String tgl_libur;
  final String deskripsi;

  AbsenModel({
    required this.id_absen,
    required this.id_pengguna,
    required this.nama,
    required this.jabatan,
    required this.tugas,
    required this.tandatangan,
    required this.nip,
    required this.tgl_presensi,
    required this.golongan,
    required this.definisi,
    required this.id_detail,
    required this.tgl_libur,
    required this.deskripsi,
  });

  factory AbsenModel.fromJson(dynamic json) {
    return AbsenModel(
      id_absen: json['id_absen'],
      id_pengguna: json['id_pengguna'],
      nama: json['nama'],
      jabatan: json['jabatan'],
      tugas: json['tugas'],
      tandatangan: json['tandatangan'],
      nip: json['nip'],
      tgl_presensi: json['tgl_presensi'],
      golongan: json['golongan'],
      definisi: json['definisi'],
      id_detail: json['id_detail'],
      tgl_libur: json['tgl_libur'],
      deskripsi: json['deskripsi'],
    );
  }

  @override
  String toString() {
    return '{ '
        '${this.id_absen}, '
        '${this.id_pengguna}, '
        '${this.nama}, '
        '${this.jabatan}, '
        '${this.tugas}, '
        '${this.tandatangan}, '
        '${this.tgl_presensi} '
        '${this.golongan} '
        '${this.definisi} '
        '${this.id_detail} '
        '${this.tgl_libur} '
        '${this.deskripsi} '
        '}';
  }
}