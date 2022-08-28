import 'package:flutter/material.dart';

class Alamat {
  String? nama;
  String? nomorTelepon;
  String? alamatSatu;
  String? alamatDua;
  String? alamatLengkap;
  double? lat;
  double? lng;

  Alamat({
    this.nama,
    this.nomorTelepon,
    this.alamatSatu,
    this.alamatDua,
    this.alamatLengkap,
    this.lat,
    this.lng,
  });

  Alamat.fromJson(Map<String, dynamic> json) {
    nama = json['nama'];
    nomorTelepon = json['nomorTelepon'];
    alamatSatu = json['alamatSatu'];
    alamatDua = json['alamatDua'];
    alamatLengkap = json['alamatLengkap'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['nama'] = nama;
    data['nomorTelepon'] = nomorTelepon;
    data['alamatSatu'] = alamatSatu;
    data['alamatDua'] = alamatDua;
    data['alamatLengkap'] = alamatLengkap;
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
