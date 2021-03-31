import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _lagoa = CameraPosition(
    target: LatLng(double.tryParse("-6.110878"), double.tryParse("106.914229")),
    zoom: 14
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _lagoa,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);

                customGmapController = controller;
              },
              markers: listMarker
                  .map((latlang) => Marker(
                      markerId:
                          MarkerId((latlang.lat + latlang.lng).toString()),
                          position: LatLng(latlang.lat,latlang.lng),
                      draggable: true,
                      infoWindow: InfoWindow(title: latlang.loc),
                      onTap: () async {
                        await customGmapController.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(latlang.lat, latlang.lng),
                                zoom: 25.0)));
                      }))
                  .toSet()),
          Positioned(
              right: 1,
              top: 20,
              child: IconButton(
                  icon: Icon(Icons.zoom_out_map_outlined),
                  onPressed: () {
                    customGmapController
                        .animateCamera(CameraUpdate.zoomTo(5.0));
                  }))
        ],
      ),
    );
  }

  GoogleMapController customGmapController;

  List<CustomLatlng> listMarker = [
    CustomLatlng(
        lat: -6.110888591953592, lng: 106.91716865274364, loc: "Bensu"),
    CustomLatlng(
        lat: -6.108197958212996, lng: 106.90860569361107, loc: "bogasari"),
  ];
}

//modelnya
class CustomLatlng {
  double lat;
  double lng;
  String loc;
  CustomLatlng({this.lat, this.lng, this.loc});
}
