// this will be used as notification channel id
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:android_automotive_plugin_example/file_writer.dart';
import 'package:android_automotive_plugin_example/model.dart';
import 'package:android_automotive_plugin_example/new/automotive_adapter.dart';
import 'package:android_automotive_plugin_example/new/preferences_manager.dart';
import 'package:android_automotive_plugin_example/new/seat_manager.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> initializeBackgroundService() async {
  await _log("initializeService");

  final service = FlutterBackgroundService();

  // /// OPTIONAL, using custom notification channel id
  // const AndroidNotificationChannel channel = AndroidNotificationChannel(
  //   'my_foreground', // id
  //   'MY FOREGROUND SERVICE', // title
  //   description:
  //       'This channel is used for important notifications.', // description
  //   importance: Importance.low, // importance must be at low or higher level
  // );

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // await flutterLocalNotificationsPlugin.initialize(
  //   const InitializationSettings(
  //     iOS: DarwinInitializationSettings(),
  //     android: AndroidInitializationSettings('ic_bg_service_small'),
  //   ),
  // );

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  await _log("configure");

  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      //
      autoStart: true,
      autoStartOnBoot: true,
      isForegroundMode: true,
      //
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'App Service',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
  );

  // await _log("startService");
  // await service.startService();
  await _log("done");
}

late SeatManager _seatManager;
late Timer _timer;

@pragma('vm:entry-point')
onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  await _log("onStart");

  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "App Service",
      content: "Updated at ${DateTime.now()}",
    );
  }

  final adapter = AutomotiveAdapter();

  SeatSettings driverSettings =
      await PreferencesManager.loadDriverSeatSettings();
  SeatSettings passengerSettings =
      await PreferencesManager.loadPassengerSeatSettings();

  _seatManager = SeatManager(
    automotiveAdapter: adapter,
    driverSettings: driverSettings,
    passengerSettings: passengerSettings,
  );

  _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
    final newDriverSettings = await PreferencesManager.loadDriverSeatSettings();
    final newPassengerSettings =
        await PreferencesManager.loadPassengerSeatSettings();

    if (newDriverSettings != driverSettings ||
        newPassengerSettings != passengerSettings) {
      driverSettings = newDriverSettings;
      passengerSettings = newPassengerSettings;

      await _log("settings updated, restart SeatManager");

      // restart manager
      _seatManager = SeatManager(
        automotiveAdapter: adapter,
        driverSettings: driverSettings,
        passengerSettings: passengerSettings,
      );
    }
  });

//  _store = AutomotiveStore();
  await _log("init SeatManager");
  final completer = Completer();
  await _log("wait");

  await completer.future;
}

String log = "";
_log(String text) async {
  try {
    log += "[${DateTime.now().toString()}] $text\n\n";
    await FileWriter.writeFileToDownloadsDir(utf8.encode(log), "bglog.txt");

    print("[BG SERVICE] $text");
  } catch (e) {
    print(e.toString());
  }
}
