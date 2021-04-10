import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NoPermissionView extends StatefulWidget {
  NoPermissionView({Key key, this.requestAppPermission}) : super(key: key);
  final Function requestAppPermission;

  @override
  _NoPermissionViewState createState() => _NoPermissionViewState();
}

class _NoPermissionViewState extends State<NoPermissionView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Some Permission Not Given",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: RaisedButton(
              child: Text(
                "Give Permissions",
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () async {
                await openAppSettings();
                await widget.requestAppPermission();
              },
            ),
          )
        ],
      ),
    );
  }
}
