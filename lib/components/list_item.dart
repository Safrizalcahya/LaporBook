import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lapor_book_bk/components/styles.dart';
import 'package:lapor_book_bk/components/vars.dart';
import 'package:lapor_book_bk/models/akun.dart';
import 'package:lapor_book_bk/models/laporan.dart';

class ListItem extends StatefulWidget {
  final Laporan laporan;
  final Akun akun;
  final bool isLaporanku;
  const ListItem(
    {super.key,
    required this.laporan,
    required this.akun,
    required this.isLaporanku, 
    });

  @override
  State<ListItem> createState() => _ListItemState();
}
class _ListItemState extends State<ListItem> {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  int _jumlahLike = 0;

  @override
  void initState() {
    super.initState();
    _getLikeCount();
  }

  void _getLikeCount() async {
    try {
      QuerySnapshot likesSnapshot = await _db
          .collection('likes')
          .where('laporanId', isEqualTo: widget.laporan.docId)
          .get();

      setState(() {
        _jumlahLike = likesSnapshot.docs.length;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void delete() async {
    try {
      CollectionReference laporanCollection = _db.collection('laporan');

      if (widget.laporan.gambar != '') {
        await _storage.refFromURL(widget.laporan.gambar!).delete();
      }

      await laporanCollection.doc(widget.laporan.docId).delete();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/detail', arguments: {
            'akun': widget.akun,
            'laporan': widget.laporan,
          });
        },
        onLongPress: () {
          if (widget.isLaporanku)
            showDialog(
              context: context,
              builder: (BuildContext buildContext) {
                return AlertDialog(
                  title: Text('hapus ${widget.laporan.judul}?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(buildContext);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        delete();
                        Navigator.pop(buildContext);
                      },
                      child: Text('Hapus'),
                    ),
                  ],
                );
              },
            );
        },
        child: Column(
          children: [
            widget.laporan.gambar != ''
                ? Image.network(
                    widget.laporan.gambar!,
                    width: 130,
                    height: 130,
                  )
                : Image.asset(
                    'assets/istock-default.jpg',
                    width: 130,
                    height: 130,
                  ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(width: 2),
                ),
              ),
              child: Text(
                widget.laporan.judul,
                style: headerStyle(level: 4),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: widget.laporan.status == 'Posted'
                          ? warnaStatus[0]
                          : widget.laporan.status == 'Process'
                              ? warnaStatus[1]
                              : warnaStatus[2],
                      border: Border(
                        right: BorderSide(width: 2),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      widget.laporan.status,
                      style: headerStyle(level: 5, dark: false),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      // menambahkan jumlah like
                      "Jumlah Like: $_jumlahLike",
                      style: headerStyle(level: 5, dark: false),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
