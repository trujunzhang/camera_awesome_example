import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'
    as PermissionHandler;

import 'core/enums/permission_status.dart';
import 'example.dart';
import 'no_permission_view.dart';

class AppHomeScreen extends StatefulWidget {
  @override
  _AppHomeScreenState createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen>
    with TickerProviderStateMixin {
  // Gps Location.
  AppPermissionStatus _permissionStatus = AppPermissionStatus.Undetermined;

  requestAppPermission() async {
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
        // permissions[PermissionHandler.Permission.storage] ==
        //         PermissionHandler.PermissionStatus.granted // local store
        //     &&
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
          return MyApp();
        }
      case AppPermissionStatus.Denied:
        {
          return NoPermissionView(requestAppPermission: requestAppPermission);
        }
    }

    return Container();
  }
}
