import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:penjual/assistantMethods/assistant_methods.dart';
import 'package:penjual/global/global.dart';
import 'package:penjual/widgets/kartu_pesanan.dart';
import 'package:penjual/widgets/progress_bar.dart';

import '../widgets/simple_app_bar.dart';

class LayarPesananBaru extends StatefulWidget {
  const LayarPesananBaru({Key? key}) : super(key: key);

  @override
  State<LayarPesananBaru> createState() => _LayarPesananBaruState();
}

class _LayarPesananBaruState extends State<LayarPesananBaru> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: SimpleAppBar(
        title: "Pesanan Baru",
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("pesanan")
            .where("status", isEqualTo: "dipesan")
            .where("penjualUID", isEqualTo: sharedPreferences!.getString("uid"))
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
                                pemesan: (snapshot.data!.docs[index].data()!
                                    as Map<String, dynamic>)["dipesanOleh"],
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
