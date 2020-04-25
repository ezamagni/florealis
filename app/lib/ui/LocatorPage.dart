import 'package:florealis/blocs/location/bloc.dart';
import 'package:florealis/models/cfce_point.dart';
import 'package:florealis/models/sexagesimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LocatorPage extends StatefulWidget {
  @override
  _LocatorPageState createState() => _LocatorPageState();
}

class _LocatorPageState extends State<LocatorPage> 
  with WidgetsBindingObserver
{

  final _locationBloc = LocationBloc();

  @override
  void initState() {
    super.initState();
    _updateLocation();
    WidgetsBinding.instance.addObserver(this);    
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateLocation();
    }
  }

  void _updateLocation() {
    _locationBloc.add(GetLocationEvent());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bottanica"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Center(
          child: BlocBuilder<LocationBloc, LocationState>(
            bloc: _locationBloc,
            builder: (context, locationState) {
              if (locationState is ErrorLocationState) {
                return Text('Impossibile recuperare la posizione corrente:\n${locationState.error.toString()}');
              } else if (locationState is FetchingLocationState) {
                return CircularProgressIndicator();
              } else if (locationState is KnownLocationState) {
                final latDMS = Sexagesimal.from(locationState.position.lat);
                final lonDMS = Sexagesimal.from(locationState.position.lon);
                final cfcePosition = CFCEPoint.from(locationState.position);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${cfcePosition.toString()}", 
                      style: Theme.of(context).textTheme.display2,
                    ),
                    Padding(padding: EdgeInsets.all(8),),
                    Text("${latDMS.toString()}  ${lonDMS.toString()}",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    Text("${locationState.position.toString()}"),
                  ],
                );
              } else {
                return Text('Posizione sconosciuta');
              }
            },
          ),
        ),
      ),
    );
  }
}
