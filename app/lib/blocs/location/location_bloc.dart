import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:florealis/models/gps_point.dart';
import 'package:geolocator/geolocator.dart';
import './bloc.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  static const ACCURACY = LocationAccuracy.high;

  final _locator = Geolocator();
  StreamSubscription<Position> _positionSub;

  @override
  LocationState get initialState => UnknownLocationState();

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    if (event is GetLocationEvent) {
      if (state is FetchingLocationState) return;
      yield* _fetchSinglePosition();
    } else if (event is StartTrackPositionEvent) {
      await _positionSub?.cancel();
      final positionStream = _locator.getPositionStream(
        LocationOptions(accuracy: ACCURACY),
        GeolocationPermission.locationWhenInUse,
      ).asBroadcastStream();
      this.
      _positionSub = positionStream.listen(null);
      yield* positionStream.map((position) => KnownLocationState(
            GpsPoint(position.latitude, position.longitude),
          ));
    } else if (event is StopTrackPositionEvent) {
      await _positionSub?.cancel();
    }
  }

  Stream<LocationState> _fetchSinglePosition() async* {
    yield FetchingLocationState();
    try {
      var position = await _locator.getLastKnownPosition(
        desiredAccuracy: ACCURACY,
        locationPermissionLevel: GeolocationPermission.locationWhenInUse,
      );
      if (position == null) {
        position = await _locator.getCurrentPosition(
            desiredAccuracy: ACCURACY,
            locationPermissionLevel: GeolocationPermission.locationWhenInUse);
      }
      yield KnownLocationState(
        GpsPoint(position.latitude, position.longitude),
      );
    } on Exception catch (err) {
      yield ErrorLocationState(err);
    }
  }
}
