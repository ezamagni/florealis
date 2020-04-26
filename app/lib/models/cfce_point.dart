import 'package:florealis/models/gps_point.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'dart:math';

// see https://en.wikipedia.org/wiki/ED50
// see http://www.floravenagesso.it/romagna/Cartografia.htm

class CfcePoint extends Equatable {

  // grid
  final int lat;
  final int lon;

  // quad
  final List<int> quads;

  const CfcePoint(this.lat, this.lon, [this.quads = const []])
  : assert(lat != null && lon != null && quads != null);

  @override
  List<Object> get props => [lat, lon, quads];

  @visibleForTesting
  static const origin = GpsPoint(56, 17/3);

  factory CfcePoint.from(GpsPoint gpsPoint, {int precision = 2}) {
    assert(precision >= 0);
    
    // latitude extension of the CFCE grid expressed in decimals
    const gridLatDec = 0.1; // 6'
    // longitude extension of the CFCE grid expressed in decimals
    const gridLonDec = 1/6; // 10'

    final refDec = GpsPoint(
      origin.lat - gpsPoint.lat, 
      gpsPoint.lon - origin.lon
    );
    final latDec = refDec.lat / gridLatDec;
    final lonDec = refDec.lon / gridLonDec;

    final quads = List<int>
      .generate(precision, (i) => i + 1)
      .map((i) => _quadrantOf(latDec, lonDec, i))
      .toList();
    return CfcePoint(latDec.floor(), lonDec.floor(), quads);
  }

  static int _quadrantOf(double lat, double lon, int level) {
    assert(level >= 1);
    final div = pow(0.5, level - 1);
    final latr = lat.remainder(div);
    final lonr = lon.remainder(div);
    return (latr < div / 2 ? 1 : 3)
      + (lonr < div / 2 ? 0 : 1);
  }

  @override
  String toString() {
    if (quads.isEmpty)
      return "$lat$lon";
    else
      return "$lat$lon/" + quads.map((q) => "$q").join();
  }
}