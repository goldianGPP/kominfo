class PenggunaModel{
  final String id_pengguna;
  final String nama;
  final String jabatan;
  final String username;
  final String password;
  final String tipe_presensi;
  final String tandatangan;
  final String tgl_masuk;
  final String tgl_berubah;
  final String nip;
  final String tugas;

  PenggunaModel({
    required this.id_pengguna,
    required this.nama,
    required this.jabatan,
    required this.username,
    required this.password,
    required this.tipe_presensi,
    required this.tandatangan,
    required this.tgl_masuk,
    required this.tgl_berubah,
    required this.tugas,
    required this.nip,
  });

  factory PenggunaModel.fromJson(Map<String, dynamic> json) {
    return PenggunaModel(
      id_pengguna: json['id_pengguna'],
      nama: json['nama'],
      jabatan: json['jabatan'],
      username: json['username'],
      password: json['password'],
      tipe_presensi: json['tipe_presensi'],
      tandatangan: json['tandatangan'],
      tgl_masuk: json['tgl_masuk'],
      tgl_berubah: json['tgl_berubah'],
      tugas: json['tugas'],
      nip: json['nip'],
    );
  }
}