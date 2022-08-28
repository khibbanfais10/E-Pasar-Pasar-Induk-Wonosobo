import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pembeli/assistantMethods/cart_item_counter.dart';
import 'package:pembeli/global/global.dart';
import 'package:pembeli/splashScreen/splash_screen.dart';
import 'package:provider/provider.dart';

separateOrderItemIDs(pesananIDs) {
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
  idBarang = separateItemIDsList.toList();
  return separateItemIDsList;
}

addItemToCart(String? foodItemId, BuildContext context, int itemCounter) {
  List<String>? tempList = sharedPreferences!.getStringList("pembeliCart");
  tempList!.add(foodItemId! + ":$itemCounter");

  FirebaseFirestore.instance
      .collection("pembeli")
      .doc(firebaseAuth.currentUser!.uid)
      .update({
    "pembeliCart": tempList,
  }).then((value) {
    Fluttertoast.showToast(msg: "Barang Ditambahkan");
    sharedPreferences!.setStringList("pembeliCart", tempList);

    Provider.of<CartItemCounter>(context, listen: false)
        .displayCartListItemsNumber();
  });
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
    // penguranganStok.add(separateItemQuantityList);
    separateItemQuantityList.add(quanNumber);
  }
  print("\nIni adalah Jumlah Daftar sekarang = ");
  print(separateItemQuantityList);
  penguranganStok = separateItemQuantityList.toList();

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

    Provider.of<CartItemCounter>(context, listen: false)
        .displayCartListItemsNumber();
  });
}
