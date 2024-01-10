import 'dart:convert';
import 'dart:ui';

import 'package:android_automotive_plugin/car/car_property_value.dart';
import 'package:android_automotive_plugin/car/car_sensor_event.dart';
import 'package:android_automotive_plugin/car/vehicle_property_ids.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AndroidAutomotivePlugin {
  @visibleForTesting
  final methodChannel = const MethodChannel('android_automotive_plugin');

  Function(CarSensorEvent)? onCarSensorEventCallback;
  Function(CarPropertyValue)? onHvacChangeEventCallback;
  Function(CarPropertyValue)? onCarVendorExtensionCallback;
  Function(CarPropertyValue)? onCarClusterInteractionEventCallback;
  Function(String)? onLogCallback;

  AndroidAutomotivePlugin() {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == "onCarSensorEvent") {
        final CarSensorEvent carSensorEvent =
            CarSensorEvent.fromJson(jsonDecode(call.arguments));

        if (onCarSensorEventCallback != null) {
          onCarSensorEventCallback!(carSensorEvent);
        }

        if (onLogCallback != null) {
          onLogCallback!(
              "${call.method}: ${VehiclePropertyIds.valueToString(carSensorEvent.sensorType)}, value:${carSensorEvent.intValues[0]}");
        }
      }
      //
      else if (call.method == "onHvacChangeEvent") {
        final CarPropertyValue carPropertyValue =
            CarPropertyValue.fromJson(jsonDecode(call.arguments));

        if (onHvacChangeEventCallback != null) {
          onHvacChangeEventCallback!(carPropertyValue);
        }

        if (onLogCallback != null) {
          onLogCallback!(
              "${call.method}: ${VehiclePropertyIds.valueToString(carPropertyValue.propertyId)}, area:${carPropertyValue.areaId}, value:${carPropertyValue.value}");
        }
      }
      //
      else if (call.method == "onCarVendorExtensionCallback") {
        final CarPropertyValue carPropertyValue =
            CarPropertyValue.fromJson(jsonDecode(call.arguments));

        if (onCarVendorExtensionCallback != null) {
          onCarVendorExtensionCallback!(carPropertyValue);
        }

        // if (onLogCallback != null) {
        //   onLogCallback!(
        //       "${call.method}: ${VehiclePropertyIds.valueToString(carPropertyValue.propertyId)}, area:${carPropertyValue.areaId}, value:${carPropertyValue.value}");
        // }
      }
      //
      else if (call.method == "onCarClusterInteractionEvent") {
        final CarPropertyValue carPropertyValue =
            CarPropertyValue.fromJson(jsonDecode(call.arguments));

        if (onCarClusterInteractionEventCallback != null) {
          onCarClusterInteractionEventCallback!(carPropertyValue);
        }

        if (onLogCallback != null) {
          onLogCallback!(
              "${call.method}: ${VehiclePropertyIds.valueToString(carPropertyValue.propertyId)}, area:${carPropertyValue.areaId}, value:${carPropertyValue.value}");
        }
      }
      //
      else if (call.method == "onLogEvent") {
        if (onLogCallback != null) {
          onLogCallback!("${call.method}: ${call.arguments as String}");
        }
      }
    });
  }

  Future<void> connect() async {
    methodChannel.invokeMethod("connect");
  }

  Future<void> setHvacIntProperty(int propertyId, int area, int value) async {
    methodChannel.invokeMethod("setHvacIntProperty", {
      "propertyId": propertyId,
      "area": area,
      "value": value,
    });
  }

  Future<int> getHvacIntProperty(int propertyId, int area) async {
    final value = await methodChannel.invokeMethod("getHvacIntProperty", {
      "propertyId": propertyId,
      "area": area,
    });

    return value;
  }

  Future<void> setHvacFloatProperty(
      int propertyId, int area, double value) async {
    methodChannel.invokeMethod("setHvacFloatProperty", {
      "propertyId": propertyId,
      "area": area,
      "value": value,
    });
  }

  Future<double> getHvacFloatProperty(int propertyId, int area) async {
    final value = await methodChannel.invokeMethod("getHvacFloatProperty", {
      "propertyId": propertyId,
      "area": area,
    });

    return value;
  }

  Future<void> setCallbackHandle(Function() callback) async {
    final handle = PluginUtilities.getCallbackHandle(callback);
    if (handle != null) {
      await methodChannel
          .invokeMethod("setAccessibilityServiceCallbackHandler", {
        "handleId": handle.toRawHandle(),
      });
    }
  }

  ///////

  Future<CarSensorEvent> getLatestSensorEvent(int sensorType) async {
    final value = await methodChannel.invokeMethod("getLatestSensorEvent", {
      "sensorType": sensorType,
    });

    final CarSensorEvent carSensorEvent =
        CarSensorEvent.fromJson(jsonDecode(value));

    return carSensorEvent;
  }

  Future<bool> setVehicleSettingMusicAlbumPictureFilePath(String path) async {
    final value = await methodChannel
        .invokeMethod("setVehicleSettingMusicAlbumPictureFilePath", {
      "path": path,
    });

    return value;
  }
}

///////

@pragma('vm:entry-point')
Future<void> entrypoint(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  final int handle = int.parse(args.first);
  final callbackHandle = CallbackHandle.fromRawHandle(handle);
  final callback = PluginUtilities.getCallbackFromHandle(callbackHandle);
  if (callback != null) {
    callback();
  }
}
