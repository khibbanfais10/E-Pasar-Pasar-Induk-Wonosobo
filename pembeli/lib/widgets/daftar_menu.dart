import 'package:flutter/material.dart';
import 'package:pembeli/models/menu.dart';

class daftarMenu extends StatelessWidget {
  Menu? model;
  BuildContext? context;

  daftarMenu({this.context, this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        model!.menuTitle!,
        style: const TextStyle(
          color: Colors.cyan,
          fontSize: 20,
          fontFamily: "Train",
        ),
      ),
    );
  }
}
