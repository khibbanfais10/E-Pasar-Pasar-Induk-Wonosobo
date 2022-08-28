import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/assistantMethods/assistant_methods.dart';
import 'package:driver/global/global.dart';
import 'package:driver/widgets/kartu_pesanan.dart';
import 'package:driver/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:driver/assistantMethods/assistant_methods.dart';
import '../widgets/simple_app_bar.dart';

class LayarHistori extends StatefulWidget {
  const LayarHistori({Key? key}) : super(key: key);

  @override
  State<LayarHistori> createState() => _LayarHistoriState();
}

class _LayarHistoriState extends State<LayarHistori> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: SimpleAppBar(
        title: "Histori",
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("pesanan")
            .where("driverUID", isEqualTo: sharedPreferences!.getString("uid"))
            .where("status", isEqualTo: "selesai")
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
