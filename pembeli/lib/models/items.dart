import 'package:cloud_firestore/cloud_firestore.dart';

class Barang {
  String? menuID;
  String? penjualUID;
  String? itemID;
  String? title;
  String? shortInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? longDescription;
  String? status;
  int? price;
  int? stok;
  int? jumlahTotal;
  int? ongkir;

  Barang(
      {this.menuID,
      this.penjualUID,
      this.itemID,
      this.title,
      this.shortInfo,
      this.publishedDate,
      this.thumbnailUrl,
      this.longDescription,
      this.status,
      this.price,
      this.stok,
      this.jumlahTotal,
      this.ongkir});

  Barang.fromJson(Map<String, dynamic> json) {
    menuID = json['menuId'];
    penjualUID = json['penjualUID'];
    itemID = json['itemID'];
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['longDescription'];
    status = json['status'];
    price = json['price'];
    stok = json['stok'];
    jumlahTotal = json['jumlahTotal'];
    ongkir = json['ongkir'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['menuID'] = menuID;
    data['penjualUID'] = penjualUID;
    data['itemID'] = itemID;
    data['title'] = title;
    data['shortInfo'] = shortInfo;
    data['price'] = price;
    data['publishedDate'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['longDescription'] = longDescription;
    data['status'] = status;
    data['stok'] = stok;
    data['jumlahTotal'] = jumlahTotal;
    data['ongkir'] = ongkir;

    return data;
  }
}
