import 'package:android_automotive_plugin/android_automotive_plugin.dart';
import 'package:android_automotive_plugin/car/car_property_value.dart';
import 'package:android_automotive_plugin/car/car_sensor_event.dart';
import 'package:android_automotive_plugin/car/car_sensor_types.dart';
import 'package:android_automotive_plugin/car/hvac_manager.dart';
import 'package:android_automotive_plugin/car/hvac_property_ids.dart';
import 'package:android_automotive_plugin/car/ignition_state.dart';
import 'package:android_automotive_plugin/car/sensor_manager.dart';
import 'package:android_automotive_plugin/car/vehicle_area_in_out_car.dart';
import 'package:android_automotive_plugin/car/vehicle_area_seat.dart';
import 'package:android_automotive_plugin/car/vehicle_property_ids.dart';

class AutomotiveAdapter {
  late final AndroidAutomotivePlugin _automotivePlugin;

  late final CarHvacManager _hvacManager;
  late final CarSensorManager _sensorManager;

  // Коллбеки
  Function(bool ignitionOn)? onIgnitionChange;
  Function(double insideTemperature)? onTemperatureChange;

  Function(bool isDriver, int heatLevel)? onSeatHeatChange;
  Function(bool isDriver, int ventilationLevel)? onSeatVentilationChange;

  AutomotiveAdapter() {
    _initialize();
  }

  // Инициализация плагина и подписка на события
  Future<void> _initialize() async {
    _automotivePlugin = AndroidAutomotivePlugin();
    _hvacManager = CarHvacManager(_automotivePlugin);
    _sensorManager = CarSensorManager(_automotivePlugin);

    _automotivePlugin.onHvacChangeEventCallback = _handleHvacEvent;
    _automotivePlugin.onCarSensorEventCallback = _handleSensorEvent;

    // Подключение плагина
    await _automotivePlugin.connect();
  }

  Future<double> getInsideTemperature() async {
    return (await _hvacManager.getInsideTemperature() - 84) / 2;
  }

  Future<bool> getIgnitionOn() async {
    return (await _sensorManager.getIgnitionState() ==
        IgnitionState.IGNITION_STATE_ON);
  }

  // Обработка событий HVAC
  void _handleHvacEvent(CarPropertyValue event) {
    if (event.propertyId == CarHvacPropertyIds.ID_HVAC_IN_OUT_TEMP) {
      if (event.areaId == VehicleAreaInOutCAR.InOutCAR_INSIDE) {
        final insideTemp = ((double.tryParse(event.value) ?? 0) - 84) / 2;
        onTemperatureChange?.call(insideTemp);
      }
    }
    //
    else if (event.propertyId == VehiclePropertyIds.HVAC_SEAT_TEMPERATURE) {
      onSeatHeatChange?.call(
        event.areaId == VehicleAreaSeat.SEAT_MAIN_DRIVER,
        int.tryParse(event.value) ?? 0,
      );
    } else if (event.propertyId == VehiclePropertyIds.HVAC_SEAT_VENTILATION) {
      onSeatVentilationChange?.call(
        event.areaId == VehicleAreaSeat.SEAT_MAIN_DRIVER,
        int.tryParse(event.value) ?? 0,
      );
    }
  }

  // Обработка событий сенсоров
  void _handleSensorEvent(CarSensorEvent event) {
    if (event.sensorType == CarSensorTypes.SENSOR_TYPE_IGNITION_STATE) {
      final ignitionOn =
          event.intValues.first == IgnitionState.IGNITION_STATE_ON;
      onIgnitionChange?.call(ignitionOn);
    }
  }

  // Управление автомобилем (делегирование в HVACManager)
  Future<void> setDriverHeatLevel(int level) async {
    await _hvacManager.setSeatHeatLevel(true, level);
  }

  Future<void> setPassengerHeatLevel(int level) async {
    await _hvacManager.setSeatHeatLevel(false, level);
  }

  Future<void> setDriverVentilationLevel(int level) async {
    await _hvacManager.setSeatVentilationLevel(true, level);
  }

  Future<void> setPassengerVentilationLevel(int level) async {
    await _hvacManager.setSeatVentilationLevel(false, level);
  }
}
