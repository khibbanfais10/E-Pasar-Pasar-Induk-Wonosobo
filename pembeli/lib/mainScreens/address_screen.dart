import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pembeli/assistantMethods/pengubah_alamat.dart';
import 'package:pembeli/global/global.dart';
import 'package:pembeli/mainScreens/saveAddress_screen.dart';
import 'package:pembeli/models/alamat.dart';
import 'package:pembeli/widgets/design_alamat.dart';
import 'package:pembeli/widgets/progress_bar.dart';
import 'package:pembeli/widgets/simple_app_bar.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  final double? totalAmount;
  final String? penjualUID;

  AddressScreen({this.totalAmount, this.penjualUID});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Pasar Induk Wonosobo",
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Tambahkan alamat baru"),
        backgroundColor: Colors.cyan,
        icon: const Icon(
          Icons.add_location,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => SaveAddressScreen()));
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Pilih Alamat : ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Consumer<PengubahAlamat>(
            builder: (context, alamat, c) {
              return Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("pembeli")
                      .doc(sharedPreferences!.getString("uid"))
                      .collection("pembeliAlamat")
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Center(
                            child: circularProgress(),
                          )
                        : snapshot.data!.docs.length == 0
                            ? Container()
                            : ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return DesignAlamat(
                                    currentIndex: alamat.count,
                                    value: index,
                                    alamatId: snapshot.data!.docs[index].id,
                                    totalJumlah: widget.totalAmount,
                                    penjualUID: widget.penjualUID,
                                    model: Alamat.fromJson(
                                        snapshot.data!.docs[index].data()!
                                            as Map<String, dynamic>),
                                  );
                                },
                              );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
