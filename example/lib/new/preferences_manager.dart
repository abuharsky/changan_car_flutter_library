import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model.dart';

class PreferencesManager {
  static Future<SeatSettings> loadDriverSeatSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    final driverSettings = prefs.getString("driver_seat_settings");

    if (driverSettings != null) {
      return SeatSettings.fromJson(jsonDecode(driverSettings));
    }
    return SeatSettings.defaultSettings();
  }

  static Future<SeatSettings> loadPassengerSeatSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    final passengerSettings = prefs.getString("passenger_seat_settings");

    if (passengerSettings != null) {
      return SeatSettings.fromJson(jsonDecode(passengerSettings));
    }
    return SeatSettings.defaultSettings();
  }

  static Future<void> saveDriverSeatSettings(SeatSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "driver_seat_settings", jsonEncode(settings.toJson()));
  }

  static Future<void> savePassengerSeatSettings(SeatSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "passenger_seat_settings", jsonEncode(settings.toJson()));
  }
}
