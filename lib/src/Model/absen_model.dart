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
        '}';
  }
}