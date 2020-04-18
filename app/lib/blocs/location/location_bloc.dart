import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:florealis/models/gps_point.dart';
import 'package:geolocator/geolocator.dart';
import './bloc.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {

  final _locator = Geolocator();


  @override
  LocationState get initialState => UnknownLocationState();

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    if (event is GetLocationEvent) {
      if (state is FetchingLocationState) return;
      yield* _fetchPosition();
    }
  }

  Stream<LocationState> _fetchPosition() async* {
    yield FetchingLocationState();
    try {
      final position = await _locator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high, 
        locationPermissionLevel: GeolocationPermission.locationWhenInUse
      );
      yield KnownLocationState(
        GPSPoint(position.latitude, position.longitude)
      );
      
    } on Exception catch (err) {
      yield ErrorLocationState(err);
    }
  }
}
