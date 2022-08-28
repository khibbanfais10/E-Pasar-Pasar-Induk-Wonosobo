import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pembeli/models/sellers.dart';
import 'package:pembeli/widgets/info_design.dart';

class LayarPencarian extends StatefulWidget {
  const LayarPencarian({Key? key}) : super(key: key);

  @override
  State<LayarPencarian> createState() => _LayarPencarianState();
}

class _LayarPencarianState extends State<LayarPencarian> {
  Future<QuerySnapshot>? kiosDocumentList;
  String penjualNamaText = "";

  initPencarianKios(String textEntered) {
    kiosDocumentList = FirebaseFirestore.instance
        .collection("penjual")
        .where("penjualName", isGreaterThanOrEqualTo: textEntered)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        title: TextField(
          onChanged: (textEntered) {
            setState(() {
              penjualNamaText = textEntered;
            });
            initPencarianKios(textEntered);
          },
          decoration: InputDecoration(
            hintText: "Pencarian Kios...",
            hintStyle: const TextStyle(color: Colors.white54),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                initPencarianKios(penjualNamaText);
              },
            ),
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: kiosDocumentList,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Sellers model = Sellers.fromJson(snapshot.data!.docs[index]
                        .data()! as Map<String, dynamic>);
                    return SellersDesignWidget(
                      model: model,
                      context: context,
                    );
                  },
                )
              : const Center(
                  child: Text("Data tidak ditemukan"),
                );
        },
      ),
    );
  }
}
