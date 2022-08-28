import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:penjual/global/global.dart';
import 'package:penjual/model/items.dart';
import 'package:penjual/model/menu.dart';
import 'package:penjual/uploadScreens/items_upload_screen.dart';
import 'package:penjual/widgets/items_design.dart';
import 'package:penjual/widgets/my_drawer.dart';
import 'package:penjual/widgets/text_widget.dart';

import '../uploadScreens/menus_upload_screen.dart';
import '../widgets/info_design.dart';
import '../widgets/progress_bar.dart';

class ItemsScreen extends StatefulWidget {
  final Menu? model;
  ItemsScreen({this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          title: Text(
            sharedPreferences!.getString("name")!,
            style: const TextStyle(fontSize: 30, fontFamily: "Lobster"),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.library_add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ItemsUploadScreen(model: widget.model)));
              },
            ),
          ]),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate:
                TextWidgetheader(title: widget.model!.menuTitle.toString()),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("penjual")
                .doc(sharedPreferences!.getString("uid"))
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
                          menuID: widget.model!.menuID,
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
