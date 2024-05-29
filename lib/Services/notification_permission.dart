import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionCheck extends StatefulWidget {
  @override
  _NotificationPermissionCheckState createState() =>
      _NotificationPermissionCheckState();
}

class _NotificationPermissionCheckState
    extends State<NotificationPermissionCheck> {
  late PermissionStatus _permissionStatus;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermissionStatus();
  }

  Future<void> _checkNotificationPermissionStatus() async {
    final status = await Permission.notification.status;
    setState(() {
      _permissionStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Permission Check'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Notification Permission Status: ${_getStatusString()}',
              style: TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () {
                _requestNotificationPermission();
              },
              child: const Text('Request Notification Permission'),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusString() {
    switch (_permissionStatus) {
      case PermissionStatus.denied:
        return 'Denied';
      case PermissionStatus.granted:
        return 'Granted';
      case PermissionStatus.restricted:
        return 'Restricted';
      case PermissionStatus.permanentlyDenied:
        return 'Permanently Denied';
      default:
        return 'Unknown';
    }
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();
    setState(() {
      _permissionStatus = status;
    });
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NotificationPermissionCheck(),
  ));
}
