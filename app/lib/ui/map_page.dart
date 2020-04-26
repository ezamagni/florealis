import 'package:florealis/blocs/location/bloc.dart';
import 'package:florealis/globals.dart';
import 'package:florealis/models/gps_point.dart';
import 'package:florealis/ui/location_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:florealis/extensions/mapbox_extensions.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with WidgetsBindingObserver {
  static final _initialCameraPosition = CameraPosition(
    target: LatLng(41.902, 12.453),
    zoom: 4.8,
  );

  final locationBloc = LocationBloc();
  MapboxMapController mapController;
  GpsPoint userLocation;

  bool isTrackingUser = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    locationBloc.listen(_onLocationState);
    locationBloc.add(GetLocationEvent());
    mapController.addListener(_onMapChanged);
  }

  @override
  void dispose() {
    mapController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onMapChanged() {
    // setState(() {
    // });
    print(mapController);
  }

  void _onLocationState(LocationState state) {
    if (state is KnownLocationState) {
      if (isTrackingUser) {
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(state.location.latlng, 13.4),
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      locationBloc.add(GetLocationEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationBloc>.value(
      value: locationBloc,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            MapboxMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: _initialCameraPosition,
              styleString: Globals.MAPBOX_STYLEURL,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              myLocationEnabled: true,
              myLocationTrackingMode: isTrackingUser
                  ? MyLocationTrackingMode.TrackingGPS
                  : MyLocationTrackingMode.Tracking,
              myLocationRenderMode: MyLocationRenderMode.NORMAL,
            ),
            BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                if (state is KnownLocationState) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: LocationPanel.location(state.location),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
