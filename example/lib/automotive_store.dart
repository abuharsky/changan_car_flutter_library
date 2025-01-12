import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

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
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'file_writer.dart';
import 'model.dart';

part 'automotive_store.g.dart';

class AutomotiveStore = AutomotiveStoreBase with _$AutomotiveStore;

abstract class AutomotiveStoreBase with Store {
  late final AndroidAutomotivePlugin _androidAutomotivePlugin;
  late final CarHvacManager _carHvacManager;
  late final CarSensorManager _carSensorManager;

  AutomotiveStoreBase() {
    _log += "initialize AutomotiveStoreBase\n\n";
    _loadSettings().whenComplete(() async {
      _log += "initialize AndroidAutomotivePlugin\n\n";
      _androidAutomotivePlugin = AndroidAutomotivePlugin();

      _log += "initialize CarHvacManager\n\n";
      _carHvacManager = CarHvacManager(_androidAutomotivePlugin);

      _log += "initialize CarSensorManager\n\n";
      _carSensorManager = CarSensorManager(_androidAutomotivePlugin);

      _androidAutomotivePlugin.onHvacChangeEventCallback = _onHvacChangeEvent;
      _androidAutomotivePlugin.onCarSensorEventCallback = _onCarSensorEvent;

      _androidAutomotivePlugin.onLogCallback = (log) {
        _log += "$log\n\n";
      };

      try {
        await _androidAutomotivePlugin.connect();

        int ignitionState = await _carSensorManager.getIgnitionState();
        _ignitionOn = ignitionState == IgnitionState.IGNITION_STATE_ON;
      } catch (e) {
        _log += "${e.toString()}\n\n";
      }
    });
  }

  @readonly
  String _log = "";

  @readonly
  bool _ignitionOn = false;

  @readonly
  double? _insideTemp;

  @readonly
  SeatSettings _driverSeatSettings = SeatSettings.defaultSettings();

  @readonly
  int _driverSeatHeatLevel = 0;

  @readonly
  int _driverSeatVentilationLevel = 0;

  @readonly
  int _passengerSeatHeatLevel = 0;

  @readonly
  int _passengerSeatVentilationLevel = 0;

  @readonly
  SeatSettings _passengerSeatSettings = SeatSettings.defaultSettings();

  Timer? _timerDriver;
  Timer? _timerPassenger;

  @action
  Future<void> setDriverSeatSettings(SeatSettings seat) async {
    _driverSeatSettings = seat;

    await _saveSettings();
    await _checkConditionsAndApplySeatActions();
  }

  @action
  Future<void> setPassengerSeatSettings(SeatSettings seat) async {
    _passengerSeatSettings = seat;

    await _saveSettings();
    await _checkConditionsAndApplySeatActions();
  }

  //////////////////////////////

  _logError(String text) async {
    try {
      _log += "[${DateTime.now().toString()}] $text\n\n";
      await FileWriter.writeFileToDownloadsDir(
          utf8.encode(_log), "error_log.txt");

      print("[ERROR SERVICE] $text");
    } catch (e) {
      print(e.toString());
    }
  }

  _onCarSensorEvent(CarSensorEvent carSensorEvent) async {
    try {
      if (carSensorEvent.sensorType ==
          CarSensorTypes.SENSOR_TYPE_IGNITION_STATE) {
        int ignitionState = carSensorEvent.intValues.first;
        _ignitionOn = ignitionState == IgnitionState.IGNITION_STATE_ON;
        await _checkConditionsAndApplySeatActions();
      }
    } catch (e) {
      _logError(e.toString());
    }
  }

