import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:penjual/mainScreens/layar_detail_pesanan.dart';
import 'package:penjual/model/items.dart';

class KartuPesanan extends StatelessWidget {
  final int? jumlahBarang;
  final List<DocumentSnapshot>? data;
  final String? pesananID;
  final List<String>? seperateQuantitiesList;
  final String? pemesan;

  KartuPesanan(
      {this.jumlahBarang,
      this.data,
      this.pesananID,
      this.seperateQuantitiesList,
      this.pemesan});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LayarDetailPesanan(
                      pesananID: pesananID,
                      pemesan: pemesan,
                    )));
      },
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.black12,
            Colors.white54,
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        )),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        height: jumlahBarang! * 125,
        child: ListView.builder(
          itemCount: jumlahBarang,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            Barang model =
                Barang.fromJson(data![index].data()! as Map<String, dynamic>);
            return placeOrderDesignWidget(
                model, context, seperateQuantitiesList![index]);
          },
        ),
      ),
    );
  }
}

Widget placeOrderDesignWidget(
    Barang model, BuildContext context, seperateQuantitiesList) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 120,
    color: Colors.grey[200],
    child: Row(
      children: [
        Image.network(
          model.thumbnailUrl!,
          width: 120,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Text(
                  model.title!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: "Acme",
                  ),
                )),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Rp. ",
                  style: TextStyle(fontSize: 16.0, color: Colors.blue),
                ),
                Text(
                  model.price.toString(),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "x ",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                Expanded(
                    child: Text(
                  seperateQuantitiesList,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 30,
                    fontFamily: "Acme",
                  ),
                )),
              ],
            ),
          ],
        ))
      ],
    ),
  );
}
