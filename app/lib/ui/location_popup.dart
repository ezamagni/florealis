import 'package:florealis/models/cfce_point.dart';
import 'package:florealis/models/gps_point.dart';
import 'package:flutter/material.dart';

class LocationPopup extends StatelessWidget {
  final GpsPoint gpsLocation;
  final CfcePoint cfceLocation;
  final Function onDismiss;

  LocationPopup(
    this.gpsLocation,
    this.cfceLocation, {
    this.onDismiss,
    Key key,
  }) : super(key: key);

  factory LocationPopup.location(
    GpsPoint location, {
    Key key,
    Function onDismiss,
  }) {
    final cfceLocation = CfcePoint.from(location);
    return LocationPopup(location, cfceLocation, onDismiss: onDismiss, key: key);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.85),
            border: Border.all(
              color: Colors.black,
              width: 1.6,
            ),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Theme(
                data: Theme.of(context).copyWith(
                  textTheme: Theme.of(context).textTheme.apply(
                        bodyColor: Colors.black,
                        displayColor: Colors.black,
                      ),
                ),
                child: Builder(
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          cfceLocation?.toString() ?? '-',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Container(height: 5),
                        Text(
                          gpsLocation?.toString() ?? '-',
                          style: Theme.of(context).textTheme.caption.apply(
                                fontFamily: 'UbuntuMono',
                              ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -12,
          left: -12,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 1.6,
              ),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints.tight(Size.square(28)),
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: onDismiss,
            ),
          ),
        ),
      ],
    );
  }
}