  _onHvacChangeEvent(CarPropertyValue carPropertyValue) async {
    try {
      if (carPropertyValue.propertyId ==
          CarHvacPropertyIds.ID_HVAC_IN_OUT_TEMP) {
        if (carPropertyValue.areaId == VehicleAreaInOutCAR.InOutCAR_INSIDE) {
          _insideTemp =
              ((double.tryParse(carPropertyValue.value) ?? 0) - 84) / 2;
          //         await _checkConditionsAndApplySeatActions();
        }

        final temp = await _carHvacManager.getInsideTemperature();
        final insideTemp = temp;

        _log += ">>>>>>>>>>>>>>>>>>>>[insideTemp] ${insideTemp} \n\n\n";
      } else if (carPropertyValue.propertyId ==
          VehiclePropertyIds.HVAC_SEAT_TEMPERATURE) {
        if (carPropertyValue.areaId == VehicleAreaSeat.SEAT_MAIN_DRIVER) {
          final value = int.tryParse(carPropertyValue.value) ?? 0;
          if (_driverSeatHeatLevel != value) {
            _driverSeatHeatLevel = value;
          }
        } else if (carPropertyValue.areaId == VehicleAreaSeat.SEAT_PASSENGER) {
          _passengerSeatHeatLevel = int.tryParse(carPropertyValue.value) ?? 0;
        }
      } else if (carPropertyValue.propertyId ==
          VehiclePropertyIds.HVAC_SEAT_VENTILATION) {
        if (carPropertyValue.areaId == VehicleAreaSeat.SEAT_MAIN_DRIVER) {
          _driverSeatVentilationLevel =
              int.tryParse(carPropertyValue.value) ?? 0;
        } else if (carPropertyValue.areaId == VehicleAreaSeat.SEAT_PASSENGER) {
          _passengerSeatVentilationLevel =
              int.tryParse(carPropertyValue.value) ?? 0;
        }
      }
    } catch (e) {
      _log += ">>>>>>>>>>>>>>>>>>>>[_onHvacChangeEvent] ${e.toString()} \n\n\n";
      _logError(e.toString());
    }
  }

  //////////////////////////////

  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final driver = prefs.getString("driver_seat_settings");
    if (driver != null) {
      _driverSeatSettings = SeatSettings.fromJson(jsonDecode(driver));
    }

    final passenger = prefs.getString("passenger_seat_settings");
    if (passenger != null) {
      _passengerSeatSettings = SeatSettings.fromJson(jsonDecode(passenger));
    }
  }

  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        "driver_seat_settings", jsonEncode(_driverSeatSettings.toJson()));
    await prefs.setString(
        "passenger_seat_settings", jsonEncode(_passengerSeatSettings.toJson()));
  }

  Future<void> _checkConditionsAndApplySeatActions() async {
    // _carHvacManager.setSeatHeatLevel(true, seat.heatLevel);
    // _carHvacManager.setSeatVentilationLevel(true, seat.ventilationLevel);

    final insideTemp = _insideTemp ?? 0;

    if (_ignitionOn) {
      // enable driver seat
      if (_driverSeatSettings.autoHeatTime > 0 &&
              insideTemp < _driverSeatSettings.autoHeatTempThreshold
          //
          ) {
        //
        _carHvacManager.setSeatHeatLevel(true, 3);
        //
        _timerDriver?.cancel();
        _timerDriver = Timer(
          Duration(minutes: _driverSeatSettings.autoHeatTime),
          () {
            _carHvacManager.setSeatHeatLevel(true, 0);
          },
        );
      } else if (_driverSeatSettings.autoVentilationTime > 0 &&
              insideTemp > _driverSeatSettings.autoVentilationTempThreshold
          //
          ) {
        //
        _carHvacManager.setSeatVentilationLevel(true, 3);
        //
        _timerDriver?.cancel();
        _timerDriver = Timer(
          Duration(minutes: _driverSeatSettings.autoVentilationTime),
          () {
            _carHvacManager.setSeatVentilationLevel(true, 0);
          },
        );
      }

      // enable passenger seat
      if (_passengerSeatSettings.autoHeatTime > 0 &&
              insideTemp < _passengerSeatSettings.autoHeatTempThreshold
          //
          ) {
        //
        _carHvacManager.setSeatHeatLevel(true, 3);
        //
        _timerPassenger?.cancel();
        _timerPassenger = Timer(
          Duration(minutes: _passengerSeatSettings.autoHeatTime),
          () {
            _carHvacManager.setSeatHeatLevel(true, 0);
          },
        );
      } else if (_passengerSeatSettings.autoVentilationTime > 0 &&
              insideTemp > _passengerSeatSettings.autoVentilationTempThreshold
          //
          ) {
        //
        _carHvacManager.setSeatVentilationLevel(true, 3);
        //
        _timerPassenger?.cancel();
        _timerPassenger = Timer(
          Duration(minutes: _passengerSeatSettings.autoVentilationTime),
          () {
            _carHvacManager.setSeatVentilationLevel(true, 0);
          },
        );
      }
    } else {
      _timerDriver?.cancel();
      _timerPassenger?.cancel();
    }
  }
}
