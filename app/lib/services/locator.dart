import 'dart:async';

import 'package:florealis/models/gps_point.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/subjects.dart';

class Locator {
  final _locator = Geolocator();

  StreamSubscription<GpsPoint> _locatorSub;
  final _positionSubject = BehaviorSubject<GpsPoint>();
  Stream<GpsPoint> get positionStream => _positionSubject.stream;

  bool get isActive => _locatorSub != null;

  void start() {
    if (isActive) return;
    _locatorSub = _locator
        .getPositionStream()
        .map((p) => GpsPoint(p.latitude, p.longitude))
        .listen(_onPosition);
  }

  void stop() async {
    await _locatorSub.cancel();
    _locatorSub = null;
  }

  void _onPosition(GpsPoint position) {
    _positionSubject.add(position);
  }
}
