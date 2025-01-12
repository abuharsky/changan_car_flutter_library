import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model.dart';

part 'seat_settings_store.g.dart';

class SeatSettingsStore = _SeatSettingsStore with _$SeatSettingsStore;

abstract class _SeatSettingsStore with Store {
  // Настройки водителя
  @observable
  SeatSettings driverSeatSettings = SeatSettings.defaultSettings();

  // Настройки пассажира
  @observable
  SeatSettings passengerSeatSettings = SeatSettings.defaultSettings();

  // Инициализация и загрузка настроек
  _SeatSettingsStore() {
    _loadSettings();
  }

  // Загрузка настроек из SharedPreferences
  @action
  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final driver = prefs.getString("driver_seat_settings");
    if (driver != null) {
      driverSeatSettings = SeatSettings.fromJson(jsonDecode(driver));
    }

    final passenger = prefs.getString("passenger_seat_settings");
    if (passenger != null) {
      passengerSeatSettings = SeatSettings.fromJson(jsonDecode(passenger));
    }
  }

  // Сохранение настроек в SharedPreferences
  @action
  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        "driver_seat_settings", jsonEncode(driverSeatSettings.toJson()));
    await prefs.setString(
        "passenger_seat_settings", jsonEncode(passengerSeatSettings.toJson()));
  }

  // Установка настроек водителя
  @action
  Future<void> setDriverSeatSettings(SeatSettings settings) async {
    driverSeatSettings = settings;
    await _saveSettings();
  }

  // Установка настроек пассажира
  @action
  Future<void> setPassengerSeatSettings(SeatSettings settings) async {
    passengerSeatSettings = settings;
    await _saveSettings();
  }
}
