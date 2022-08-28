import 'package:flutter/material.dart';
import 'package:pembeli/mainScreens/home_screen.dart';
import 'package:pembeli/models/alamat.dart';
import 'package:pembeli/splashScreen/splash_screen.dart';

class DesignPengiriman extends StatelessWidget {
  final Alamat? model;

  DesignPengiriman({this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Detail Pengiriman : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 6.0,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(children: [
                Text(
                  "Nama ",
                  style: TextStyle(color: Colors.black),
                ),
                Text(model!.nama!),
              ]),
              TableRow(children: [
                Text(
                  "Nomor Telepon ",
                  style: TextStyle(color: Colors.black),
                ),
                Text(model!.nomorTelepon!),
              ]),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            model!.alamatSatu! + model!.alamatDua!,
            textAlign: TextAlign.justify,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => MySplashScreen()));
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
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: const Center(
                  child: Text(
                    "Kembali",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
