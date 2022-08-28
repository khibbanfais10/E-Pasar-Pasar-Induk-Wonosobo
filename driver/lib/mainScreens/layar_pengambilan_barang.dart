import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/assistantMethods/dapatkan_lokasi_sekarang.dart';
import 'package:driver/global/global.dart';
import 'package:driver/mainScreens/home_screen.dart';
import 'package:driver/mainScreens/layar_pengiriman_barang.dart';
import 'package:driver/maps/maps_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:slider_button/slider_button.dart';

class LayarPengambilanBarang extends StatefulWidget {
  String? belanjaanId;
  String? belanjaanAlamat;
  double? belanjaanLat;
  double? belanjaanLng;
  String? penjualId;
  String? getPesananID;
  String? pesananId;
  String? dipesanOlehPembeli;
  double? totalBelanjaan;

  LayarPengambilanBarang(
      {this.belanjaanId,
      this.belanjaanAlamat,
      this.belanjaanLat,
      this.belanjaanLng,
      this.penjualId,
      this.getPesananID,
      this.dipesanOlehPembeli,
      this.pesananId,
      this.totalBelanjaan});

  @override
  State<LayarPengambilanBarang> createState() => _LayarPengambilanBarangState();
}

class _LayarPengambilanBarangState extends State<LayarPengambilanBarang> {
  double? penjualLat, penjualLng;

  getPenjualData() async {
    FirebaseFirestore.instance
        .collection("penjual")
        .doc(widget.penjualId)
        .get()
        .then((DocumentSnapshot) {
      penjualLat = DocumentSnapshot.data()!["lat"];
      penjualLng = DocumentSnapshot.data()!["lng"];
      setState(() {
        penjualNama = DocumentSnapshot.data()!['penjualName'];
        blokKios = DocumentSnapshot.data()!['blok'];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPenjualData();
  }

  konfirmasiBarangSudahDiambil(
      getPesananId,
      penjualId,
      belanjaanId,
      belanjaanAlamat,
      belanjaanLat,
      belanjaanLng,
      dipesanOlehPembeli,
      pesananId) {
    FirebaseFirestore.instance.collection("pesanan").doc(getPesananId).update({
      "status": "pengiriman",
      "alamat": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
    }).then((value) {
      FirebaseFirestore.instance
          .collection("pembeli")
          .doc(dipesanOlehPembeli)
          .collection("pesanan")
          .doc(pesananId)
          .update({"status": "pengiriman"});
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => LayarPengirimanBarang(
                  belanjaanId: belanjaanId,
                  belanjaanAlamat: belanjaanAlamat,
                  belanjaanLat: belanjaanLat,
                  belanjaanLng: belanjaanLng,
                  penjualId: penjualId,
                  getPesananId: getPesananId,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            "Pengambilan Barang",
            style: TextStyle(),
          ),
        ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/confirm1.png",
              width: 350,
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                MapUtils.BukaMapKeLokasi(position!.latitude,
                    position!.longitude, penjualLat, penjualLng);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   'images/restaurant.png',
                  //   width: 50,
                  // ),
                  const SizedBox(
                    width: 7,
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 13,
                      ),
                      Text(
                        "Nama Pedagang : $penjualNama",
                        style: const TextStyle(
                          fontFamily: "Signatra",
                          fontSize: 18,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Text(
                        "Lokasi Kios : $blokKios",
                        style: const TextStyle(
                          fontFamily: "Signatra",
                          fontSize: 18,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
                child: SliderButton(
              action: () {
                ///Do something here
                PembeliLokasi pLokasi = PembeliLokasi();
                pLokasi.getCurrentLocation();

                konfirmasiBarangSudahDiambil(
                    widget.getPesananID,
                    widget.penjualId,
                    widget.belanjaanId,
                    widget.belanjaanAlamat,
                    widget.belanjaanLat,
                    widget.belanjaanLng,
                    widget.dipesanOlehPembeli,
                    widget.pesananId);
              },
              label: Text(
                "Pesanan sudah diambil",
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
            const SizedBox(
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
                ),
              ),
            ),
          ]),
    );
  }
}
