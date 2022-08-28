import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/assistantMethods/assistant_methods.dart';
import 'package:driver/global/global.dart';
import 'package:driver/widgets/kartu_pesanan.dart';
import 'package:driver/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:driver/assistantMethods/assistant_methods.dart';
import '../widgets/simple_app_bar.dart';

class PengirimanBerjalan extends StatefulWidget {
  const PengirimanBerjalan({Key? key}) : super(key: key);

  @override
  State<PengirimanBerjalan> createState() => _PengirimanBerjalanState();
}

class _PengirimanBerjalanState extends State<PengirimanBerjalan> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: SimpleAppBar(
        title: "Pengiriman Berjalan",
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("pesanan")
            .where("driverUID", isEqualTo: sharedPreferences!.getString("uid"))
            .where("status", isEqualTo: "pengambilan")
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
