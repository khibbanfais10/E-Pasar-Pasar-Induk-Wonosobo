import 'package:flutter/cupertino.dart';
import 'package:pembeli/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItemCounter extends ChangeNotifier {
  int cartListItemCounter =
      sharedPreferences!.getStringList("pembeliCart")!.length - 1;
  int get count => cartListItemCounter;

  Future<void> displayCartListItemsNumber() async {
    cartListItemCounter =
        sharedPreferences!.getStringList("pembeliCart")!.length - 1;

    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
