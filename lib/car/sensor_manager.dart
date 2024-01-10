import 'package:android_automotive_plugin/android_automotive_plugin.dart';

import 'car_sensor_types.dart';

class CarSensorManager {
  final AndroidAutomotivePlugin _plugin;

  CarSensorManager(this._plugin);

  // frontSeats
  Future<int> getIgnitionState() async {
    final event = await _plugin.getLatestSensorEvent(
      CarSensorTypes.SENSOR_TYPE_IGNITION_STATE,
    );

    return event.intValues.first;
  }
}
