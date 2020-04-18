import 'package:equatable/equatable.dart';

class GPSPoint extends Equatable {

  /// The latitude of this position in degrees normalized to the interval -90.0 to +90.0 (both inclusive).
  final double lat;

  /// The longitude of the position in degrees normalized to the interval -180 (exclusive) to +180 (inclusive).
  final double lon;

  const GPSPoint(this.lat, this.lon)
  : assert(lat != null && lon != null);

  @override
  List<Object> get props => [lat, lon];

  @override
  String toString() => "${lat.toStringAsFixed(6)} ${lon.toStringAsFixed(6)}";
}