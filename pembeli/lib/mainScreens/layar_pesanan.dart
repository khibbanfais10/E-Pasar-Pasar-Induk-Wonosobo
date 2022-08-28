import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pembeli/assistantMethods/assistant_methods.dart';
import 'package:pembeli/global/global.dart';
import 'package:pembeli/mainScreens/home_screen.dart';
import 'package:pembeli/models/alamat.dart';
import 'package:pembeli/models/items.dart';

import '../widgets/progress_bar.dart';

class LayarPesanan extends StatefulWidget {
  String? alamatID;
  double? totalJumlah;
  String? penjualUID;
  Barang? model;
  double? latOngkir;
  double? lngOngkir;

  LayarPesanan(
      {this.alamatID,
      this.totalJumlah,
      this.penjualUID,
      this.model,
      this.latOngkir,
      this.lngOngkir});

  @override
  State<LayarPesanan> createState() => _LayarPesananState();
}

class _LayarPesananState extends State<LayarPesanan> {
  List<int>? separateJumlah;
  int? kurangStok;
  List<int> stokBarang = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    separateJumlah = separateItemQuantities();
    updateStokBarang();
  }

  String pesananId = DateTime.now().millisecondsSinceEpoch.toString();

  updateStokBarang() {
    double jarak = (((Geolocator.distanceBetween(-7.3630632, 109.9019217,
                    widget.latOngkir!, widget.lngOngkir!)) *
                2) /
            1000)
        .roundToDouble();

    ongkir = (3000 * jarak).roundToDouble();
    // print(
    //     "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAssssssss" + jarak.toString());
    // print("AAAAAAAAAAAAAAAAAAAAAAAAAAACCCVVVVVVBBBongkir" +
    //     widget.latOngkir!.toString());
    // print(
    //     "\nAAAAAAAAAAAAAAAAAAAAAAAAAAACCCVVVVVVBBBlatdb" + _latDb.toString());
    // print(
    //     "\nAAAAAAAAAAAAAAAAAAAAAAAAAAACCCVVVVVVBBBlngdb" + _lngDb.toString());

    // printOngkir = ongkir.toString();
  }

  getNamaPenjual() {
    FirebaseFirestore.instance
        .collection("penjual")
        .doc(widget.penjualUID)
        .get()
        .then((value) {
      setState(() {
        namaPenjual = value.data()!['penjualName'].toString();
      });
    });
  }

  masukkanDetailPesanan() {
    tulisDetailPesananUntukPembeli({
      "alamatID": widget.alamatID,
      "jumlahTotal": totalHarga,
      "totalBelanjaan": widget.totalJumlah,
      "dipesanOleh": sharedPreferences!.getString("uid"),
      "productID": sharedPreferences!.getStringList("pembeliCart"),
      "metodePembayaran": "COD",
      "waktuPesanan": pesananId,
      "isSuccess": true,
      "penjualUID": widget.penjualUID,
      "driverUID": "",
      "status": "dipesan",
      "pesananId": pesananId,
      "ongkir": ongkir,
      "namaPenjual": namaPenjual
    });

    // updateStokBarang({
    //     StreamBuilder<QuerySnapshot>(
    //         stream: FirebaseFirestore.instance
    //             .collection("barang")
    //             .where("itemID", whereIn: separateItemIDs())
    //             .orderBy("publishedDate", descending: true)
    //             .snapshots(),
    //         builder: (context, snapshot) {
    //           return !snapshot.hasData
    //               ? SliverToBoxAdapter(
    //                   child: Center(
    //                     child: circularProgress(),
    //                   ),
    //                 )
    //               : snapshot.data!.docs.length == 0
    //                   ? Container()
    //                    SliverList(
    //                       delegate: SliverChildBuilderDelegate(
    //                         (context, index) {
    //                           FirebaseFirestore.instance
    //                               .collection("penjual")
    //                               .doc(sharedPreferences!.getString("uid"))
    //                               .collection("menu")
    //                               .doc(widget.model!.menuID)
    //                               .collection("barang")
    //                               .doc(widget.model!.itemID)
    //                               .get()
    //                               .then((value) {
    //                             stokBarang[index] = value.data()!['stok'];
    //                           });
    //                           Barang model = Barang.fromJson(
    //                             snapshot.data!.docs[index].data()!
    //                                 as Map<String, dynamic>,
    //                           );
    //                           kurangStok = separateJumlah![index];
    //                           print("kurang stok $kurangStok");

    //                           FirebaseFirestore.instance
    //                               .collection("penjual")
    //                               .doc(sharedPreferences!.getString("uid"))
    //                               .collection("menu")
    //                               .doc(widget.model!.menuID)
    //                               .collection("barang")
    //                               .doc(widget.model!.itemID)
    //                               .update({
    //                             "stok": stokBarang[index] - kurangStok!,
    //                           });
    //                         },
    //                         childCount:
    //                             snapshot.hasData ? snapshot.data!.docs.length : 0,
    //                       ),
    //                     );
    //          })
    //    }
    // );

    tulisDetailPesananUntukPenjual({
      "alamatID": widget.alamatID,
      "jumlahTotal": totalHarga,
      "totalBelanjaan": widget.totalJumlah,
      "dipesanOleh": sharedPreferences!.getString("uid"),
      "productID": sharedPreferences!.getStringList("pembeliCart"),
      "metodePembayaran": "COD",
      "waktuPesanan": pesananId,
      "isSuccess": true,
      "penjualUID": widget.penjualUID,
      "driverUID": "",
      "status": "dipesan",
      "pesananId": pesananId,
      "ongkir": ongkir,
      "namaPenjual": namaPenjual
    }).whenComplete(() {
      clearCartNow(context);
      setState(() {
        pesananId = "";
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
        Fluttertoast.showToast(msg: "Pesanan Berhasil Dipesan");
      });
    });
  }

  Future tulisDetailPesananUntukPembeli(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection("pembeli")
        .doc(sharedPreferences!.getString("uid"))
        .collection("pesanan")
        .doc(pesananId)
        .set(data);
  }

  Future tulisDetailPesananUntukPenjual(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection("pesanan")
        .doc(pesananId)
        .set(data);
  }

  // Future updateStokBarang(Map<String, dynamic> data) async {

  // }

  // int i = 1;
  // int? barangStok;
  // String? barangId;
  // int k = 1;
  // for (i; i < penguranganStok.length; i++) {
  //  await FirebaseFirestore.instance
  //       .collection("barang")
  //       .where("itemID", isEqualTo: "1655454828579")
  //       .get()
  //       .update
  // doc('itemID').update({
  //   "stok": 50,
  // });
  // .where("itemID", isEqualTo: idBarang[i])
  // .get();

  // await FirebaseFirestore.instance.collection("barang").doc("itemID").update({
  //   "stok": 50,
  // });
  // k++;
  //     .get()
  //     .then((value) {
  //   setState(() {
  //     barangStok = value.data()!['stok'];
  //     barangId = value.data()!['itemID'];
  //   });
  // });

  // if (barangId == idBarang[i]) {
  // FirebaseFirestore.instance.collection("barang").doc("itemID").update({
  //   "stok": 50,
  // });
  // k++;
  // } else {
  //   print("clicked");
  //   k++;
  // }

  // Future updateStokBarang(Map<String, dynamic> data) async {
  //   await StreamBuilder<QuerySnapshot>(
  //       stream: FirebaseFirestore.instance
  //           .collection("barang")
  //           .where("itemID", whereIn: separateItemIDs())
  //           .orderBy("publishedDate", descending: true)
  //           .snapshots(),
  //       builder: (context, snapshot) {
  //         return !snapshot.hasData
  //             ? SliverToBoxAdapter(
  //                 child: Center(
  //                   child: circularProgress(),
  //                 ),
  //               )
  //             : snapshot.data!.docs.length == 0
  //                 ? Container()
  //                 : SliverList(
  //                     delegate: SliverChildBuilderDelegate(
  //                       (context, index) {
  //                         FirebaseFirestore.instance
  //                             .collection("penjual")
  //                             .doc(sharedPreferences!.getString("uid"))
  //                             .collection("menu")
  //                             .doc(widget.model!.menuID)
  //                             .collection("barang")
  //                             .doc(widget.model!.itemID)
  //                             .get()
  //                             .then((value) {
  //                           stokBarang[index] = value.data()!['stok'];
  //                         });
  //                         Barang model = Barang.fromJson(
  //                           snapshot.data!.docs[index].data()!
  //                               as Map<String, dynamic>,
  //                         );
  //                         kurangStok = separateJumlah![index];
  //                         print("kurang stok $kurangStok");

  //                         FirebaseFirestore.instance
  //                             .collection("penjual")
  //                             .doc(sharedPreferences!.getString("uid"))
  //                             .collection("menu")
  //                             .doc(widget.model!.menuID)
  //                             .collection("barang")
  //                             .doc(widget.model!.itemID)
  //                             .update({
  //                           "stok": stokBarang[index] - kurangStok!,
  //                         });
  //                       },
  //                       childCount:
  //                           snapshot.hasData ? snapshot.data!.docs.length : 0,
  //                     ),
  //                   );
  //       });
  //
  //}
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    getNamaPenjual();
  }

  @override
  Widget build(BuildContext context) {
//     Stream<QuerySnapshot> lokasi  = FirebaseFirestore.instance
//         .collection("pembeli")
//         .doc(sharedPreferences!.getString("uid"))
//         .collection("pembeliAlamat")
//         .snapshots();
// FirebaseFirestore.instance.collection("pembeli").doc(sharedPreferences!.getString("uid")).collection("pembeliAlamat").get().then((value) {
//   lokasi1 = value.docs['lat'];
// })
    totalHarga = widget.totalJumlah! + ongkir!;
    return Material(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/delivery.jpg"),
            const SizedBox(
              height: 12,
            ),
            Text(
              "Ongkir : " + ongkir.toString(),
              style: const TextStyle(
                fontFamily: "Signatra",
                fontSize: 20,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "Total Belanjaan : " + widget.totalJumlah.toString(),
              style: const TextStyle(
                fontFamily: "Signatra",
                fontSize: 20,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "Total : " + totalHarga.toString(),
              style: const TextStyle(
                fontFamily: "Signatra",
                fontSize: 20,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              child: Text("Pesan"),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              onPressed: () {
                masukkanDetailPesanan();

                // StreamBuilder<QuerySnapshot>(
                //     stream: FirebaseFirestore.instance
                //         .collection("barang")
                //         .where("itemID", whereIn: separateItemIDs())
                //         .orderBy("publishedDate", descending: true)
                //         .snapshots(),
                //     builder: (context, snapshot) {
                //       return !snapshot.hasData
                //           ? SliverToBoxAdapter(
                //               child: Center(
                //                 child: circularProgress(),
                //               ),
                //             )
                //           : snapshot.data!.docs.isEmpty
                //               ? Container()
                //               : SliverList(
                //                   delegate: SliverChildBuilderDelegate(
                //                     (context, index) {
                //                       FirebaseFirestore.instance
                //                           .collection("barang")
                //                           .doc(widget.model!.itemID)
                //                           .get()
                //                           .then((value) {
                //                         stokBarang[index] =
                //                             value.data()!['stok'];
                //                       });
                //                       Barang model = Barang.fromJson(
                //                         snapshot.data!.docs[index].data()!
                //                             as Map<String, dynamic>,
                //                       );
                //                       kurangStok = separateJumlah![index];
                //                       print("kurang stok $kurangStok");

                //                       FirebaseFirestore.instance
                //                           .collection("barang")
                //                           .doc(widget.model!.itemID)
                //                           .update({
                //                         'stok':
                //                             widget.model!.stok! - kurangStok!,
                //                       });
                //                     },
                //                     childCount: snapshot.hasData
                //                         ? snapshot.data!.docs.length
                //                         : 0,
                //                   ),
                //                 );
                //     });
              },
            ),
          ],
        ),
      ),
    );
  }
}
