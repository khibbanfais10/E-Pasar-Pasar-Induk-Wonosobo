import 'package:url_launcher/url_launcher.dart';

class MapsUtils {
  MapsUtils._();

  static Future<void> bukaMapDenganPosisi(
      double latitude, double longitude) async {
    Uri googleMapUrl = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl);
    } else {
      throw "Tidak bisa membuka Maps.";
    }
  }

  static Future<void> bukaMapDenganAlamat(String alamatLengkap) async {
    String query = Uri.encodeComponent(alamatLengkap);
    Uri googleMapUrl =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl);
    } else {
      throw "Tidak bisa membuka Maps.";
    }
  }
}
