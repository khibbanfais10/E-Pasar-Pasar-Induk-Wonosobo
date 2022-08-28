import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  String? menuID;
  String? penjualUID;
  String? menuTitle;
  String? menuInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;

  Menu({
    this.menuID,
    this.penjualUID,
    this.menuTitle,
    this.menuInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.status,
  });

  Menu.fromJson(Map<String, dynamic> json) {
    menuID = json["menuID"];
    penjualUID = json["penjualUID"];
    menuTitle = json["menuTitle"];
    menuInfo = json["menuInfo"];
    publishedDate = json["publishedDate"];
    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["manuID"] = menuID;
    data["penjualUID"] = menuID;
    data["menuTitle"] = menuID;
    data["menuInfo"] = menuID;
    data["publishedDate"] = menuID;
    data["thumbnailUrl"] = menuID;
    data["status"] = menuID;

    return data;
  }
}
