import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pembeli/global/global.dart';
import 'package:pembeli/models/alamat.dart';
import 'package:pembeli/widgets/design_pengiriman.dart';
import 'package:pembeli/widgets/progress_bar.dart';
import 'package:pembeli/widgets/status_banner.dart';

class LayarDetailPesanan extends StatefulWidget {
  final String? pesananID;
  LayarDetailPesanan({this.pesananID});

  @override
  State<LayarDetailPesanan> createState() => _LayarDetailPesananState();
}

class _LayarDetailPesananState extends State<LayarDetailPesanan> {
  String statusPesanan = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("pembeli")
              .doc(sharedPreferences!.getString("uid"))
              .collection("pesanan")
              .doc(widget.pesananID)
              .snapshots(),
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
                            "Dipesan dari : " +
                                DateFormat("dd MM, yyyy - HH:mm ").format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(dataMap["waktuPesanan"]))),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Status Pesanan : " + statusPesanan,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 4,
                        ),
                        statusPesanan == "selesai"
                            ? Image.asset("images/selesai.jpg")
                            : statusPesanan == "ditolak"
                                ? Image.asset("images/ditolak.PNG")
                                : statusPesanan == "diterima"
                                    ? Image.asset("images/diterima.png")
                                    : Image.asset("images/diproses.png"),
                        const Divider(
                          thickness: 4,
                        ),
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("pembeli")
                              .doc(sharedPreferences!.getString("uid"))
                              .collection("pembeliAlamat")
                              .doc(dataMap["alamatID"])
                              .get(),
                          builder: (c, snapshot) {
                            return snapshot.hasData
                                ? DesignPengiriman(
                                    model: Alamat.fromJson(snapshot.data!.data()
                                        as Map<String, dynamic>),
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
