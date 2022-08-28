import 'package:admin/mainScreen/home_screen.dart';
import 'package:admin/widgets/simple_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LayarPenjualTerverifikasi extends StatefulWidget {
  const LayarPenjualTerverifikasi({Key? key}) : super(key: key);

  @override
  State<LayarPenjualTerverifikasi> createState() =>
      _LayarPenjualTerverifikasiState();
}

class _LayarPenjualTerverifikasiState extends State<LayarPenjualTerverifikasi> {
  QuerySnapshot? allPenjual;

  dialogBlokirAkun(dokumenIdPenjual) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Blokir Akun",
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Apakah anda akan memblokir akun ini ?",
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Tidak"),
              ),
              ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> userDataMap = {
                    "status": "not approved",
                  };
                  FirebaseFirestore.instance
                      .collection("penjual")
                      .doc(dokumenIdPenjual)
                      .update(userDataMap)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => HomeScreen()));
                    SnackBar snackBar = SnackBar(
                      content: Text(
                        "Akun Berhasil Diblokir",
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.black,
                        ),
                      ),
                      backgroundColor: Colors.cyan,
                      duration: const Duration(seconds: 2),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                },
                child: const Text("Iya"),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("penjual")
        .where("status", isEqualTo: "approved")
        .get()
        .then((approvedPembeli) {
      setState(() {
        allPenjual = approvedPembeli;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget penjualTervefikasiDesign() {
      if (allPenjual != null) {
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: allPenjual!.docs.length,
          itemBuilder: (context, i) {
            return Card(
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                  allPenjual!.docs[i].get("sellerAvatarUrl")),
                              fit: BoxFit.fill,
                            )),
                      ),
                      title: Text(
                        allPenjual!.docs[i].get("penjualName"),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            allPenjual!.docs[i].get("penjualEmail"),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      icon: const Icon(
                        Icons.person_pin_sharp,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Blokir Akun Ini".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      onPressed: () {
                        dialogBlokirAkun(allPenjual!.docs[i].id);
                      },
                    ),
                  )
                ],
              ),
            );
          },
        );
      } else {
        return Center(
          child: const Text(
            "Data tidak ditemukan",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: SimpleAppBar(
        title: "Akun Penjual Terverifikasi",
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: penjualTervefikasiDesign(),
        ),
      ),
    );
  }
}
