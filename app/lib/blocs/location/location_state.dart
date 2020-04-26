import 'package:florealis/models/gps_point.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LocationState {}
  
class UnknownLocationState extends LocationState {}

class FetchingLocationState extends LocationState {}

class ErrorLocationState extends LocationState {
  final Exception error;

  ErrorLocationState(this.error);
}

class KnownLocationState extends LocationState {
  final GpsPoint location;

  KnownLocationState(this.location);
}
