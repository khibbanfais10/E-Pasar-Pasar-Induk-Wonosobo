import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pembeli/global/global.dart';
import 'package:pembeli/models/alamat.dart';
import 'package:pembeli/widgets/simple_app_bar.dart';
import 'package:pembeli/widgets/text_field.dart';

class SaveAddressScreen extends StatelessWidget {
  final _nama = TextEditingController();
  final _nomorTelepon = TextEditingController();
  final _nomorPlat = TextEditingController();
  final _kota = TextEditingController();
  final _negara = TextEditingController();
  final _alamatLengkap = TextEditingController();
  final _locationController = TextEditingController();
  final _flatNumber = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _alamatSatu = TextEditingController();
  final _alamatDua = TextEditingController();
  final _kecamatan = TextEditingController();
  List<Placemark>? placemarks;
  Position? position;

  getUserLocationAddress() async {
    // LocationPermission permission;
    // permission = await Geolocator.requestPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    // }
    // ;

    Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    position = newPosition;

    placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);

    Placemark pMark = placemarks![0];

    String fullAddress =
        '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';
    _locationController.text = fullAddress;

    _flatNumber.text = ' ${pMark.subLocality} ${pMark.locality}';

    _kota.text =
        '${pMark.subAdministrativeArea}, ${pMark.administrativeArea}  ${pMark.postalCode}';

    _negara.text = '${pMark.country}';

    _alamatLengkap.text = fullAddress;

    _alamatSatu.text = '${pMark.subThoroughfare} ${pMark.thoroughfare}';

    _alamatDua.text = '${pMark.subLocality} ${pMark.locality}';

    _kecamatan.text = '${pMark.locality}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Pasar Induk Wonosobo",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Simpan Alamat Baru :",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.person_pin_circle,
                color: Colors.black,
                size: 35,
              ),
              title: Container(
                width: 250,
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: "Alamat",
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            ElevatedButton.icon(
              label: Text(
                "Dapatkan lokasi saya",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              icon: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: Colors.cyan,
                    ),
                  ),
                ),
              ),
              onPressed: () {
                getUserLocationAddress();
              },
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  MyTextField(
                    hint: "Nama",
                    controller: _nama,
                  ),
                  MyTextField(
                    hint: "Nomor Telepon",
                    controller: _nomorTelepon,
                  ),
                  MyTextField(
                    hint: "Alamat 1",
                    controller: _alamatSatu,
                  ),
                  MyTextField(
                    hint: "Alamat 2",
                    controller: _alamatDua,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Simpan"),
        icon: Icon(Icons.check),
        onPressed: () {
          if (formKey.currentState!.validate() &&
              _kecamatan.text == "Kecamatan Wonosobo") {
            final model = Alamat(
              nama: _nama.text.trim(),
              nomorTelepon: _nomorTelepon.text.trim(),
              alamatSatu: _alamatSatu.text.trim(),
              alamatDua: _alamatDua.text.trim(),
              alamatLengkap: _alamatLengkap.text.trim(),
              lat: position!.latitude,
              lng: position!.longitude,
            ).toJson();

            FirebaseFirestore.instance
                .collection("pembeli")
                .doc(sharedPreferences!.getString("uid"))
                .collection("pembeliAlamat")
                .doc(DateTime.now().millisecondsSinceEpoch.toString())
                .set(model)
                .then((value) {
              Fluttertoast.showToast(msg: "Alamat baru disimpan");
              formKey.currentState!.reset();
            });
          } else {
            Fluttertoast.showToast(msg: "Alamat di luar jangkauan");
          }
        },
      ),
    );
  }
}
