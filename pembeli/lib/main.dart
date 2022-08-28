import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:pembeli/assistantMethods/cart_item_counter.dart';
import 'package:pembeli/assistantMethods/pengubah_alamat.dart';
import 'package:pembeli/assistantMethods/total_amount.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global/global.dart';
import 'splashScreen/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartItemCounter()),
        ChangeNotifierProvider(create: (context) => TotalAmount()),
        ChangeNotifierProvider(create: (context) => PengubahAlamat()),
      ],
      child: MaterialApp(
        title: 'Aplikasi Pembeli',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MySplashScreen(),
      ),
    );
  }
}
