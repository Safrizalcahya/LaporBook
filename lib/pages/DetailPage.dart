import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lapor_book_bk/components/status_dialog.dart';
import 'package:lapor_book_bk/components/styles.dart';
import 'package:lapor_book_bk/components/vars.dart';
import 'package:lapor_book_bk/models/akun.dart';
import 'package:lapor_book_bk/models/laporan.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
bool _isliked = false;
int _likeCount = 0;

Future launch(String url) async{
  if(url=='') return;
  if(await launchUrl(Uri.parse(url))){
    throw Exception('Tidak dapat memanggil $url');
  }
}

  @override
  Widget build(BuildContext context) {
    final arguments = 
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Akun akun = arguments['akun'];
    final Laporan laporan =arguments['laporan'];

    return Scaffold(
      appBar: AppBar(
      backgroundColor: primaryColor,
      title: Text(
        'Detail Laporan',
      style: headerStyle(level: 3, dark: false)
      ),
      centerTitle: true,
      ), 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(30),
            child: Column(
              children: [
                Text(
                  laporan.judul, 
                style: headerStyle(level: 2),
                ),
                SizedBox(
                  height: 15,
                ),
                laporan.gambar != '' 
                  ?Image.network(
                    laporan.gambar!,
                  )
                  :Image.asset(
                    'assets/istock-default.jpg',
                  ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textStatus(laporan.status,  laporan.status == 'Posted'
                      ? warnaStatus[0]
                      : laporan.status == 'Process' 
                      ? warnaStatus[1]
                      : warnaStatus[2],
                       Colors.white), 
                    textStatus(laporan.instansi, Colors.white, Colors.black),
                    ],
                ),
                //penambahan button like
                ElevatedButton(
                    onPressed: () async {
                      try {
                        // Tambahkan fungsi untuk menangani tombol Like di sini
                        // Kirim data user dan timestamp ke server

                        // Simulasi penanganan tombol Like
                        if (!_isliked) {
                          // Update jumlah like
                          setState(() {
                            _likeCount++;
                          });

                          // Set state tombol Like agar tidak bisa diklik lagi
                          setState(() {
                            _isliked = true;
                          });

                          // Tambahkan logika penyimpanan data like ke Firestore
                          // ...

                        } else {
                          // Tombol Like sudah diklik sebelumnya
                          // Mungkin berikan pesan atau lakukan tindakan lain
                          print("Anda sudah memberi like pada laporan ini.");
                        }

                      } catch (e) {
                        print("Error: $e");
                      }
                    },
                    child: Text(_isliked ? "Liked" : "Like"),
                  ),

                SizedBox(
                  height: 15,
                ),

                ListTile(
                  title: Text('Jumlah Like'),
                  subtitle: Text("$_likeCount"),
                  leading: Icon(Icons.favorite),
                ),

                SizedBox(
                  height: 15,
                ),
                ListTile(
                  title: Text('Nama Pelapor'),
                  subtitle: Text(laporan.nama),
                  leading: Icon(Icons.person),
                ),
                ListTile(
                  title: Text('Tanggal'),
                  subtitle:  Text(
                    DateFormat('dd MMMM yyyy').format(laporan.tanggal),
                  ),
                  leading: Icon(Icons.date_range),
                  trailing: IconButton(
                    onPressed: (){
                      launch(laporan.maps);
                    },
                    icon: Icon(Icons.location_on),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                  'Deskripsi', 
                  style: headerStyle(level: 2),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                    Text(laporan.deskripsi ?? ''),
                    SizedBox(
                      height: 50,
                    ),
                    if(akun.role == 'admin')
                    Container(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: (){
                          showDialog(
                          context: context, 
                          builder: (BuildContext context){
                            return StatusDialog(
                              laporan: laporan,
                            );
                          });
                        },
                      style: 
                        TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))), 
                        child: Text('Ubah status')),
                    ),
                    SizedBox(
                    height: 15,
                  ),
                    SizedBox(
                      height: 50,
                    ),
                    if(akun.role == 'admin')
                    Container(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: (){
                          showDialog(
                          context: context, 
                          builder: (BuildContext context){
                            return StatusDialog(
                              laporan: laporan,
                            );
                          });
                        },
                      style: 
                        TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))), 
                        child: Text('Tambah Komentar')),
                    ),
                    SizedBox(
                     height: 15,
                    ),
                    ListTile(
                    title: Text('List Komentar'),
                  ),
                  SizedBox(
                      height: 150,
                    ),
                    if(akun.role == 'admin')
                    Container(
                      width: 350,
                      child: ElevatedButton(
                        onPressed: (){
                          showDialog(
                          context: context, 
                          builder: (BuildContext context){
                            return StatusDialog(
                              laporan: laporan,
                            );
                          });
                        },
                      style: 
                        TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))), 
                        child: Text('Nama komentator')),
                    ),
                  ],
                ),
              ),
           ),
        ),
    );
  }

  Container textStatus(String text, var bgColo, var fgColor) {
    return Container(
                    alignment: Alignment.center,
                    width: 150,
                    decoration: BoxDecoration(
                      color: primaryColor,
                        border: Border.all(width: 1, color: primaryColor), 
                    borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      text, 
                    style: TextStyle(color: fgColor),
                    ),
                  );
  }
}

class _likeCount {
}