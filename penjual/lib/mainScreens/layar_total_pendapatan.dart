import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:penjual/global/global.dart';
import 'package:penjual/mainScreens/home_screen.dart';

class LayarTotalPendapatan extends StatefulWidget {
  const LayarTotalPendapatan({Key? key}) : super(key: key);

  @override
  State<LayarTotalPendapatan> createState() => _LayarTotalPendapatanState();
}

class _LayarTotalPendapatanState extends State<LayarTotalPendapatan> {
  double penjualTotalPendapatan = 0;

  dapatkanPendapatanPenjual() async {
    await FirebaseFirestore.instance
        .collection("penjual")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap) {
      setState(() {
        penjualTotalPendapatan =
            double.parse(snap.data()!["earnings"].toString());
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dapatkanPendapatanPenjual();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Rp. " + penjualTotalPendapatan!.toString(),
                style: const TextStyle(
                  fontSize: 80,
                  color: Colors.white,
                  fontFamily: "Signatra",
                ),
              ),
              const Text(
                "Total Pendapatan",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.white,
                  thickness: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => HomeScreen()));
                },
                child: const Card(
                  color: Colors.white54,
                  margin: EdgeInsets.symmetric(vertical: 49, horizontal: 120),
                  child: ListTile(
                    leading: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Kembali",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
