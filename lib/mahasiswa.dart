
class Mahasiswa {
  int? id;
  late String nama;
  late String nim;

  Mahasiswa(
    this.id,
    this.nama,
    this.nim
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
    'id' : id,
    'nama' : nama,
    'nim' : nim,
    };
    return map;
  } 

  Mahasiswa.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nama = map['nama'];
    nim = map['nim'];
  }

  // static Mahasiswa fromMap(Map map) {} 
} 
