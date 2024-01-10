import 'package:json_annotation/json_annotation.dart';

part 'car_property_value.g.dart';

@JsonSerializable()
class CarPropertyValue {
  final int areaId;
  final int propertyId;
  final int status;
  final int timestamp;
  final dynamic value;

  CarPropertyValue(
      this.areaId, this.propertyId, this.status, this.timestamp, this.value);

  factory CarPropertyValue.fromJson(Map<String, dynamic> json) =>
      _$CarPropertyValueFromJson(json);

  Map<String, dynamic> toJson() => _$CarPropertyValueToJson(this);
}
