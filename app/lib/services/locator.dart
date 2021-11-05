import 'dart:async';

import 'package:florealis/models/gps_point.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/subjects.dart';

class Locator {
  StreamSubscription<GpsPoint> _locatorSub;
  final _positionSubject = BehaviorSubject<GpsPoint>();
  Stream<GpsPoint> get positionStream => _positionSubject.stream;

  bool get isActive => _locatorSub != null;

  void start() {
    if (isActive) return;
    _locatorSub = Geolocator.getPositionStream()
        .map((p) => GpsPoint(p.latitude, p.longitude))
        .listen(_onPosition);
  }

  void stop() async {
    if (!isActive) return;
    await _locatorSub.cancel();
    _locatorSub = null;
  }

  void _onPosition(GpsPoint position) {
    _positionSubject.add(position);
  }
}
