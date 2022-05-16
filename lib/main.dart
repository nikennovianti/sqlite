import 'package:flutter/material.dart';
import 'mahasiswa.dart';
import 'dart:async';
import 'db_helper.dart';

void main() {
  runApp(const MaterialApp(
    title: "CRUD di SQLite",
    home: DBTestPage(title: '',),
  ));
}

class DBTestPage extends StatefulWidget {
  final String title;

  const DBTestPage({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DBTestPageState();
  }
}

class _DBTestPageState extends State<DBTestPage> {
  //
  late Future<List<Mahasiswa>> mahasiswa;
  TextEditingController contNama = TextEditingController();
  TextEditingController contNIM = TextEditingController();
  late String nama;
  late String nim;
  int? curUserId; //update dan delete

  final formKey = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  var dbHelper;
  late bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper(); //membuat objek dbhelper
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      //akan dipanggil saat rendering di UI
      mahasiswa = dbHelper.getMahasiswa();
    });
  }

  clearName() {
    contNama.text = '';
    contNIM.text = '';
  }

  validasiInputan() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (isUpdating) {
        Mahasiswa e = Mahasiswa(curUserId!, nama, nim);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Mahasiswa e = Mahasiswa(null, nama, nim);
        dbHelper.save(e);
      }
      clearName();
      refreshList();
    }
  }

  form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextFormField(
              controller: contNama,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Nama'),
              validator: (val) => val!.isEmpty ? 'Masukkan Nama' : null,
              onSaved: (val) => nama = val!,
            ),
            TextFormField(
              controller: contNIM,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Nim'),
              validator: (val) => val!.isEmpty ? 'Masukkan Nim' : null,
              onSaved: (val) => nim = val!,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: validasiInputan, //metod diatas
                  child: Text(isUpdating ? 'UPDATE' : 'TAMBAH'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
                  },
                  child: const Text('Batal'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView dataTable(List<Mahasiswa> mahasiswa) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        // ignore: prefer_const_literals_to_create_immutables
        columns: [
          const DataColumn(
            label: Text('NAMA'),
          ),
          const DataColumn(
            label: Text('NIM'),
          ),
          const DataColumn(
            label: Text('DELETE'),
          )
        ],
        rows: mahasiswa
            .map(
              (mahasiswa) => DataRow(cells: [
                DataCell(
                  Text(mahasiswa.nama),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      curUserId = mahasiswa.id;
                    });
                    contNama.text = mahasiswa.nama;
                  },
                ),
                DataCell(
                  Text(mahasiswa.nim),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      curUserId = mahasiswa.id;
                    });
                    contNIM.text = mahasiswa.nim;
                  },
                ),
                DataCell(IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    dbHelper.delete(mahasiswa.id);
                    refreshList();
                  },
                )),
              ]),
            )
            .toList(),
      ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: mahasiswa,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data as List<Mahasiswa>);
          }

          if (null == snapshot.data || (snapshot.data as List<Mahasiswa>).length == 0) {
            //optional
            return const Text("Data tidak ada");
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TABEL MAHASISWA'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          form(),
          list(),
        ],
      ),
    );
  }
}
