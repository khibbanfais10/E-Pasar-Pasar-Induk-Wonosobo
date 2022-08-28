import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:penjual/model/alamat.dart';
import 'package:penjual/widgets/design_pengiriman.dart';
import 'package:penjual/widgets/progress_bar.dart';
import 'package:penjual/widgets/status_banner.dart';

import '../global/global.dart';

class LayarDetailPesanan extends StatefulWidget {
  final String? pesananID;
  String? pemesan;
  String? menuID;
  LayarDetailPesanan({this.pesananID, this.pemesan, this.menuID});

  @override
  State<LayarDetailPesanan> createState() => _LayarDetailPesananState();
}

class _LayarDetailPesananState extends State<LayarDetailPesanan> {
  String statusPesanan = "";
  String dipesanOlehPembeli = "";
  String penjualId = "";

  getOrderInfo() {
    FirebaseFirestore.instance
        .collection("pesanan")
        .doc(widget.pesananID)
        .get()
        .then((DocumentSnapshot) {
      statusPesanan = DocumentSnapshot.data()!["status"].toString();
      dipesanOlehPembeli = DocumentSnapshot.data()!["dipesanOleh"].toString();
      penjualId = DocumentSnapshot.data()!["penjualUID"].toString();
      namaDriver = DocumentSnapshot.data()!["driverName"].toString();
      telepon = DocumentSnapshot.data()!["teleponDriver"].toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getOrderInfo();
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
                            "ID Pesanan" + widget.pesananID!,
                            style: TextStyle(
                              fontSize: 16,
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
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 4,
                        ),
                        statusPesanan == "selesai"
                            ? Image.asset("images/delivered.jpg")
                            : Image.asset("images/packing.png"),
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
                                    telepon: telepon,
                                    namaDriver: namaDriver,
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
