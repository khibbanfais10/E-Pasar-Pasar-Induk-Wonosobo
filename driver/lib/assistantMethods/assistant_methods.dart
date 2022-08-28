import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/global/global.dart';
import 'package:flutter/material.dart';

separateOrderItemIDS(pesananIDs) {
  List<String> separateItemIDsList = [], defaulItemList = [];
  int i = 0;

  defaulItemList = List<String>.from(pesananIDs);

  for (i; i < defaulItemList.length; i++) {
    String item = defaulItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    print("\nIni adalah itemID sekarang = " + getItemId);

    separateItemIDsList.add(getItemId);
  }
  print("\nIni adalah Daftar Barang sekarang = ");
  print(separateItemIDsList);

  return separateItemIDsList;
}

separateItemIDs() {
  List<String> separateItemIDsList = [], defaulItemList = [];
  int i = 0;

  defaulItemList = sharedPreferences!.getStringList("pembeliCart")!;

  for (i; i < defaulItemList.length; i++) {
    String item = defaulItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    print("\nIni adalah itemID sekarang = " + getItemId);

    separateItemIDsList.add(getItemId);
  }
  print("\nIni adalah Daftar Barang sekarang = ");
  print(separateItemIDsList);

  return separateItemIDsList;
}

separateOrderItemQuantities(pesananIDs) {
  List<String> separateItemQuantityList = [];
  List<String> defaulItemList = [];
  int i = 1;

  defaulItemList = List<String>.from(pesananIDs);

  for (i; i < defaulItemList.length; i++) {
    String item = defaulItemList[i].toString();

    List<String> listItemCharacters = item.split(":").toList();

    var quanNumber = int.parse(listItemCharacters[1].toString());

    print("\nIni adalah Jumlah barang = " + quanNumber.toString());

    separateItemQuantityList.add(quanNumber.toString());
  }
  print("\nIni adalah Jumlah Daftar sekarang = ");
  print(separateItemQuantityList);

  return separateItemQuantityList;
}

separateItemQuantities() {
  List<int> separateItemQuantityList = [];
  List<String> defaulItemList = [];
  int i = 1;

  defaulItemList = sharedPreferences!.getStringList("pembeliCart")!;

  for (i; i < defaulItemList.length; i++) {
    String item = defaulItemList[i].toString();

    List<String> listItemCharacters = item.split(":").toList();

    var quanNumber = int.parse(listItemCharacters[1].toString());

    print("\nIni adalah Jumlah barang = " + quanNumber.toString());

    separateItemQuantityList.add(quanNumber);
  }
  print("\nIni adalah Jumlah Daftar sekarang = ");
  print(separateItemQuantityList);

  return separateItemQuantityList;
}

clearCartNow(context) {
  sharedPreferences!.setStringList("pembeliCart", ['sementaraCart']);
  List<String>? emptyList = sharedPreferences!.getStringList("pembeliCart");

  FirebaseFirestore.instance
      .collection("pembeli")
      .doc(firebaseAuth.currentUser!.uid)
      .update({"pembeliCart": emptyList}).then((value) {
    sharedPreferences!.setStringList("userCart", emptyList!);
  });
}
