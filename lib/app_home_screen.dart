import 'package:flutter/material.dart';
import 'package:ieatta/core/enums/permission_status.dart';
import 'package:ieatta/src/providers/home_state.dart';
import 'package:ieatta/src/screens/restaurants/hotel_home_screen.dart';
import 'package:location/location.dart' as GpsLocation;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as PermissionHandler;
import 'package:provider/provider.dart';

import 'no_permission_view.dart';

class AppHomeScreen extends StatefulWidget {
  @override
  _AppHomeScreenState createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen>
    with TickerProviderStateMixin {
  // Gps Location.
  AppPermissionStatus _permissionStatus = AppPermissionStatus.Undetermined;

  // Location
  Location location = new Location();

  requestAppPermission() async {
    // Location
    GpsLocation.Location location = new GpsLocation.Location();
    bool _serviceEnabled;
    GpsLocation.PermissionStatus _permissionGranted;

    // Enable location service.
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }

    // Enable location permission.
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == GpsLocation.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != GpsLocation.PermissionStatus.granted) {
        setState(() {
          _permissionStatus = AppPermissionStatus.Denied;
        });
        return;
      }
    }

    await location.hasPermission();
    if (_permissionGranted == GpsLocation.PermissionStatus.denied) {
      setState(() {
        _permissionStatus = AppPermissionStatus.Denied;
      });
      return;
    }

    // Other
    Map<PermissionHandler.Permission, PermissionHandler.PermissionStatus>
        permissions = await [
      PermissionHandler.Permission.microphone, // audio
      PermissionHandler.Permission.storage, // local store
      PermissionHandler.Permission.camera // take photo
    ].request();
    // var x = permissions[PermissionHandler.Permission.microphone];
    // var y = permissions[PermissionHandler.Permission.storage];
    // var z = permissions[PermissionHandler.Permission.camera];

    if (
        // permissions[PermissionHandler.Permission.microphone] ==
        // PermissionHandler.PermissionStatus.granted // audio
        // &&
        permissions[PermissionHandler.Permission.storage] ==
                PermissionHandler.PermissionStatus.granted // local store
            &&
            permissions[PermissionHandler.Permission.camera] ==
                PermissionHandler.PermissionStatus.granted // take photo
        ) {
      setState(() {
        _permissionStatus = AppPermissionStatus.Granted;
      });
    } else {
      setState(() {
        _permissionStatus = AppPermissionStatus.Denied;
      });
    }
  }

  HomeState homeState = HomeState(
    // TODO: DJZHANG
    gpsTrack: true,
    // gpsTrack: false,
  );

  @override
  void initState() {
    super.initState();
    requestAppPermission();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_permissionStatus) {
      case AppPermissionStatus.Undetermined:
        {
          return Container();
        }
      case AppPermissionStatus.Granted:
        {
          return MultiProvider(providers: [
            StreamProvider<LocationData>.value(
                value: location.onLocationChanged),
            ChangeNotifierProvider<HomeState>.value(value: homeState),
          ], child: HotelHomeScreen());
        }
      case AppPermissionStatus.Denied:
        {
          return NoPermissionView(requestAppPermission: requestAppPermission);
        }
    }

    return Container();
  }
}
