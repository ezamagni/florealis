import 'package:meta/meta.dart';

@immutable
abstract class LocationEvent {}

class GetLocationEvent extends LocationEvent {}

class StartTrackPositionEvent extends LocationEvent {}

class StopTrackPositionEvent extends LocationEvent {}