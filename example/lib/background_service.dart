// this will be used as notification channel id
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:android_automotive_plugin/android_automotive_plugin.dart';
import 'package:android_automotive_plugin/car/car_sensor_event.dart';
import 'package:android_automotive_plugin/car/car_sensor_types.dart';
import 'package:android_automotive_plugin/car/hvac_manager.dart';
import 'package:android_automotive_plugin/car/ignition_state.dart';
import 'package:android_automotive_plugin_example/file_writer.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import 'automotive_store.dart';

Future<void> initializeBackgroundService() async {
  await _log("initializeService");

  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      iOS: DarwinInitializationSettings(),
      android: AndroidInitializationSettings('ic_bg_service_small'),
    ),
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

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

late AndroidAutomotivePlugin _androidAutomotivePlugin;

Timer? _timerDriver;
Timer? _timerPassenger;

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

  _androidAutomotivePlugin = AndroidAutomotivePlugin();
  await _log("init plugin");
  final completer = Completer();

  await _log("wait");
  _androidAutomotivePlugin.onCarSensorEventCallback = _onCarSensorEvent;

  await _androidAutomotivePlugin.connect();

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

_onCarSensorEvent(CarSensorEvent carSensorEvent) async {
  try {
    await _log("_onCarSensorEvent ${jsonEncode(carSensorEvent)}");

    if (carSensorEvent.sensorType ==
        CarSensorTypes.SENSOR_TYPE_IGNITION_STATE) {
      int ignitionState = carSensorEvent.intValues.first;
      bool ignitionOn = ignitionState == IgnitionState.IGNITION_STATE_ON;

      await _log("ignitionOn ${ignitionOn}");

      if (ignitionOn) {
        // load settings
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        final driverSeatAutoHeatTime =
            SeatHeatTime.values[prefs.getInt('_driverSeatAutoHeatTime') ?? 0];
        final driverSeatAutoHeatTempThreshold = SeatHeatTempThreshold
            .values[prefs.getInt('_driverSeatAutoHeatTempThreshold') ?? 1];

        final passengerSeatAutoHeatTime = SeatHeatTime
            .values[prefs.getInt('_passengerSeatAutoHeatTime') ?? 0];
        final passengerSeatAutoHeatTempThreshold = SeatHeatTempThreshold
            .values[prefs.getInt('_passengerSeatAutoHeatTempThreshold') ?? 1];

        // check temp
        final hvacManager = CarHvacManager(_androidAutomotivePlugin);
        final temp = await hvacManager.getInsideTemperature();

        final insideTemp = (temp - 84) / 2;

        // enable driver seat
        if (driverSeatAutoHeatTime != SeatHeatTime.off &&
                insideTemp < driverSeatAutoHeatTempThreshold.getTempInCelcius
            //
            ) {
          //
          hvacManager.setSeatHeatLevel(true, 3);
          //
          _timerDriver?.cancel();
          _timerDriver = Timer(
            Duration(minutes: driverSeatAutoHeatTime.getDurationInMinutes),
            () {
              hvacManager.setSeatHeatLevel(true, 0);
            },
          );
        }

        // enable passenger seat
        if (passengerSeatAutoHeatTime != SeatHeatTime.off &&
                insideTemp < passengerSeatAutoHeatTempThreshold.getTempInCelcius
            //
            ) {
          //
          hvacManager.setSeatHeatLevel(false, 3);
          //
          _timerPassenger?.cancel();
          _timerPassenger = Timer(
            Duration(minutes: passengerSeatAutoHeatTime.getDurationInMinutes),
            () {
              hvacManager.setSeatHeatLevel(false, 0);
            },
          );
        }
      } else {
        _timerDriver?.cancel();
        _timerPassenger?.cancel();
      }
    }
  } catch (e) {
    await _log("ERROR ${e.toString()}");
  }
}
