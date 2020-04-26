import 'package:florealis/models/gps_point.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

extension ModelToMapBox on GpsPoint {
  LatLng get latlng => LatLng(lat, lon);
}

extension MapBoxToModel on LatLng {
  GpsPoint get gpsPoint => GpsPoint(latitude, longitude);
}