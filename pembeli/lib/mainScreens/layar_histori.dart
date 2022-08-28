import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pembeli/assistantMethods/assistant_methods.dart';
import 'package:pembeli/global/global.dart';
import 'package:pembeli/widgets/kartu_pesanan.dart';
import 'package:pembeli/widgets/progress_bar.dart';
import 'package:pembeli/widgets/simple_app_bar.dart';

class LayarHistori extends StatefulWidget {
  const LayarHistori({Key? key}) : super(key: key);

  @override
  State<LayarHistori> createState() => _LayarHistoriState();
}

class _LayarHistoriState extends State<LayarHistori> {
  var status = ["selesai", "ditolak", "pembayaran"];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: SimpleAppBar(
        title: "Histori Pesanan",
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("pembeli")
            .doc(sharedPreferences!.getString("uid"))
            .collection("pesanan")
            .where("status", whereIn: status)
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
                              whereIn: separateOrderItemIDs(
                                  (snapshot.data!.docs[index].data()!
                                      as Map<String, dynamic>)["productID"]))
                          .where("dipesanOleh",
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
