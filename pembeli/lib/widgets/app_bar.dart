import 'package:flutter/material.dart';
import 'package:pembeli/assistantMethods/cart_item_counter.dart';
import 'package:pembeli/mainScreens/cart_screen.dart';
import 'package:pembeli/models/sellers.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  final String? penjualUID;
  Sellers? sModel;
  BuildContext? bContext;
  MyAppBar({this.bottom, this.penjualUID, this.sModel, this.bContext});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
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
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "Pasar Induk Wonosobo",
        style: const TextStyle(fontSize: 30, fontFamily: "Signatra"),
      ),
      centerTitle: true,
      automaticallyImplyLeading: true,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CartScreen(
                              penjualUID: widget.penjualUID,
                              sModel: widget.sModel,
                              bContext: widget.bContext,
                            )));
              },
            ),
            Positioned(
              child: Stack(children: [
                const Icon(
                  Icons.brightness_1,
                  size: 20,
                  color: Colors.green,
                ),
                Positioned(
                  top: 3,
                  right: 4,
                  child: Center(
                    child: Consumer<CartItemCounter>(
                      builder: (context, counter, c) {
                        return Text(
                          counter.count.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        );
                      },
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ],
    );
  }
}
