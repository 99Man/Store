import 'package:fire/provider/map_provider.dart';
import 'package:fire/utils/text.dart';
import 'package:fire/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  @override
  Widget build(BuildContext context) {
    final locaiton = Provider.of<MapProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pick Location"),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context, locaiton.address);
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: (controller) {},
              initialCameraPosition:
                  CameraPosition(zoom: 15, target: locaiton.selectedlocation),
              markers: {
                Marker(
                    markerId: const MarkerId("selected-location"),
                    position: locaiton.selectedlocation),
              },
              onTap: (LatLng posistion) async {
                locaiton.updateLocation(posistion);
                await locaiton.getAddress(posistion);
              },
            ),
            if (locaiton.address.isNotEmpty)
              Positioned(
                  child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.white,
                child:
                    text(locaiton.address, 18, Colors.black, FontWeight.w600),
              ))
          ],
        ));
  }
}
