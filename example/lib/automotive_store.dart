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
import 'package:android_automotive_plugin_example/file_writer.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'automotive_store.g.dart';

enum SeatHeatTime {
  off,
  short,
  medium,
  long,
}

extension SeatHeatTimeDuration on SeatHeatTime {
  int get getDurationInMinutes {
    switch (this) {
      case SeatHeatTime.off:
        return 0;
      case SeatHeatTime.short:
        return 3;
      case SeatHeatTime.medium:
        return 5;
      case SeatHeatTime.long:
        return 7;
    }
  }
}

enum SeatHeatTempThreshold {
  low,
  medium,
  high,
}

extension SeatHeatTempThresholdTemp on SeatHeatTempThreshold {
  int get getTempInCelcius {
    switch (this) {
      case SeatHeatTempThreshold.low:
        return 0;
      case SeatHeatTempThreshold.medium:
        return 7;
      case SeatHeatTempThreshold.high:
        return 15;
    }
  }
}

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
  int _driverSeatHeatLevel = 0;

  @readonly
  SeatHeatTime _driverSeatAutoHeatTime = SeatHeatTime.off;

  @readonly
  SeatHeatTempThreshold _driverSeatAutoHeatTempThreshold =
      SeatHeatTempThreshold.medium;

  @readonly
  int _passengerSeatHeatLevel = 0;

  @readonly
  SeatHeatTime _passengerSeatAutoHeatTime = SeatHeatTime.off;

  @readonly
  SeatHeatTempThreshold _passengerSeatAutoHeatTempThreshold =
      SeatHeatTempThreshold.medium;

  @action
  void setSeatHeatLevel(bool isDriverSeat, int level) {
    _carHvacManager.setSeatHeatLevel(isDriverSeat, level);

    if (isDriverSeat) {
      _driverSeatHeatLevel = level;
    } else {
      _passengerSeatHeatLevel = level;
    }
  }

  @action
  void setSeatAutoHeatTime(bool isDriverSeat, SeatHeatTime time) {
    if (isDriverSeat) {
      _driverSeatAutoHeatTime = time;
    } else {
      _passengerSeatAutoHeatTime = time;
    }

    _saveSettings();
  }

  @action
  void setSeatAutoHeatTempTheshold(
      bool isDriverSeat, SeatHeatTempThreshold temp) {
    if (isDriverSeat) {
      _driverSeatAutoHeatTempThreshold = temp;
    } else {
      _passengerSeatAutoHeatTempThreshold = temp;
    }

    _saveSettings();
  }

  //////////////////////////////

  _onCarSensorEvent(CarSensorEvent carSensorEvent) {
    if (carSensorEvent.sensorType ==
        CarSensorTypes.SENSOR_TYPE_IGNITION_STATE) {
      int ignitionState = carSensorEvent.intValues.first;
      _ignitionOn = ignitionState == IgnitionState.IGNITION_STATE_ON;
    }
  }

  _onHvacChangeEvent(CarPropertyValue carPropertyValue) async {
    try {
      if (carPropertyValue.propertyId ==
          CarHvacPropertyIds.ID_HVAC_IN_OUT_TEMP) {
        if (carPropertyValue.areaId == VehicleAreaInOutCAR.InOutCAR_INSIDE) {
          _insideTemp =
              ((double.tryParse(carPropertyValue.value) ?? 0) - 84) / 2;
        }

        final temp = await _carHvacManager.getInsideTemperature();
        final insideTemp = temp;

        _log += ">>>>>>>>>>>>>>>>>>>>[insideTemp] ${insideTemp} \n\n\n";
      } else if (carPropertyValue.propertyId ==
          VehiclePropertyIds.HVAC_SEAT_TEMPERATURE) {
        if (carPropertyValue.areaId == VehicleAreaSeat.SEAT_MAIN_DRIVER) {
          _driverSeatHeatLevel = int.tryParse(carPropertyValue.value) ?? 0;
        } else if (carPropertyValue.areaId == VehicleAreaSeat.SEAT_PASSENGER) {
          _passengerSeatHeatLevel = int.tryParse(carPropertyValue.value) ?? 0;
        }
      }
    } catch (e) {
      _log += ">>>>>>>>>>>>>>>>>>>>[_onHvacChangeEvent] ${e.toString()} \n\n\n";
    }
  }

  Future<void> setTestCover() async {
    final asset = await rootBundle.load("assets/images/flutter-logo.jpg");
    final buffer = asset.buffer;
    final file = await FileWriter.writeFileToDownloadsDir(
        buffer.asUint8List(asset.offsetInBytes, asset.lengthInBytes),
        "cover.jpg");

    String path = file.absolute.path.replaceAll('//', '/');
    _log += "setTestCover $path\n\n";

    try {
      final res = await _androidAutomotivePlugin
          .setVehicleSettingMusicAlbumPictureFilePath(path);
      _log += "setTestCover OK: $res\n\n";
    } catch (e) {
      _log += "setTestCover ERROR ${e.toString()}\n\n";
    }
  }

  //////////////////////////////

  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _driverSeatAutoHeatTime =
        SeatHeatTime.values[prefs.getInt('_driverSeatAutoHeatTime') ?? 0];
    _driverSeatAutoHeatTempThreshold = SeatHeatTempThreshold
        .values[prefs.getInt('_driverSeatAutoHeatTempThreshold') ?? 1];

    _passengerSeatAutoHeatTime =
        SeatHeatTime.values[prefs.getInt('_passengerSeatAutoHeatTime') ?? 0];
    _passengerSeatAutoHeatTempThreshold = SeatHeatTempThreshold
        .values[prefs.getInt('_passengerSeatAutoHeatTempThreshold') ?? 1];
  }

  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
        '_driverSeatAutoHeatTime', _driverSeatAutoHeatTime.index);
    await prefs.setInt('_driverSeatAutoHeatTempThreshold',
        _driverSeatAutoHeatTempThreshold.index);

    await prefs.setInt(
        '_passengerSeatAutoHeatTime', _passengerSeatAutoHeatTime.index);
    await prefs.setInt('_passengerSeatAutoHeatTempThreshold',
        _passengerSeatAutoHeatTempThreshold.index);
  }
}
