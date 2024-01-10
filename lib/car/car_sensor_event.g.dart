// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_sensor_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarSensorEvent _$CarSensorEventFromJson(Map<String, dynamic> json) =>
    CarSensorEvent(
      json['sensorType'] as int,
      json['timestamp'] as int,
      (json['floatValues'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      (json['intValues'] as List<dynamic>).map((e) => e as int).toList(),
      (json['longValues'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$CarSensorEventToJson(CarSensorEvent instance) =>
    <String, dynamic>{
      'sensorType': instance.sensorType,
      'timestamp': instance.timestamp,
      'floatValues': instance.floatValues,
      'intValues': instance.intValues,
      'longValues': instance.longValues,
    };
