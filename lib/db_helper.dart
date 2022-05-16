import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'mahasiswa.dart';


class DBHelper {
  static Database? _db;
  static const ID = 'id';
  static const NAME = 'nama';
  static const NIM = 'nim';
  static const TABLE = 'mahasiswa';
  static const DB_NAME = 'mahasiswa.db';

  //mengecek keberadaan database
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  //membuat databasenya
  initDB() async {
    io.Directory documensDirectory = await getApplicationDocumentsDirectory();
    String path = join(documensDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

   //membuat tabel
  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT, $NIM TEXT)");
  }

  //insert data ke tabel
  Future<Mahasiswa> save(Mahasiswa mahasiswa) async {
    var dbClient = await db;
    //alternatif 1NAME
    mahasiswa.id = await dbClient!.insert(TABLE, mahasiswa.toMap());
    return mahasiswa;
  }

  //select data
  // Future<List<Map<String, dynamic>>> getMahasiswa() async {
  //   // Database db = await this.database;
  //   var dbClient = await db;

  //   // var result = await db.rawQuery('SELECT * FROM $tabelMahasiswa');
  //   var result = await dbClient!.query(TABLE, columns: [ID, NAME, NIM]);
  //   return result;
  // }
  Future<List<Mahasiswa>> getMahasiswa() async {
    var dbClient = await db;
    //alternatif 1
    List<Map> maps = await dbClient!.query(TABLE, columns: [ID, NAME, NIM]);

    //alternatif 2
    // List<Map> maps = await dbClient!.rawQuery("SELECT * FROM $TABLE");

    List<Mahasiswa> mahasiswa = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        mahasiswa.add(Mahasiswa.fromMap(maps[i] as dynamic));
      }
    }
    return mahasiswa;
  }

  //melakukan delete
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  //melakukan update
  Future<int> update(Mahasiswa mahasiswa) async {
    var dbClient = await db;
    return await dbClient!
        .update(TABLE, mahasiswa.toMap(), where: '$ID = ?', whereArgs: [mahasiswa.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }
}