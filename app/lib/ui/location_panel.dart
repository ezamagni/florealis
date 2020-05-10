import 'package:florealis/models/cfce_point.dart';
import 'package:florealis/models/gps_point.dart';
import 'package:flutter/material.dart';

class LocationPanel extends StatelessWidget {
  final GpsPoint gpsLocation;
  final CfcePoint cfceLocation;

  LocationPanel(
    this.gpsLocation,
    this.cfceLocation, {
    Key key,
  }) : super(key: key);

  factory LocationPanel.location(GpsPoint location, {Key key}) {
    final cfceLocation = CfcePoint.from(location);
    return LocationPanel(location, cfceLocation, key: key);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background.withOpacity(0.78),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                cfceLocation?.toString() ?? '-',
                style: Theme.of(context).textTheme.headline6,
              ),
              Container(height: 5),
              Text(
                gpsLocation?.toString() ?? '-',
                style: Theme.of(context).textTheme.caption.apply(
                  fontFamily: 'UbuntuMono',
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
