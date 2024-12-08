import 'package:fire/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider with ChangeNotifier {
  LatLng selectedlocation = const LatLng(33.3232, -213.3343);
  String address = "";
  LatLng get _selectlocation => selectedlocation;
  String get _address => address;

  void updateLocation(LatLng newlocation) {
    selectedlocation = newlocation;
    notifyListeners();
  }

  Future<void> getAddress(LatLng posistion) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          posistion.latitude, posistion.longitude);
      Placemark place = placemarks.first;
      address = "${place.street}, ${place.locality}, ${place.country}";
      notifyListeners();
    } catch (e) {
      Utilred().fluttertoastmessage(
          "There is some error fetching the location!!! $e");
    }
  }
}
