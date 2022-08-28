import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/global/global.dart';
import 'package:driver/model/alamat.dart';
import 'package:driver/widgets/design_pengiriman.dart';
import 'package:driver/widgets/progress_bar.dart';
import 'package:driver/widgets/status_banner.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LayarDetailPesanan extends StatefulWidget {
  final String? pesananID;
  LayarDetailPesanan({this.pesananID});

  @override
  State<LayarDetailPesanan> createState() => _LayarDetailPesananState();
}

class _LayarDetailPesananState extends State<LayarDetailPesanan> {
  String statusPesanan = "";
  String dipesanOlehPembeli = "";
  String penjualId = "";
  double totalBelanjaan = 0;
  String nomorTelepon = "";

  getOrderInfo() {
    FirebaseFirestore.instance
        .collection("pesanan")
        .doc(widget.pesananID)
        .get()
        .then((DocumentSnapshot) {
      statusPesanan = DocumentSnapshot.data()!["status"].toString();
      dipesanOlehPembeli = DocumentSnapshot.data()!["dipesanOleh"].toString();
      penjualId = DocumentSnapshot.data()!["penjualUID"].toString();
    });
  }

  getNomorTelepon() {
    FirebaseFirestore.instance
        .collection("driver")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((value) {
      nomorTelepon = value.data()!["phone"].toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getOrderInfo();
    getNomorTelepon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("pesanan")
              .doc(widget.pesananID)
              .get(),
          builder: (
            c,
            snapshot,
          ) {
            Map? dataMap;

            if (snapshot.hasData) {
              dataMap = snapshot.data!.data()! as Map<String, dynamic>;
              statusPesanan = dataMap["status"].toString();
            }
            return snapshot.hasData
                ? Container(
                    child: Column(
                      children: [
                        StatusBanner(
                          status: dataMap!["isSuccess"],
                          statusPesanan: statusPesanan,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Total Harga : " +
                                  "Rp. " +
                                  dataMap["jumlahTotal"].toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Total Belanjaan : " +
                                dataMap["totalBelanjaan"].toString(),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Ongkir : " + dataMap["ongkir"].toString(),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "ID Pesanan" + widget.pesananID!,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Tanggal Pesanan : " +
                                DateFormat("dd MM, yyyy - HH:mm ").format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(dataMap["waktuPesanan"]))),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 4,
                        ),
                        statusPesanan == "selesai"
                            ? Image.asset("images/success.jpg")
                            : Image.asset("images/confirm_pick.png"),
                        const Divider(
                          thickness: 4,
                        ),
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("pembeli")
                              .doc(dipesanOlehPembeli)
                              .collection("pembeliAlamat")
                              .doc(dataMap["alamatID"])
                              .get(),
                          builder: (c, snapshot) {
                            return snapshot.hasData
                                ? DesignPengiriman(
                                    model: Alamat.fromJson(snapshot.data!.data()
                                        as Map<String, dynamic>),
                                    statusPesanan: statusPesanan,
                                    pesananId: widget.pesananID,
                                    penjualId: penjualId,
                                    dipesanOlehPembeli: dipesanOlehPembeli,
                                    nomorTelepon: nomorTelepon,
                                  )
                                : Center(
                                    child: circularProgress(),
                                  );
                          },
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
