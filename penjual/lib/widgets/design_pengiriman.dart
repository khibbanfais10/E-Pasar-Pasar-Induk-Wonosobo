import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:penjual/global/global.dart';
import 'package:penjual/mainScreens/home_screen.dart';
import 'package:penjual/model/alamat.dart';
import 'package:penjual/splashScreen/splash_screen.dart';
import 'package:penjual/widgets/progress_bar.dart';

class DesignPengiriman extends StatelessWidget {
  final Alamat? model;
  final String? statusPesanan;
  final String? pesananId;
  final String? penjualId;
  final String? dipesanOlehPembeli;
  String? namaDriver;
  String? telepon;

  DesignPengiriman(
      {this.model,
      this.statusPesanan,
      this.pesananId,
      this.dipesanOlehPembeli,
      this.penjualId,
      this.namaDriver,
      this.telepon});

  @override
  Widget build(BuildContext context) {
    String status = "";
    String? namaDrivers;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Detail Pengiriman : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 6.0,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(children: [
                Text(
                  "Nama ",
                  style: TextStyle(color: Colors.black),
                ),
                Text(model!.nama!),
              ]),
              TableRow(children: [
                Text(
                  "Nomor Telepon ",
                  style: TextStyle(color: Colors.black),
                ),
                Text(model!.nomorTelepon!),
              ]),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            model!.alamatSatu! + model!.alamatDua!,
            textAlign: TextAlign.justify,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Detail Driver : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 6.0,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(children: [
                Text(
                  "Nama ",
                  style: TextStyle(color: Colors.black),
                ),
                Text(namaDriver.toString()),
              ]),
              TableRow(children: [
                Text(
                  "Nomor Telepon ",
                  style: TextStyle(color: Colors.black),
                ),
                Text(telepon.toString()),
              ]),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                if (statusPesanan == "dipesan") {
                  FirebaseFirestore.instance
                      .collection("pesanan")
                      .doc(pesananId!)
                      .update({
                    "status": "packing",
                  }).then((value) {
                    FirebaseFirestore.instance
                        .collection("pembeli")
                        .doc(dipesanOlehPembeli)
                        .collection("pesanan")
                        .doc(pesananId!)
                        .update({
                      "status": "packing",
                    });
                  });
                  Fluttertoast.showToast(msg: "Pesanan Diterima");
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => HomeScreen()));
                } else {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => HomeScreen()));
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Colors.cyan,
                    Colors.amber,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                )),
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: Center(
                  child: Text(
                    statusPesanan == "dipesan" ? "Terima Pesanan" : "Kembali",
                    style: const TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                if (statusPesanan == "dipesan") {
                  FirebaseFirestore.instance
                      .collection("pesanan")
                      .doc(pesananId!)
                      .update({
                    "status": "ditolak",
                  }).then((value) {
                    FirebaseFirestore.instance
                        .collection("pembeli")
                        .doc(dipesanOlehPembeli)
                        .collection("pesanan")
                        .doc(pesananId!)
                        .update({
                      "status": "ditolak",
                    });
                  });
                  Fluttertoast.showToast(msg: "Pesanan Ditolak");
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => HomeScreen()));
                } else {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => HomeScreen()));
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Colors.cyan,
                    Colors.amber,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                )),
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: Center(
                  child: Text(
                    statusPesanan == "ditolak"
                        ? "Pesanan Ditolak"
                        : statusPesanan == "dipesan"
                            ? "Tolak Pesanan"
                            : "Pesanan Diterima",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
