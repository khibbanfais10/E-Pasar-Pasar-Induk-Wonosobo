import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/assistantMethods/dapatkan_lokasi_sekarang.dart';
import 'package:driver/global/global.dart';
import 'package:driver/mainScreens/layar_pengambilan_barang.dart';
import 'package:driver/model/alamat.dart';
import 'package:driver/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';

class DesignPengiriman extends StatefulWidget {
  final Alamat? model;
  final String? statusPesanan;
  final String? pesananId;
  final String? penjualId;
  final String? dipesanOlehPembeli;
  double? totalBelanjaan;
  String? nomorTelepon;

  DesignPengiriman(
      {this.model,
      this.statusPesanan,
      this.pesananId,
      this.dipesanOlehPembeli,
      this.penjualId,
      this.totalBelanjaan,
      this.nomorTelepon});

  @override
  State<DesignPengiriman> createState() => _DesignPengirimanState();
}

class _DesignPengirimanState extends State<DesignPengiriman> {
  konfirmasiPengirimanbarang(BuildContext context, String getPesananID,
      String penjualId, String belanjaanId) {
    FirebaseFirestore.instance.collection("pesanan").doc(getPesananID).update({
      "driverUID": sharedPreferences!.getString("uid"),
      "driverName": sharedPreferences!.getString("name"),
      "status": "pengambilan",
      "lat": position!.latitude,
      "lng": position!.longitude,
      "address": completeAddress,
      "teleponDriver": widget.nomorTelepon,
    }).then((value) {
      FirebaseFirestore.instance
          .collection("pembeli")
          .doc(widget.dipesanOlehPembeli)
          .collection("pesanan")
          .doc(widget.pesananId)
          .update({"status": "pengambilan"});
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => LayarPengambilanBarang(
                  belanjaanId: belanjaanId,
                  belanjaanAlamat: widget.model!.alamatLengkap,
                  belanjaanLat: widget.model!.lat,
                  belanjaanLng: widget.model!.lng,
                  penjualId: penjualId,
                  getPesananID: getPesananID,
                  dipesanOlehPembeli: widget.dipesanOlehPembeli,
                  pesananId: widget.pesananId,
                )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                Text(widget.model!.nama!),
              ]),
              TableRow(children: [
                Text(
                  "Nomor Telepon ",
                  style: TextStyle(color: Colors.black),
                ),
                Text(widget.model!.nomorTelepon!),
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
            widget.model!.alamatSatu! + widget.model!.alamatDua!,
            textAlign: TextAlign.justify,
          ),
        ),
        widget.statusPesanan == "selesai"
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      PembeliLokasi pLokasi = PembeliLokasi();
                      pLokasi.getCurrentLocation();

                      konfirmasiPengirimanbarang(context, widget.pesananId!,
                          widget.penjualId!, widget.dipesanOlehPembeli!);
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
                      child: const Center(
                        child: Text(
                          "Konfirmasi Pengiriman Barang",
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => MySplashScreen()));
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
                child: const Center(
                  child: Text(
                    "Kembali",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
