
class Mahasiswa {
  int? id;
  late String nama;
  late String nim;

  // Mahasiswa(

  //   this._nama,
  //   this._nim
  // );

  Mahasiswa(
    this.id,
    this.nama,
    this.nim
  );

  // int? get id => _id;
  // String? get nama => _nama;
  // int? get nim => _nim;

  // set nama(String? value) {
  //   _nama = value;
  // }
  //  set nim(int? value) {
  //   _nim = value;
  // }

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