import 'package:florealis/models/gps_point.dart';
import 'package:florealis/services/locator.dart';
import 'package:florealis/ui/location_panel.dart';
import 'package:florealis/extensions/mapbox_extensions.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapPage extends StatefulWidget {
  static const STYLE_URL = 'mapbox://styles/ezamagni/ck5aygdwl2qvk1cofsnbfp6yr';

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with WidgetsBindingObserver {
  static final _initialCameraPosition = CameraPosition(
    target: LatLng(41.902, 12.453),
    zoom: 4.8,
  );

  final _locator = Locator();
  MapboxMapController mapController;
  GpsPoint userLocation;

  bool isTrackingUser = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _locator.positionStream.listen(_onPosition);
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController.addListener(_onMapChanged);
    _locator.start();
  }

  @override
  void dispose() {
    _locator.stop();
    mapController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onMapChanged() {
    // setState(() {
    // });
    print(mapController);
  }

  void _onPosition(GpsPoint position) {
    if (isTrackingUser) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(position.latlng, 13.4),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _locator.start();
    } else {
      _locator.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          MapboxMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialCameraPosition,
            styleString: MapPage.STYLE_URL,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            myLocationEnabled: true,
            myLocationTrackingMode: isTrackingUser
                ? MyLocationTrackingMode.TrackingGPS
                : MyLocationTrackingMode.Tracking,
            myLocationRenderMode: MyLocationRenderMode.NORMAL,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: StreamBuilder<GpsPoint>(
              stream: _locator.positionStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: LocationPanel.location(snapshot.data),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
