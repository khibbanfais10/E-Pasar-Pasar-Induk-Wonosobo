import 'package:flutter/material.dart';
import 'package:pembeli/models/items.dart';

class CartItemDesign extends StatefulWidget {
  final Barang? model;
  BuildContext? context;
  final int? quanNumber;

  CartItemDesign({
    this.model,
    this.context,
    this.quanNumber,
  });

  @override
  State<CartItemDesign> createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.cyan,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          height: 120,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Image.network(
                widget.model!.thumbnailUrl!,
                width: 140,
                height: 120,
              ),
              const SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.model!.title!,
                    style: TextStyle(
                        color: Colors.black, fontSize: 16, fontFamily: "Kiwi"),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Row(
                    children: [
                      Text(
                        "x ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "Acme"),
                      ),
                      Text(
                        widget.quanNumber!.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "Acme"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Harga : ",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontFamily: "Acme"),
                      ),
                      const Text(
                        "Rp. ",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: "Acme"),
                      ),
                      Text(
                        widget.model!.price.toString(),
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: "Acme"),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
