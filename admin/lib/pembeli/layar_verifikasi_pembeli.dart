import 'package:admin/mainScreen/home_screen.dart';
import 'package:admin/widgets/simple_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LayarVerifikasiPembeli extends StatefulWidget {
  const LayarVerifikasiPembeli({Key? key}) : super(key: key);

  @override
  State<LayarVerifikasiPembeli> createState() => _LayarVerifikasiPembeliState();
}

class _LayarVerifikasiPembeliState extends State<LayarVerifikasiPembeli> {
  QuerySnapshot? allPembeli;

  dialogBlokirAkun(dokumenIdPembeli) {
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
                  Map<String, dynamic> pembeliDataMap = {
                    "status": "not approved",
                  };
                  FirebaseFirestore.instance
                      .collection("pembeli")
                      .doc(dokumenIdPembeli)
                      .update(pembeliDataMap)
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
        .collection("pembeli")
        .where("status", isEqualTo: "approved")
        .get()
        .then((approvedPembeli) {
      setState(() {
        allPembeli = approvedPembeli;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget pembeliTervefikasiDesign() {
      if (allPembeli != null) {
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: allPembeli!.docs.length,
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
                                  allPembeli!.docs[i].get("photoUrl")),
                              fit: BoxFit.fill,
                            )),
                      ),
                      title: Text(
                        allPembeli!.docs[i].get("name"),
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
                            allPembeli!.docs[i].get("email"),
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
                        "Block Akun Ini".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      onPressed: () {
                        dialogBlokirAkun(allPembeli!.docs[i].id);
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
        title: "Akun Pembeli Terverifikasi",
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: pembeliTervefikasiDesign(),
        ),
      ),
    );
  }
}
