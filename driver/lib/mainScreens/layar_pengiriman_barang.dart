import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/assistantMethods/dapatkan_lokasi_sekarang.dart';
import 'package:driver/global/global.dart';
import 'package:driver/mainScreens/layar_pembayaran_ke_pedagang.dart';
import 'package:driver/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:slider_button/slider_button.dart';

import '../maps/maps_utils.dart';
import 'home_screen.dart';

class LayarPengirimanBarang extends StatefulWidget {
  String? belanjaanId;
  String? belanjaanAlamat;
  double? belanjaanLat;
  double? belanjaanLng;
  String? penjualId;
  String? getPesananId;
  double? totalBelanjaan;

  LayarPengirimanBarang(
      {this.belanjaanAlamat,
      this.belanjaanId,
      this.belanjaanLat,
      this.belanjaanLng,
      this.penjualId,
      this.getPesananId,
      this.totalBelanjaan});

  @override
  State<LayarPengirimanBarang> createState() => _LayarPengirimanBarangState();
}

class _LayarPengirimanBarangState extends State<LayarPengirimanBarang> {
  String pesananJumlahTotal = "";

  getTotalJumlahPesanan() {
    FirebaseFirestore.instance
        .collection("pesanan")
        .doc(widget.getPesananId)
        .get()
        .then((snap) {
      setState(() {
        pesananJumlahTotal = snap.data()!["jumlahTotal"].toString();
      });

      widget.penjualId = snap.data()!["penjualUID"].toString();
    }).then((value) {
      getPenjualData();
    });
  }

  getPenjualData() {
    FirebaseFirestore.instance
        .collection("penjual")
        .doc(widget.penjualId)
        .get()
        .then((snap) {
      pendapatanSebelumnya = snap.data()!["earnings"].toString();
    });
  }

  konfirmasiBarangSudahDikirim(getPesananId, penjualId, belanjaanId,
      belanjaanAlamat, belanjaanLat, belanjaanLng) {
    String driverTotalJumlahPendapatan =
        ((double.parse(pendapatanDriverSebelumnya)) +
                ((double.parse(perPengirimanBarang)) *
                    ((double.parse(jarakKirim)))))
            .toString();

    FirebaseFirestore.instance.collection("pesanan").doc(getPesananId).update({
      "status": "pembayaran",
      "alamat": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
      "earnings": perPengirimanBarang,
    }).then((value) {
      FirebaseFirestore.instance
          .collection("driver")
          .doc(sharedPreferences!.getString("uid"))
          .update({
        "earnings": driverTotalJumlahPendapatan,
      }).then((value) {
        FirebaseFirestore.instance
            .collection("penjual")
            .doc(widget.penjualId)
            .update({
          "earnings": (double.parse(pesananJumlahTotal) +
                  (double.parse(pendapatanSebelumnya)))
              .toString(),
        }).then((value) {
          FirebaseFirestore.instance
              .collection("pembeli")
              .doc(belanjaanId)
              .collection("pesanan")
              .doc(getPesananId)
              .update({
            "status": "pembayaran",
            "driverUID": sharedPreferences!.getString("uid"),
          });
        });
      });
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LayarPembayaranPedagang(
                  getPesananId: getPesananId,
                  belanjaanId: belanjaanId,
                )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PembeliLokasi pLokasi = PembeliLokasi();
    pLokasi.getCurrentLocation();
    getTotalJumlahPesanan();
  }

  @override
  Widget build(BuildContext context) {
    double ongkir = 0;
    double jarak;

    setState(() {
      jarak = (Geolocator.distanceBetween(
                  position!.latitude,
                  position!.longitude,
                  widget.belanjaanLat!,
                  widget.belanjaanLng!) *
              2) /
          1000;

      jarakKirim = jarak.round().toString();

      ongkir =
          ((double.parse(perPengirimanBarang)) * ((double.parse(jarakKirim))));
      // printOngkir = ongkir.toString();
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            "Pengiriman Barang",
            style: TextStyle(),
          ),
        ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/confirm2.png",
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                MapUtils.BukaMapKeLokasi(
                    position!.latitude,
                    position!.longitude,
                    widget.belanjaanLat,
                    widget.belanjaanLng);

                // jarak = (Geolocator.distanceBetween(
                //             position!.latitude,
                //             position!.longitude,
                //             widget.belanjaanLat!,
                //             widget.belanjaanLng!) *
                //         2) /
                //     1000;

                // jarakKirim = jarak.round().toString();
                print(
                    "JARAK ONGKIR ADALAH AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA $jarakKirim");
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const SizedBox(
                  //   width: 7,
                  // ),
                  Column(
                    children: [
                      Text(
                        "\nTotal Belanjaan : " + pesananJumlahTotal.toString(),
                        style: TextStyle(
                          fontFamily: "Signatra",
                          fontSize: 30,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.greenAccent, // background
                                onPrimary: Colors.white, // foreground
                              ),
                              onPressed: () {
                                MapUtils.BukaMapKeLokasi(
                                    position!.latitude,
                                    position!.longitude,
                                    widget.belanjaanLat,
                                    widget.belanjaanLng);
                              },
                              child: Text('Tunjukan Lokasi Pengiriman'),
                            )
                            // Image.asset(
                            //   'images/restaurant.png',
                            //   width: 50,
                            // ),
                            // const Text(
                            //   "Tunjukan Lokasi Pengiriman Pesanan",
                            //   style: TextStyle(
                            //     fontFamily: "Signatra",
                            //     fontSize: 18,
                            //     letterSpacing: 2,
                            //   ),
                            // ),
                          ]),
                      const SizedBox(
                        width: 7,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
                child: SliderButton(
              action: () {
                ///Do something here
                PembeliLokasi pLokasi = PembeliLokasi();
                pLokasi.getCurrentLocation();

                konfirmasiBarangSudahDikirim(
                    widget.getPesananId,
                    widget.penjualId,
                    widget.belanjaanId,
                    widget.belanjaanAlamat,
                    widget.belanjaanLat,
                    widget.belanjaanLng);

                // konfirmasiBarangSudahDiambil(
                //     widget.getPesananID,
                //     widget.penjualId,
                //     widget.belanjaanId,
                //     widget.belanjaanAlamat,
                //     widget.belanjaanLat,
                //     widget.belanjaanLng,
                //     widget.dipesanOlehPembeli,
                //     widget.pesananId);
              },
              label: Text(
                "Pesanan sudah dikirim",
                style: TextStyle(
                    color: Color(0xff4a4a4a),
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              icon: Text(
                ">",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 30,
                ),
              ),
            )),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Center(
                  child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: Text('Home'),
              )
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => HomeScreen()));
                  //   },
                  //   child: Container(
                  //     decoration: const BoxDecoration(
                  //         gradient: LinearGradient(
                  //       colors: [
                  //         Colors.cyan,
                  //         Colors.amber,
                  //       ],
                  //       begin: FractionalOffset(0.0, 0.0),
                  //       end: FractionalOffset(1.0, 0.0),
                  //       stops: [0.0, 1.0],
                  //       tileMode: TileMode.clamp,
                  //     )),
                  //     width: MediaQuery.of(context).size.width - 250,
                  //     height: 50,
                  //     child: const Center(
                  //       child: Text(
                  //         "Home",
                  //         style: TextStyle(color: Colors.white, fontSize: 15.0),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  ),
            ),
          ]),
    );
  }
}
