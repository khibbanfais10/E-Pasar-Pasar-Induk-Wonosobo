import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/assistantMethods/assistant_methods.dart';
import 'package:driver/global/global.dart';
import 'package:driver/widgets/kartu_pesanan.dart';
import 'package:driver/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:driver/assistantMethods/assistant_methods.dart';
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
            .where("status", isEqualTo: "packing")
            .orderBy("waktuPesanan", descending: true)
            .snapshots(),
        builder: (c, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (c, index) {
                    return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("pesanan")
                          .where("pesananId",
                              isEqualTo: snapshot.data!.docs[index].id)
                          // .where("pesananId", isEqualTo:
                          //    )
                          .get(),
                      // FirebaseFirestore.instance
                      //     .collection("barang")
                      //     .where("itemID",
                      //         whereIn: separateOrderItemIDS(
                      //             (snapshot.data!.docs[index].data()!
                      //                 as Map<String, dynamic>)["productID"]))
                      //     .where("dipesanOleh",
                      //         whereIn: (snapshot.data!.docs[index].data()!
                      //             as Map<String, dynamic>)["uid"])
                      //     .orderBy("publishedDate", descending: true)
                      //     .get(),
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
                                child: Text("Tidak ada pesanan tersedia"),
                              );
                      },
                    );
                  },
                )
              : Center(
                  child: Text("Tidak ada pesanan tersedia"),
                );
        },
      ),
    ));
  }
}
