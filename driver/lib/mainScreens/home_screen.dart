import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/assistantMethods/assistant_methods.dart';
import 'package:driver/assistantMethods/dapatkan_lokasi_sekarang.dart';
import 'package:driver/mainScreens/layar_histori.dart';

import 'package:driver/mainScreens/layar_pengiriman_berjalan.dart';
import 'package:driver/mainScreens/layar_pesanan_baru.dart';
import 'package:driver/mainScreens/layar_pesanan_belum_terkirim.dart';
import 'package:driver/mainScreens/layar_total_pendapatan.dart';
import 'package:driver/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../authentication/auth_screen.dart';
import '../global/global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Card makeDashBoardItem(String title, IconData iconData, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? const BoxDecoration(
                gradient: LinearGradient(
                colors: [
                  Colors.amber,
                  Colors.cyan,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ))
            : const BoxDecoration(
                gradient: LinearGradient(
                colors: [
                  Colors.redAccent,
                  Colors.amber,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => LayarPesananBaru()));
            }
            if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => PengirimanBerjalan()));
            }
            if (index == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => LayarPesananBelumTerkirim()));
            }
            if (index == 3) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => LayarHistori()));
            }
            if (index == 4) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => LayarTotalPendapatan()));
            }
            if (index == 5) {
              firebaseAuth.signOut().then((value) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => AuthScreen()));
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(
                height: 50.0,
              ),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  restrictBlockedUser() async {
    await FirebaseFirestore.instance
        .collection("driver")
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((snapshot) {
      if (snapshot.data()!["status"] != "approved") {
        Fluttertoast.showToast(msg: "Akun anda terblokir.");

        firebaseAuth.signOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => MySplashScreen()));
      } else {
        PembeliLokasi pLokasi = PembeliLokasi();
        pLokasi.getCurrentLocation();
        getJumlahPerPengirimanBarang();
        getDriverPendapatanSebelumnya();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    restrictBlockedUser();
  }

  getDriverPendapatanSebelumnya() {
    FirebaseFirestore.instance
        .collection("driver")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap) {
      pendapatanDriverSebelumnya = snap.data()!["earnings"].toString();
    });
  }

  getJumlahPerPengirimanBarang() {
    FirebaseFirestore.instance
        .collection("perPengiriman")
        .doc("faishol16")
        .get()
        .then((snap) {
      perPengirimanBarang = snap.data()!["jumlah"].toString();
    });
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
        title: Text(
          "Selamat Datang " + sharedPreferences!.getString("name")!,
          style: const TextStyle(
            fontSize: 25.0,
            color: Colors.black,
            fontFamily: "Signatra",
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 1),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(2),
          children: [
            makeDashBoardItem("Pesanan Baru Tersedia", Icons.assignment, 0),
            makeDashBoardItem("Pesanan Berjalan", Icons.airport_shuttle, 1),
            makeDashBoardItem(
                "Pesanan Belum Terkirim", Icons.location_history, 2),
            makeDashBoardItem("Histori", Icons.done_all, 3),
            makeDashBoardItem("Total Pendapatan", Icons.monetization_on, 4),
            makeDashBoardItem("Logout", Icons.logout, 5),
          ],
        ),
      ),
    );
  }
}
