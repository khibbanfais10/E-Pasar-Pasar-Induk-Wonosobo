import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter/cupertino.dart';

class PengubahAlamat extends ChangeNotifier {
  int _counter = 0;
  int get count => _counter;

  tampilkanHasil(dynamic newValue) {
    _counter = newValue;
    notifyListeners();
  }
}
