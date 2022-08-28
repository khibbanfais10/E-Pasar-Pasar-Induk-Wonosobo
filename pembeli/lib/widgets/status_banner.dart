import 'package:flutter/material.dart';
import 'package:pembeli/mainScreens/home_screen.dart';

class StatusBanner extends StatelessWidget {
  final bool? status;
  final String? statusPesanan;

  StatusBanner({this.status, this.statusPesanan});

  @override
  Widget build(BuildContext context) {
    String? message;
    IconData? iconData;

    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = "Berhasil" : message = "Gagal";
    return Container(
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
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const HomeScreen()));
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            statusPesanan == "selesai"
                ? "Pesanan $message Terkirim"
                : "Pesanan $message",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            radius: 8,
            backgroundColor: Colors.grey,
            child: Center(
                child: Icon(
              iconData,
              color: Colors.white,
              size: 14,
            )),
          )
        ],
      ),
    );
  }
}
