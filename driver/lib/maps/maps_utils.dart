import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MapUtils {
  MapUtils._();

  static void BukaMapKeLokasi(
      sourceLat, sourceLng, destinationLat, destinationLng) async {
    String mapOptions = [
      'saddr=$sourceLat,$sourceLng',
      'daddr=$destinationLat,$destinationLng',
      'dir_action=navigate',
    ].join('&');

    final Uri mapUrl = Uri.parse("https://www.google.com/maps?$mapOptions");

    if (await launchUrlString("https://www.google.com/maps?$mapOptions",
        mode: LaunchMode.externalApplication)) {
      await launchUrlString("https://www.google.com/maps?$mapOptions",
          mode: LaunchMode.externalApplication);
    } else {
      throw "Tidak bisa membuka url $mapUrl";
    }
  }
}
