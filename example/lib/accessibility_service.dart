import 'package:android_automotive_plugin/android_automotive_plugin.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

Future<void> initializeAccessibilityService() async {
  final plugin = AndroidAutomotivePlugin();
  plugin.setCallbackHandle(_accessibilityServiceCallback);
}

//
@pragma('vm:entry-point')
Future<void> _accessibilityServiceCallback() async {
  final service = FlutterBackgroundService();

  final isRunning = await service.isRunning();

  if (!isRunning) {
    service.startService();
  }
}
