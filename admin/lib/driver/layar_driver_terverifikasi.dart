import 'package:admin/mainScreen/home_screen.dart';
import 'package:admin/widgets/simple_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LayarDriverTerverifikasi extends StatefulWidget {
  const LayarDriverTerverifikasi({Key? key}) : super(key: key);

  @override
  State<LayarDriverTerverifikasi> createState() =>
      _LayarDriverTerverifikasiState();
}

class _LayarDriverTerverifikasiState extends State<LayarDriverTerverifikasi> {
  QuerySnapshot? allDriver;

  dialogBlokirAkun(dokumenIddriver) {
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
                      .collection("driver")
                      .doc(dokumenIddriver)
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
        .collection("driver")
        .where("status", isEqualTo: "approved")
        .get()
        .then((approvedPembeli) {
      setState(() {
        allDriver = approvedPembeli;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget driverTervefikasiDesign() {
      if (allDriver != null) {
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: allDriver!.docs.length,
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
                                  allDriver!.docs[i].get("driverAvatarUrl")),
                              fit: BoxFit.fill,
                            )),
                      ),
                      title: Text(
                        allDriver!.docs[i].get("driverName"),
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
                            allDriver!.docs[i].get("driverEmail"),
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
                        dialogBlokirAkun(allDriver!.docs[i].id);
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
        title: "Akun Driver Terverifikasi",
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: driverTervefikasiDesign(),
        ),
      ),
    );
  }
}
