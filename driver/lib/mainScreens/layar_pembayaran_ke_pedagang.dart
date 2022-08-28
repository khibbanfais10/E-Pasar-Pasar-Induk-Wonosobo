import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/assistantMethods/dapatkan_lokasi_sekarang.dart';
import 'package:driver/global/global.dart';
import 'package:driver/mainScreens/home_screen.dart';
import 'package:driver/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:slider_button/slider_button.dart';

import '../maps/maps_utils.dart';

class LayarPembayaranPedagang extends StatefulWidget {
  String? belanjaanId;
  String? belanjaanAlamat;
  double? belanjaanLat;
  double? belanjaanLng;
  String? penjualId;
  String? getPesananId;
  String? jumlahBelanjaan;

  LayarPembayaranPedagang({
    this.belanjaanAlamat,
    this.belanjaanId,
    this.belanjaanLat,
    this.belanjaanLng,
    this.penjualId,
    this.getPesananId,
  });

  @override
  State<LayarPembayaranPedagang> createState() =>
      _LayarPembayaranPedagangState();
}

class _LayarPembayaranPedagangState extends State<LayarPembayaranPedagang> {
  String pesananJumlahTotal = "";

  getPenjualData() async {
    FirebaseFirestore.instance
        .collection("penjual")
        .doc(widget.penjualId)
        .get()
        .then((DocumentSnapshot) {
      setState(() {
        penjualNama = DocumentSnapshot.data()!['penjualName'];
        blokKios = DocumentSnapshot.data()!['blok'];
      });
    });
  }
  // getJumlahTotal() async {
  //   FirebaseFirestore.instance
  //       .collection("pesanan")
  //       .doc(widget.getPesananId)
  //       .get()
  //       .then((value) {
  //     widget.jumlahBelanjaan = value.data()!['totalBelanjaan'].toString();
  //   });
  // }

  // getTotalJumlahPesanan() {
  //   FirebaseFirestore.instance
  //       .collection("pesanan")
  //       .doc(widget.getPesananId)
  //       .get()
  //       .then((snap) {
  //     pesananJumlahTotal = snap.data()!["jumlahTotal"].toString();
  //     widget.penjualId = snap.data()!["penjualUID"].toString();
  //   }).then((value) {
  //     getPenjualData();
  //   });
  // }

  // getPenjualData() {
  //   FirebaseFirestore.instance
  //       .collection("penjual")
  //       .doc(widget.penjualId)
  //       .get()
  //       .then((snap) {
  //     pendapatanSebelumnya = snap.data()!["earnings"].toString();
  //   });
  // }

  // konfirmasiBarangSudahDikirim(getPesananId, penjualId, belanjaanId,
  //     belanjaanAlamat, belanjaanLat, belanjaanLng) {
  //   String driverTotalJumlahPendapatan =
  //       ((double.parse(pendapatanDriverSebelumnya)) +
  //               ((double.parse(perPengirimanBarang)) *
  //                   ((double.parse(jarakKirim)))))
  //           .toString();

  //   FirebaseFirestore.instance.collection("pesanan").doc(getPesananId).update({
  //     "status": "selesai",
  //   }).then((value) {
  //     FirebaseFirestore.instance
  //         .collection("pembeli")
  //         .doc(belanjaanId)
  //         .collection("pesanan")
  //         .doc(getPesananId)
  //         .update({
  //       "status": "selesai",
  //     });
  //   });
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // PembeliLokasi pLokasi = PembeliLokasi();
    // pLokasi.getCurrentLocation();
    // getTotalJumlahPesanan();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection("pesanan")
        .doc(widget.getPesananId)
        .get()
        .then((value) {
      setState(() {
        jumlahBelanjaan = value.data()!['totalBelanjaan'].toString();
      });
    });

    // double ongkir = ;
    // double jarak;

    // setState(() {
    //   jarak = (Geolocator.distanceBetween(
    //               position!.latitude,
    //               position!.longitude,
    //               widget.belanjaanLat!,
    //               widget.belanjaanLng!) *
    //           2) /
    //       1000;

    //   jarakKirim = jarak.round().toString();

    //   ongkir =
    //       ((double.parse(perPengirimanBarang)) * ((double.parse(jarakKirim))));
    //   // printOngkir = ongkir.toString();
    // });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            "Pembayaran ke pedagang",
            style: TextStyle(),
          ),
        ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/uangpedagang.png",
              height: 250,
              width: 250,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 7,
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 13,
                      ),
                      Text(
                        "Nama Penjual : " + penjualNama.toString(),
                        style: const TextStyle(
                          fontFamily: "Signatra",
                          fontSize: 18,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(
                        "Blok Kios : " + blokKios.toString(),
                        style: const TextStyle(
                          fontFamily: "Signatra",
                          fontSize: 18,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                        height: 15,
                      ),
                      Text(
                        "Total belanjaan : " + jumlahBelanjaan.toString(),
                        style: const TextStyle(
                          fontFamily: "Signatra",
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      // Text(
                      //   "\nOngkir : " + ongkir.toString(),
                      //   style: TextStyle(
                      //     fontFamily: "Signatra",
                      //     fontSize: 20,
                      //     letterSpacing: 2,
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
                child: SliderButton(
              action: () {
                ///Do something here
                FirebaseFirestore.instance
                    .collection("pesanan")
                    .doc(widget.getPesananId)
                    .update({
                  "status": "selesai",
                }).then((value) {
                  FirebaseFirestore.instance
                      .collection("pembeli")
                      .doc(widget.belanjaanId)
                      .collection("pesanan")
                      .doc(widget.getPesananId)
                      .update({
                    "status": "selesai",
                  });
                });
                Fluttertoast.showToast(msg: "Pesanan Selesai");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
              label: Text(
                "Uang Sudah Diberikan",
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
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
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
              )),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Center(
            //     child: InkWell(
            //       onTap: () {
            //         FirebaseFirestore.instance
            //             .collection("pesanan")
            //             .doc(widget.getPesananId)
            //             .update({
            //           "status": "selesai",
            //         }).then((value) {
            //           FirebaseFirestore.instance
            //               .collection("pembeli")
            //               .doc(widget.belanjaanId)
            //               .collection("pesanan")
            //               .doc(widget.getPesananId)
            //               .update({
            //             "status": "selesai",
            //           });
            //         });
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => const HomeScreen()));
            //       },
            //       child: Container(
            //         decoration: const BoxDecoration(
            //             gradient: LinearGradient(
            //           colors: [
            //             Colors.cyan,
            //             Colors.amber,
            //           ],
            //           begin: FractionalOffset(0.0, 0.0),
            //           end: FractionalOffset(1.0, 0.0),
            //           stops: [0.0, 1.0],
            //           tileMode: TileMode.clamp,
            //         )),
            //         width: MediaQuery.of(context).size.width - 90,
            //         height: 50,
            //         child: const Center(
            //           child: Text(
            //             "Uang sudah diberikan ke pedagang",
            //             style: TextStyle(color: Colors.white, fontSize: 15.0),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ]),
    );
  }
}
