import 'package:florealis/models/gps_point.dart';
import 'package:florealis/services/locator.dart';
import 'package:florealis/ui/location_panel.dart';
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
  }

  void _onMapCreated(MapboxMapController controller) {
    setState(() {
      mapController = controller;
    });
    _locator.start();
  }

  @override
  void dispose() {
    _locator.stop();
    mapController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
            onMapClick: (d, latlon) {
              debugPrint("$d, $latlon");
            },
            onCameraTrackingChanged: (trackingMode) {
              setState(() {
                isTrackingUser = trackingMode == MyLocationTrackingMode.Tracking;
              });
            },
            myLocationTrackingMode: (isTrackingUser && mapController != null)
                ? MyLocationTrackingMode.Tracking
                : MyLocationTrackingMode.None,
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
          if (!isTrackingUser)
            Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background.withOpacity(0.78),
                borderRadius: BorderRadius.circular(9),
              ),
              child: IconButton(
                icon: Icon(Icons.my_location), 
                onPressed: () {
                  setState(() {
                    isTrackingUser = true;
                  });
                }),
            ),
          ),
        ],
      ),
    );
  }
}
