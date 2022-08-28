import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:penjual/global/global.dart';
import 'package:penjual/model/items.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
import 'package:penjual/model/menu.dart';

import '../widgets/error_dialog.dart';

class LayarEditBarang extends StatefulWidget {
  Barang? model;
  String? thumbnail;
  String? deskripsi;
  int? harga;
  String? judul;
  String? itemID;
  String? shortInfo;
  int? stok;
  String? menuId;
  LayarEditBarang(
      {this.model,
      this.thumbnail,
      this.deskripsi,
      this.harga,
      this.judul,
      this.itemID,
      this.shortInfo,
      this.stok,
      this.menuId});

  @override
  State<LayarEditBarang> createState() => _LayarEditBarangState();
}

class _LayarEditBarangState extends State<LayarEditBarang> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stokController = TextEditingController();

  bool uploading = false;

  captureImageWithCamera() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              "Gambar Menu",
              style:
                  TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Ambil dengan kamera",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Ambil dari gallery",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  clearMenusUploadForm() {
    shortInfoController.clear();
    titleController.clear();
    priceController.clear();
    descriptionController.clear();
    stokController.clear();
    imageXFile = null;
  }

  validateUploadForm() async {
    if (imageXFile != null) {
      if (shortInfoController.text.isNotEmpty &&
          titleController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          priceController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });

        String downloadUrl =
            // widget.thumbnail!;
            await uploadImage(File(imageXFile!.path));

        saveInfo(downloadUrl, widget.itemID!);
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Harap masukkan nama dan informasi menu.",
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Harap pilih gambar untuk menu.",
            );
          });
    }
  }

  saveInfo(String downloadUrl, String itemID) {
    final ref = FirebaseFirestore.instance
        .collection("penjual")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menu")
        .doc(widget.menuId)
        .collection("barang");

    ref.doc(itemID).update({
      // "itemID": widget.itemID,
      // "menuID": widget.menuId,
      // "penjualUID": sharedPreferences!.getString("uid"),
      // "penjualName": sharedPreferences!.getString("name"),
      "shortInfo": shortInfoController.text.toString(),
      "longDescription": descriptionController.text.toString(),
      "price": int.parse(priceController.text),
      "title": titleController.text.toString(),
      // "publishedDate": DateTime.now(),
      // "stok": int.parse(stokController.text),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    }).then((value) {
      final itemsRef = FirebaseFirestore.instance.collection("barang");
      itemsRef.doc(itemID).update({
        // "itemID": widget.itemID,
        // "menuID": widget.menuId,
        // "penjualUID": sharedPreferences!.getString("uid"),
        // "penjualName": sharedPreferences!.getString("name"),
        "shortInfo": shortInfoController.text.toString(),
        "longDescription": descriptionController.text.toString(),
        "price": int.parse(priceController.text),
        // "stok": int.parse(stokController.text),
        "title": titleController.text.toString(),
        // "publishedDate": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrl,
      });
    }).then((value) {
      clearMenusUploadForm();
      setState(() {
        uploading = false;
      });
    });
  }

  // saveInfoShortInfo(String downloadUrl, String itemID) {
  //   final ref = FirebaseFirestore.instance
  //       .collection("penjual")
  //       .doc(sharedPreferences!.getString("uid"))
  //       .collection("menu")
  //       .doc(widget.model!.menuID)
  //       .collection("barang");

  //   ref.doc(itemID).update({
  //     "itemID": widget.itemID,
  //     "menuID": widget.model!.menuID,
  //     "penjualUID": sharedPreferences!.getString("uid"),
  //     "penjualName": sharedPreferences!.getString("name"),
  //     "shortInfo": widget.shortInfo,
  //     "longDescription": descriptionController.text.toString(),
  //     "price": int.parse(priceController.text),
  //     "title": titleController.text.toString(),
  //     "publishedDate": DateTime.now(),
  //     "stok": int.parse(stokController.text),
  //     "status": "available",
  //     "thumbnailUrl": downloadUrl,
  //   }).then((value) {
  //     final itemsRef = FirebaseFirestore.instance.collection("barang");
  //     itemsRef.doc(itemID).update({
  //       "itemID": widget.itemID,
  //       "menuID": widget.model!.menuID,
  //       "penjualUID": sharedPreferences!.getString("uid"),
  //       "penjualName": sharedPreferences!.getString("name"),
  //       "shortInfo": widget.shortInfo,
  //       "longDescription": descriptionController.text.toString(),
  //       "price": int.parse(priceController.text),
  //       "stok": int.parse(stokController.text),
  //       "title": titleController.text.toString(),
  //       "publishedDate": DateTime.now(),
  //       "status": "available",
  //       "thumbnailUrl": downloadUrl,
  //     });
  //   }).then((value) {
  //     clearMenusUploadForm();
  //     setState(() {
  //       uploading = false;
  //     });
  //   });
  // }

  uploadImage(mImageFile) async {
    storageRef.Reference reference =
        storageRef.FirebaseStorage.instance.ref().child("barang");

    storageRef.UploadTask uploadTask =
        reference.child(widget.itemID! + ".jpg").putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
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
        title: const Text(
          "Edit Barang",
          style: TextStyle(fontSize: 20, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            clearMenusUploadForm();
            Fluttertoast.showToast(msg: "pesanan berhasil diubah");
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              "Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                fontFamily: "Varela",
                letterSpacing: 1,
              ),
            ),
            onPressed: uploading ? null : () => validateUploadForm(),
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: GestureDetector(
                  onTap: () {
                    takeImage(context);
                  },
                  child: Image.network(
                    widget.thumbnail!,
                    fit: BoxFit.cover,
                    width: 110,
                    height: 110,
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.perm_device_information,
              color: Colors.cyan,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  hintText: "info barang",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.cyan,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "nama barang",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.description,
              color: Colors.cyan,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "keterangan",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.money_rounded,
              color: Colors.cyan,
            ),
            title: Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                controller: priceController,
                decoration: const InputDecoration(
                  hintText: "harga",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          // const Divider(
          //   color: Colors.black,
          //   thickness: 1,
          // ),
          // const Divider(
          //   color: Colors.black,
          //   thickness: 1,
          // ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.title,
          //     color: Colors.cyan,
          //   ),
          // title: Container(
          //   width: 250,
          //   child: TextField(
          //     style: const TextStyle(color: Colors.black),
          //     controller: stokController,
          //     decoration: const InputDecoration(
          //       hintText: "stok barang",
          //       hintStyle: TextStyle(color: Colors.grey),
          //       border: InputBorder.none,
          //     ),
          //   ),
          // ),
          // ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
