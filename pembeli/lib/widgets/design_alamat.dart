import 'package:flutter/material.dart';
import 'package:pembeli/assistantMethods/pengubah_alamat.dart';
import 'package:pembeli/mainScreens/layar_pesanan.dart';
import 'package:pembeli/maps/maps.dart';
import 'package:pembeli/models/alamat.dart';
import 'package:provider/provider.dart';

class DesignAlamat extends StatefulWidget {
  final Alamat? model;
  final int? currentIndex;
  final int? value;
  final String? alamatId;
  final double? totalJumlah;
  final String? penjualUID;

  DesignAlamat({
    this.model,
    this.currentIndex,
    this.value,
    this.alamatId,
    this.totalJumlah,
    this.penjualUID,
  });

  @override
  State<DesignAlamat> createState() => _DesignAlamatState();
}

class _DesignAlamatState extends State<DesignAlamat> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<PengubahAlamat>(context, listen: false)
            .tampilkanHasil(widget.value);
      },
      child: Card(
        color: Colors.cyan.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex!,
                  value: widget.value!,
                  activeColor: Colors.amber,
                  onChanged: (val) {
                    Provider.of<PengubahAlamat>(context, listen: false)
                        .tampilkanHasil(val);
                    print(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              const Text(
                                "Nama: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.nama.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "Nomor telepon: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.nomorTelepon.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "Nama: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.nama.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "Alamat 1: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.alamatSatu.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "Alamat 2: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.alamatDua.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            ElevatedButton(
              child: Text("Periksa di Maps"),
              style: ElevatedButton.styleFrom(
                primary: Colors.black54,
              ),
              onPressed: () {
                MapsUtils.bukaMapDenganPosisi(
                    widget.model!.lat!, widget.model!.lng!);
              },
            ),
            widget.value == Provider.of<PengubahAlamat>(context).count
                ? ElevatedButton(
                    child: Text("Pilih"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => LayarPesanan(
                                    alamatID: widget.alamatId,
                                    totalJumlah: widget.totalJumlah,
                                    penjualUID: widget.penjualUID,
                                    latOngkir: widget.model!.lat,
                                    lngOngkir: widget.model!.lng,
                                  )));
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
