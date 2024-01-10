import 'package:json_annotation/json_annotation.dart';

part 'car_sensor_event.g.dart';

@JsonSerializable()
class CarSensorEvent {
  final int sensorType;
  final int timestamp;
  final List<double> floatValues;
  final List<int> intValues;
  final List<int> longValues;

  CarSensorEvent(this.sensorType, this.timestamp, this.floatValues,
      this.intValues, this.longValues);

  factory CarSensorEvent.fromJson(Map<String, dynamic> json) =>
      _$CarSensorEventFromJson(json);

  Map<String, dynamic> toJson() => _$CarSensorEventToJson(this);
}
