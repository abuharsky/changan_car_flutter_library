import 'package:android_automotive_plugin/android_automotive_plugin.dart';

import 'hvac_property_ids.dart';
import 'vehicle_area_in_out_car.dart';
import 'vehicle_area_seat.dart';
import 'vehicle_property_ids.dart';

class CarHvacManager {
  final AndroidAutomotivePlugin _plugin;

  CarHvacManager(this._plugin);

  // frontSeats
  Future<void> setSeatHeatLevel(bool isDriver, int level) async {
    return _plugin.setHvacIntProperty(
      VehiclePropertyIds.HVAC_SEAT_TEMPERATURE,
      isDriver
          ? VehicleAreaSeat.SEAT_MAIN_DRIVER
          : VehicleAreaSeat.SEAT_PASSENGER,
      level,
    );
  }

  Future<int> getSeatHeatLevel(bool isDriver) async {
    return _plugin.getHvacIntProperty(
      VehiclePropertyIds.HVAC_SEAT_TEMPERATURE,
      isDriver
          ? VehicleAreaSeat.SEAT_MAIN_DRIVER
          : VehicleAreaSeat.SEAT_PASSENGER,
    );
  }

  // AC
  Future<void> setAcTemperature(bool isDriver, double temp) async {
    return _plugin.setHvacFloatProperty(
      CarHvacPropertyIds.ID_ZONED_TEMP_SETPOINT,
      isDriver
          ? VehicleAreaSeat.SEAT_MAIN_DRIVER
          : VehicleAreaSeat.SEAT_PASSENGER,
      temp,
    );
  }

  Future<double> getAcTemperature(bool isDriver) async {
    final value = await _plugin.getHvacFloatProperty(
      CarHvacPropertyIds.ID_ZONED_TEMP_SETPOINT,
      isDriver
          ? VehicleAreaSeat.SEAT_MAIN_DRIVER
          : VehicleAreaSeat.SEAT_PASSENGER,
    );

    return value;
  }

  // outside temp
  Future<int> getOutsideTemperature() async {
    final value = await _plugin.getHvacIntProperty(
      CarHvacPropertyIds.ID_HVAC_IN_OUT_TEMP,
      VehicleAreaInOutCAR.InOutCAR_OUTSIDE,
    );

    return value;
  }

  // inside temp
  Future<int> getInsideTemperature() async {
    final value = await _plugin.getHvacIntProperty(
      CarHvacPropertyIds.ID_HVAC_IN_OUT_TEMP,
      VehicleAreaInOutCAR.InOutCAR_INSIDE,
    );

    return value;
  }
}
