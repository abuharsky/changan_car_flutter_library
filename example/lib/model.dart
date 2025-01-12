import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class SeatSettings {
  final int autoHeatTime;
  final int autoHeatTempThreshold;

  final int autoVentilationTime;
  final int autoVentilationTempThreshold;

  SeatSettings({
    required this.autoHeatTime,
    required this.autoHeatTempThreshold,
    required this.autoVentilationTime,
    required this.autoVentilationTempThreshold,
  });

  SeatSettings copyWith({
    int? autoHeatTime,
    int? autoHeatTempThreshold,
    int? autoVentilationTime,
    int? autoVentilationTempThreshold,
  }) =>
      SeatSettings(
        autoHeatTime: autoHeatTime ?? this.autoHeatTime,
        autoHeatTempThreshold:
            autoHeatTempThreshold ?? this.autoHeatTempThreshold,
        autoVentilationTime: autoVentilationTime ?? this.autoVentilationTime,
        autoVentilationTempThreshold:
            autoVentilationTempThreshold ?? this.autoVentilationTempThreshold,
      );

  factory SeatSettings.defaultSettings() => SeatSettings(
        autoHeatTime: 10,
        autoHeatTempThreshold: 15,
        autoVentilationTime: 30,
        autoVentilationTempThreshold: 25,
      );

  factory SeatSettings.fromJson(Map<String, dynamic> json) =>
      _$SeatSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SeatSettingsToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SeatSettings &&
        other.autoHeatTime == autoHeatTime &&
        other.autoHeatTempThreshold == autoHeatTempThreshold &&
        other.autoVentilationTime == autoVentilationTime &&
        other.autoVentilationTempThreshold == autoVentilationTempThreshold;
  }

  @override
  int get hashCode =>
      autoHeatTime.hashCode ^
      autoHeatTempThreshold.hashCode ^
      autoVentilationTime.hashCode ^
      autoVentilationTempThreshold.hashCode;
}
