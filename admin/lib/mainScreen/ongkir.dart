import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LayarOngkir extends StatefulWidget {
  const LayarOngkir({Key? key}) : super(key: key);

  @override
  State<LayarOngkir> createState() => _LayarOngkirState();
}

class _LayarOngkirState extends State<LayarOngkir> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController ongkirController = TextEditingController();
  String nama = "faishol16";
  double penjualTotalPendapatan = 0;
  editOngkir() async {
    SnackBar snackBar = const SnackBar(
      content: Text(
        "Mengedit Ongkir",
        style: TextStyle(fontSize: 36, color: Colors.black),
      ),
      backgroundColor: Colors.pinkAccent,
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  // dapatkanPendapatanPenjual() async {
  //   await FirebaseFirestore.instance
  //       .collection("perPengiriman")
  //       .get()
  //       .then((snap) {
  //     setState(() {
  //       penjualTotalPendapatan =
  //           double.parse(snap.data()!["earnings"].toString());
  //     });
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // dapatkanPendapatanPenjual();
  }

  @override
  Widget build(BuildContext context) {
    String ongkir = "";
    return Scaffold(
        body: Stack(children: [
      Center(
          child: Container(
        width: MediaQuery.of(context).size.width * .5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Edit Ongkir",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            TextField(
              onChanged: ((value) {
                ongkir = value;
              }),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                editOngkir();
                FirebaseFirestore.instance
                    .collection("perPengiriman")
                    .doc(nama)
                    .update({
                  "jumlah": int.parse(ongkir),
                });
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 100, vertical: 20)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.pinkAccent),
              ),
              child: const Text(
                "Edit",
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      )),
    ])

        // backgroundColor: Colors.black,
        // body: Form(
        //   key: _formKey,
        //   child: Column(
        //     children: [
        //       customtextField
        //     ],
        //   ))
        // SafeArea(
        //   // child: Center(
        //   //   child: Column(
        //   //     mainAxisAlignment: MainAxisAlignment.center,
        //   //     children: [

        //   //     ],
        //   //   ),
        //   // ),
        // ),
        );
  }
}
