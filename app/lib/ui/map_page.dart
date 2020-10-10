import 'package:florealis/extensions/mapbox_extensions.dart';
import 'package:florealis/models/gps_point.dart';
import 'package:florealis/services/locator.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'location_panel.dart';
import 'location_popup.dart';

class MapPage extends StatefulWidget {
  static const STYLE_URL = 'mapbox://styles/ezamagni/ck5aygdwl2qvk1cofsnbfp6yr';

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with WidgetsBindingObserver {
  final _locator = Locator();
  MapboxMapController mapController;
  GpsPoint customLocation;

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
    _onStyleLoaded();
  }

  void _onStyleLoaded() {
    // Adds an asset image to the currently displayed style
    rootBundle.load('assets/images/crosshair.png').then((data) {
      final bytes = data.buffer.asUint8List();
      mapController.addImage('crosshair', bytes);
    });
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
          _buildMap(context),
          _buildTopPanel(context),
          if (!isTrackingUser) _buildTrackButton(context),
          if (customLocation != null) _buildBottomPanel(context),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return FutureBuilder<String>(
      future: rootBundle.loadString('assets/.mb_token', cache: true),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MapboxMap(
            accessToken: snapshot.data,
            onMapCreated: _onMapCreated,
            // onStyleLoadedCallback: _onStyleLoaded,
            initialCameraPosition: const CameraPosition(
              target: LatLng(41.902, 12.453),
              zoom: 4.8,
            ),
            styleString: MapPage.STYLE_URL,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            myLocationEnabled: true,
            onMapClick: (d, latlon) {
              if (mapController.symbols.isNotEmpty) {
                mapController.removeSymbols(mapController.symbols);
              }
              mapController.addSymbol(
                SymbolOptions(
                  iconImage: 'crosshair',
                  geometry: latlon,
                ),
              );
              setState(() {
                customLocation = latlon.gpsPoint;
              });
            },
            onCameraTrackingChanged: (trackingMode) {
              setState(() {
                isTrackingUser =
                    trackingMode == MyLocationTrackingMode.Tracking;
              });
            },
            myLocationTrackingMode: (isTrackingUser && mapController != null)
                ? MyLocationTrackingMode.Tracking
                : MyLocationTrackingMode.None,
            myLocationRenderMode: MyLocationRenderMode.NORMAL,
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildTopPanel(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        minimum: const EdgeInsets.only(top: 25),
        child: StreamBuilder<GpsPoint>(
          stream: _locator.positionStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return LocationPanel.location(snapshot.data);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        minimum: const EdgeInsets.only(bottom: 25),
        child: LocationPopup.location(
          customLocation,
          onDismiss: () => setState(() {
            mapController.removeSymbols(mapController.symbols);
            customLocation = null;
          }),
        ),
      ),
    );
  }

  Widget _buildTrackButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: SafeArea(
        minimum: const EdgeInsets.only(top: 25),
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background.withOpacity(0.78),
            borderRadius: BorderRadius.circular(9),
          ),
          child: IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () => setState(() {
              isTrackingUser = true;
            }),
          ),
        ),
      ),
    );
  }
}
