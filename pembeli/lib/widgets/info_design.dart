import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pembeli/mainScreens/menu_screen.dart';
import 'package:pembeli/models/menu.dart';
import 'package:pembeli/widgets/daftar_menu.dart';
import 'package:pembeli/widgets/progress_bar.dart';
import '../models/sellers.dart';

class SellersDesignWidget extends StatefulWidget {
  Sellers? model;
  BuildContext? context;

  SellersDesignWidget({this.model, this.context});

  @override
  _SellersDesignWidgetState createState() => _SellersDesignWidgetState();
}

class _SellersDesignWidgetState extends State<SellersDesignWidget> {
  // Future<String> ambildata() async {
  //   var data = await FirebaseFirestore.instance
  //       .collection("penjual")
  //       .doc(widget.model!.penjualUID!)
  //       .collection("menu")
  //       .snapshots() as Map<String,dynamic>;

  //   this.setState(() {
  //   Map<String,dynamic> dataJSON = jsonDecode(data);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MenusScreen(
                          model: widget.model,
                          context: widget.context,
                          context2: context,
                        )));
          },
          splashColor: Colors.amber,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 280,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Divider(
                    height: 4,
                    thickness: 3,
                    color: Colors.grey[300],
                  ),
                  Image.network(
                    widget.model!.penjualAvatarUrl!,
                    height: 220.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 1.0,
                  ),
                  Text(
                    widget.model!.penjualName!,
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 20,
                      fontFamily: "Train",
                    ),
                  ),
                  Text(
                    widget.model!.penjualEmail!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  // StreamBuilder<QuerySnapshot>(
                  //   stream: FirebaseFirestore.instance
                  //       .collection("penjual")
                  //       .doc(widget.model!.penjualUID!)
                  //       .collection("menu")
                  //       .snapshots(),
                  //   builder: (context, snapshot) {
                  //     return !snapshot.hasData
                  //         ? SliverToBoxAdapter(
                  //             child: Center(
                  //               child: circularProgress(),
                  //             ),
                  //           )
                  //         : ListView.builder(
                  //             itemBuilder: (context, index) {
                  //               Menu mModel = Menu.fromJson(
                  //                   snapshot.data!.docs[index].data()!
                  //                       as Map<String, dynamic>);

                  //               return daftarMenu(
                  //                 model: mModel,
                  //                 context: context,
                  //               );
                  //             },
                  //             itemCount: snapshot.data!.docs.length,
                  //           );
                  //   },
                  // ),
                  // Text(
                  //  mModel!.menuTitle!,
                  //   style: const TextStyle(
                  //     color: Colors.grey,
                  //     fontSize: 12,
                  //   ),
                  // ),
                  Divider(
                    height: 4,
                    thickness: 3,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
