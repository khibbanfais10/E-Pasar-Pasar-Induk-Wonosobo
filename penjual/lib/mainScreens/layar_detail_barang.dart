import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:penjual/global/global.dart';
import 'package:penjual/mainScreens/home_screen.dart';
import 'package:penjual/mainScreens/layar_edit_barang.dart';
import 'package:penjual/model/items.dart';
import 'package:penjual/widgets/simple_app_bar.dart';

class LayarDetailBarang extends StatefulWidget {
  final Barang? model;
  String? menuID;
  LayarDetailBarang({this.model, this.menuID});

  @override
  State<LayarDetailBarang> createState() => _LayarDetailBarangState();
}

class _LayarDetailBarangState extends State<LayarDetailBarang> {
  TextEditingController counterTextEditingController = TextEditingController();

  hapusBarang(String itemID) {
    FirebaseFirestore.instance
        .collection("penjual")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menu")
        .doc(widget.model!.menuID)
        .collection("barang")
        .doc(itemID)
        .delete()
        .then((value) {
      FirebaseFirestore.instance.collection("barang").doc(itemID).delete();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      Fluttertoast.showToast(msg: "Barang Berhasil Dihapus");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: SimpleAppBar(
          title: sharedPreferences!.getString("name"),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.model!.thumbnailUrl.toString()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.model!.title.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.model!.longDescription.toString(),
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Rp " + widget.model!.price.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(children: [
                Center(
                  child: InkWell(
                    onTap: () {
                      hapusBarang(widget.model!.itemID!);
                    },
                    child: Container(
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
                      width: MediaQuery.of(context).size.width - 10,
                      height: 50,
                      child: const Center(
                        child: Text(
                          "Hapus Barang",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LayarEditBarang(
                                    model: widget.model!,
                                    deskripsi: widget.model!.longDescription,
                                    harga: widget.model!.price,
                                    thumbnail: widget.model!.thumbnailUrl,
                                    judul: widget.model!.title,
                                    itemID: widget.model!.itemID,
                                    shortInfo: widget.model!.shortInfo,
                                    menuId: widget.menuID,
                                  )));
                    },
                    child: Container(
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
                      width: MediaQuery.of(context).size.width - 10,
                      height: 50,
                      child: Center(
                        child: Text(
                          "Edit Barang",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ])
            ],
          ),
        ));
  }
}
