import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pembeli/assistantMethods/assistant_methods.dart';
import 'package:pembeli/global/global.dart';
import 'package:pembeli/mainScreens/home_screen.dart';
import 'package:pembeli/models/menu.dart';
import 'package:pembeli/models/sellers.dart';
import 'package:pembeli/splashScreen/splash_screen.dart';
import 'package:pembeli/widgets/info_design.dart';
import 'package:pembeli/widgets/menu_design.dart';
import 'package:pembeli/widgets/my_drawer.dart';
import 'package:pembeli/widgets/progress_bar.dart';
import 'package:pembeli/widgets/text_widget.dart';
import '../authentication/auth_screen.dart';

class MenusScreen extends StatefulWidget {
  Sellers? model;
  BuildContext? context;
  BuildContext? context2;
  MenusScreen({this.model, this.context, this.context2});

  @override
  _MenusScreenState createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // clearCartNow(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        title: const Text(
          "Pasar Induk Wonosobo",
          style: TextStyle(fontSize: 30, fontFamily: "Signatra"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetheader(
                title: "Menu " + widget.model!.penjualName.toString(),
              )),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("penjual")
                .doc(widget.model!.penjualUID)
                .collection("menu")
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
                        Menu model = Menu.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        return MenusDesignWidget(
                          model: model,
                          context: context,
                          sModel: widget.model,
                          bContext: widget.context,
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
