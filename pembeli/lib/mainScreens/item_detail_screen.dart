import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:pembeli/models/items.dart';
import 'package:pembeli/models/sellers.dart';
import 'package:pembeli/widgets/app_bar.dart';

import '../assistantMethods/assistant_methods.dart';

class itemDetailsScreen extends StatefulWidget {
  final Barang? model;
  Sellers? sModel;
  BuildContext? bContext;
  itemDetailsScreen({this.model, this.sModel, this.bContext});

  @override
  State<itemDetailsScreen> createState() => _itemDetailsScreenState();
}

class _itemDetailsScreenState extends State<itemDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyAppBar(penjualUID: widget.model!.penjualUID),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.model!.thumbnailUrl.toString()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: NumberInputPrefabbed.roundedButtons(
                  controller: counterTextEditingController,
                  incDecBgColor: Colors.amber,
                  min: 1,
                  max: 20,
                  initialValue: 1,
                  buttonArrangement: ButtonArrangement.incRightDecLeft,
                ),
              ),
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
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //     "Stok : " + widget.model!.stok.toString(),
              //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              //   ),
              // ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    int itemCounter =
                        int.parse(counterTextEditingController.text);

                    List<String> separateItemIDsList = separateItemIDs();

                    separateItemIDsList.contains(widget.model!.itemID)
                        ? Fluttertoast.showToast(
                            msg: "barang sudah terdapat di keranjang.")
                        : addItemToCart(
                            widget.model!.itemID, context, itemCounter);
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
                        "Tambahkan ke keranjang",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
