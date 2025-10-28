// KELAS ABSTRAK: Transportasi
// Mewakili kelas induk. Mengandung Encapsulation (_tarifDasar) dan Polymorphism (hitungTarif).
abstract class Transportasi {
  final String id;
  final String nama;
  final double _tarifDasar; // ENCAPSULATION: Variabel private
  final int kapasitas;

  Transportasi(this.id, this.nama, this._tarifDasar, this.kapasitas);

  double get tarifDasar => _tarifDasar; // GETTER: Akses aman
  double hitungTarif(int jumlahPenumpang); // POLYMORPHISM: Method abstrak

  void tampilInfo() {
    print('ID:$id | $nama | Tarif: Rp${_tarifDasar.toStringAsFixed(0)}');
  }
}

// 1. KELAS TURUNAN: Taksi (Inheritance dari Transportasi)
class Taksi extends Transportasi {
  final double jarak;

  Taksi(String id, String nama, double tarifDasar, int kapasitas, this.jarak)
      : super(id, nama, tarifDasar, kapasitas);

  // POLYMORPHISM: Implementasi Taksi
  @override
  double hitungTarif(int jumlahPenumpang) => _tarifDasar * jarak; 
}

// 2. KELAS TURUNAN: Bus (Inheritance dari Transportasi)
class Bus extends Transportasi {
  final bool adaWifi;

  Bus(String id, String nama, double tarifDasar, int kapasitas, this.adaWifi)
      : super(id, nama, tarifDasar, kapasitas);

  // POLYMORPHISM: Implementasi Bus
  @override
  double hitungTarif(int jumlahPenumpang) {
    if (jumlahPenumpang > kapasitas) jumlahPenumpang = kapasitas; // Batas kapasitas
    return (_tarifDasar * jumlahPenumpang) + (adaWifi ? 5000.0 : 0.0);
  }
}

// 3. KELAS TURUNAN: Pesawat (Inheritance dari Transportasi)
class Pesawat extends Transportasi {
  final String kelas;

  Pesawat(String id, String nama, double tarifDasar, int kapasitas, this.kelas)
      : super(id, nama, tarifDasar, kapasitas);

  // POLYMORPHISM: Implementasi Pesawat
  @override
  double hitungTarif(int jumlahPenumpang) {
    final double faktorKelas = (kelas == "Bisnis") ? 1.5 : 1.0;
    return _tarifDasar * jumlahPenumpang * faktorKelas;
  }
}

// KELAS PEMESANAN
class Pemesanan {
  static int _counter = 100;
  final String idPemesanan;
  final String namaPelanggan;
  final Transportasi transportasi; // Relasi dengan objek Transportasi
  final int jumlahPenumpang;
  final double totalTarif;

  Pemesanan(this.namaPelanggan, this.transportasi, this.jumlahPenumpang)
      : idPemesanan = 'BOOK-${_counter++}',
        // Panggilan polimorfik: fungsi hitungTarif yang benar dipanggil
        totalTarif = transportasi.hitungTarif(jumlahPenumpang); 

  void cetakStruk() {
    print('\n[STRUK $idPemesanan] Pelanggan: $namaPelanggan, Total: Rp${totalTarif.toStringAsFixed(0)}');
  }

  Map<String, dynamic> toMap() { // FUNCTION: Simulasi database
    return {'id': idPemesanan, 'pelanggan': namaPelanggan, 'trans': transportasi.nama, 'tarif': totalTarif};
  }
}

// FUNGSI GLOBAL: buatPemesanan (Function)
Pemesanan buatPemesanan(Transportasi t, String nama, int jumlahPenumpang) {
  // Mengembalikan objek Pemesanan
  return Pemesanan(nama, t, jumlahPenumpang); 
}

// FUNGSI GLOBAL: tampilSemuaPemesanan (Function)
void tampilSemuaPemesanan(List<Pemesanan> daftar) {
  print('\n=== RIWAYAT PEMESANAN SEMUA ===');
  daftar.forEach((p) => print(p.toMap())); // Menampilkan Map data
  print('===============================');
}

// FUNGSI MAIN
void main() {
  // 1. Buat Objek Transportasi
  final taksi = Taksi('TX01', 'BlueBird', 4000.0, 4, 10.0);
  final bus = Bus('BS02', 'TransJ (WiFi)', 3500.0, 50, true);
  final pesawat = Pesawat('PS03', 'Garuda (Bisnis)', 750000.0, 300, 'Bisnis');
  
  // Tampilkan Info
  taksi.tampilInfo();
  bus.tampilInfo();
  pesawat.tampilInfo();

  // 2. Buat Pemesanan, Simpan ke List, dan Cetak Struk
  List<Pemesanan> riwayat = [];
  
  final p1 = buatPemesanan(taksi, 'Budi', 3);
  riwayat.add(p1);
  p1.cetakStruk();

  final p2 = buatPemesanan(bus, 'Ani', 5);
  riwayat.add(p2);
  p2.cetakStruk();

  final p3 = buatPemesanan(pesawat, 'Joko', 2);
  riwayat.add(p3);
  p3.cetakStruk();

  // 3. Tampilkan Semua Transaksi
  tampilSemuaPemesanan(riwayat);
}