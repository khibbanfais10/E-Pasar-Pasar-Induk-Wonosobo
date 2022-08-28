import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
List<int> penguranganStok = [];
List<String> idBarang = [];
double? ongkir;
double? totalHarga;
String namaPenjual = "";
