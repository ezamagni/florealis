import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  
  MapboxMapController mapController;


  // void onMapCreated(MapboxMapController controller) {
  //   mapController = controller;
  //   mapController.addListener(_onMapChanged);
  //   _extractMapInfo();

  //   mapController.getTelemetryEnabled().then((isEnabled) =>
  //       setState(() {
  //         _telemetryEnabled = isEnabled;
  //       }));
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
  
}