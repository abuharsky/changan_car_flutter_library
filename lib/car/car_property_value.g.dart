// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_property_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarPropertyValue _$CarPropertyValueFromJson(Map<String, dynamic> json) =>
    CarPropertyValue(
      json['areaId'] as int,
      json['propertyId'] as int,
      json['status'] as int,
      json['timestamp'] as int,
      json['value'],
    );

Map<String, dynamic> _$CarPropertyValueToJson(CarPropertyValue instance) =>
    <String, dynamic>{
      'areaId': instance.areaId,
      'propertyId': instance.propertyId,
      'status': instance.status,
      'timestamp': instance.timestamp,
      'value': instance.value,
    };
