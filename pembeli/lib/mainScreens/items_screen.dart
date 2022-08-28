import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pembeli/global/global.dart';
import 'package:pembeli/models/items.dart';
import 'package:pembeli/models/menu.dart';
import 'package:pembeli/models/sellers.dart';
import 'package:pembeli/widgets/app_bar.dart';
import 'package:pembeli/widgets/info_design.dart';
import 'package:pembeli/widgets/items_design.dart';
import 'package:pembeli/widgets/my_drawer.dart';
import 'package:pembeli/widgets/progress_bar.dart';
import 'package:pembeli/widgets/text_widget.dart';
import '../authentication/auth_screen.dart';

class ItemsScreen extends StatefulWidget {
  final Menu? model;
  Sellers? sModel;
  BuildContext? bContext;
  ItemsScreen({this.model, this.sModel, this.bContext});

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(penjualUID: widget.model!.penjualUID),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate:
                  TextWidgetheader(title: widget.model!.menuTitle.toString())),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("penjual")
                .doc(widget.model!.penjualUID)
                .collection("menu")
                .doc(widget.model!.menuID)
                .collection("barang")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(child: circularProgress()),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        Barang model = Barang.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        return ItemsDesignWidget(
                          model: model,
                          context: context,
                          bContext: widget.bContext,
                          sModel: widget.sModel,
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
            },
          )
        ],
      ),
    );
  }
}
