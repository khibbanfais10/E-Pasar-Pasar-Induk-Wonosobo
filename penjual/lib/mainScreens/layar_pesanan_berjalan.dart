import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:penjual/assistantMethods/assistant_methods.dart';
import 'package:penjual/global/global.dart';
import 'package:penjual/widgets/kartu_pesanan.dart';
import 'package:penjual/widgets/progress_bar.dart';

import '../widgets/simple_app_bar.dart';

class LayarPesananBerjalan extends StatefulWidget {
  const LayarPesananBerjalan({Key? key}) : super(key: key);

  @override
  State<LayarPesananBerjalan> createState() => _LayarPesananBerjalanState();
}

class _LayarPesananBerjalanState extends State<LayarPesananBerjalan> {
  var daftarPesanan = ["packing", "pengiriman", "pembayaran", "pengambilan"];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: SimpleAppBar(
        title: "Pesanan Berjalan",
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("pesanan")
            .where("penjualUID", isEqualTo: sharedPreferences!.getString("uid"))
            .where("status", whereIn: daftarPesanan)
            .orderBy("waktuPesanan", descending: true)
            .snapshots(),
        builder: (c, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (c, index) {
                    return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("barang")
                          .where("itemID",
                              whereIn: separateOrderItemIDS(
                                  (snapshot.data!.docs[index].data()!
                                      as Map<String, dynamic>)["productID"]))
                          .where("penjualUID",
                              whereIn: (snapshot.data!.docs[index].data()!
                                  as Map<String, dynamic>)["uid"])
                          .orderBy("publishedDate", descending: true)
                          .get(),
                      builder: (c, snap) {
                        return snap.hasData
                            ? KartuPesanan(
                                jumlahBarang: snap.data!.docs.length,
                                data: snap.data!.docs,
                                pesananID: snapshot.data!.docs[index].id,
                                seperateQuantitiesList:
                                    separateOrderItemQuantities((snapshot
                                            .data!.docs[index]
                                            .data()!
                                        as Map<String, dynamic>)["productID"]),
                              )
                            : Center(
                                child: circularProgress(),
                              );
                      },
                    );
                  },
                )
              : Center(
                  child: circularProgress(),
                );
        },
      ),
    ));
  }
}
