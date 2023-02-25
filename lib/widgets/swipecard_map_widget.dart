import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class SwipeCardMapWdiget extends StatefulWidget {
  double lat;
  double long;
   SwipeCardMapWdiget({Key? key, required this.long, required this.lat}) : super(key: key);

  @override
  State<SwipeCardMapWdiget> createState() => _SwipeCardMapWdigetState();
}

class _SwipeCardMapWdigetState extends State<SwipeCardMapWdiget> {
  @override

  Completer<GoogleMapController> mapController = Completer();
  double distance = 0.0;
  LatLng? location;
  bool viewLocation = false;

  Set<Circle> circles = {};
  void initState() {
    location = LatLng(widget.lat, widget.long);
    circles.add(Circle(
      circleId: const CircleId("id"),
      fillColor: Colors.red.withOpacity(0.3),
      strokeWidth: 0,
      center: LatLng(widget.lat, widget.long),
      radius: 400,
    ));
    super.initState();
  }

  Widget build(BuildContext context) {
    return  Container(
      height: MediaQuery.of(context).size.height /2,
      child: Center(
        child: ClipRRect(
          borderRadius:  BorderRadius.circular(20),
          child: Align(
            alignment: Alignment.center,
            child: GoogleMap(
              circles: circles,
              zoomControlsEnabled: true,
              initialCameraPosition:
              CameraPosition(
                  target: location!,
                  zoom: 13.0),
              mapToolbarEnabled: true,
              mapType: MapType.hybrid,
              onMapCreated: (controller) {
                mapController
                    .complete(controller);

              },
            ),
          ),
        ),
      ),
    );
  }
}
