import 'package:flutter/material.dart';

class LocationPermissionDialog extends StatelessWidget {
  final VoidCallback onRequestPermission;
  final VoidCallback onOpenSettings;

  LocationPermissionDialog({
    required this.onRequestPermission,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Location Permission'),
      content: Text('This app needs location access to function properly.'),
      actions: [
        TextButton(
          onPressed: onRequestPermission,
          child: Text('Allow Access'),
        ),
        TextButton(
          onPressed: onOpenSettings,
          child: Text('Open Settings'),
        ),
      ],
    );
  }
}
