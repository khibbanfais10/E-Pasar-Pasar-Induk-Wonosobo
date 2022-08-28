import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pembeli/assistantMethods/assistant_methods.dart';
import 'package:pembeli/assistantMethods/cart_item_counter.dart';
import 'package:pembeli/assistantMethods/total_amount.dart';
import 'package:pembeli/global/global.dart';
import 'package:pembeli/main.dart';
import 'package:pembeli/mainScreens/address_screen.dart';
import 'package:pembeli/mainScreens/menu_screen.dart';
import 'package:pembeli/models/items.dart';
import 'package:pembeli/models/sellers.dart';
import 'package:pembeli/splashScreen/splash_screen.dart';
import 'package:pembeli/widgets/app_bar.dart';
import 'package:pembeli/widgets/cart_item_design.dart';
import 'package:pembeli/widgets/info_design.dart';
import 'package:pembeli/widgets/progress_bar.dart';
import 'package:pembeli/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final String? penjualUID;
  Sellers? sModel;
  BuildContext? bContext;
  CartScreen({this.penjualUID, this.sModel, this.bContext});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? separateItemQuantityList;
  num totalAmount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);

    separateItemQuantityList = separateItemQuantities();
  }

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
          icon: Icon(Icons.add),
          onPressed: () {
            context;
            MaterialPageRoute(
                builder: (context) => MenusScreen(
                      model: widget.sModel,
                      context: widget.bContext,
                    ));
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
                  print("clicked");
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
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            width: 10,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn1",
              label: const Text("Bersihkan", style: TextStyle(fontSize: 16)),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                clearCartNow(context);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MySplashScreen()));

                Fluttertoast.showToast(msg: "Keranjang dibersihkan");
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              label: const Text(
                "Bayar ",
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.navigate_next),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => AddressScreen(
                      totalAmount: totalAmount.toDouble(),
                      penjualUID: widget.penjualUID,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true, delegate: TextWidgetheader(title: "Keranjang")),
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
                builder: (context, amountProvider, cartProvider, c) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: cartProvider.count == 0
                      ? Container()
                      : Text(
                          "Total harga : Rp. ${amountProvider.tAmount.toString()}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              );
            }),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("barang")
                .where("itemID", whereIn: separateItemIDs())
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : snapshot.data!.docs.length == 0
                      ? Container()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              Barang model = Barang.fromJson(
                                snapshot.data!.docs[index].data()!
                                    as Map<String, dynamic>,
                              );

                              if (index == 0) {
                                totalAmount = 0;
                                totalAmount = totalAmount +
                                    (model.price! *
                                        separateItemQuantityList![index]);
                              } else {
                                totalAmount = totalAmount +
                                    (model.price! *
                                        separateItemQuantityList![index]);
                              }

                              if (snapshot.data!.docs.length - 1 == index) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  Provider.of<TotalAmount>(context,
                                          listen: false)
                                      .displayTotalAmount(
                                          totalAmount.toDouble());
                                });
                              }

                              return CartItemDesign(
                                model: model,
                                context: context,
                                quanNumber: separateItemQuantityList![index],
                              );
                            },
                            childCount: snapshot.hasData
                                ? snapshot.data!.docs.length
                                : 0,
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }
}
