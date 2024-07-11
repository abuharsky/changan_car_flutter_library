// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automotive_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AutomotiveStore on AutomotiveStoreBase, Store {
  late final _$_logAtom =
      Atom(name: 'AutomotiveStoreBase._log', context: context);

  String get log {
    _$_logAtom.reportRead();
    return super._log;
  }

  @override
  String get _log => log;

  @override
  set _log(String value) {
    _$_logAtom.reportWrite(value, super._log, () {
      super._log = value;
    });
  }

  late final _$_ignitionOnAtom =
      Atom(name: 'AutomotiveStoreBase._ignitionOn', context: context);

  bool get ignitionOn {
    _$_ignitionOnAtom.reportRead();
    return super._ignitionOn;
  }

  @override
  bool get _ignitionOn => ignitionOn;

  @override
  set _ignitionOn(bool value) {
    _$_ignitionOnAtom.reportWrite(value, super._ignitionOn, () {
      super._ignitionOn = value;
    });
  }

  late final _$_insideTempAtom =
      Atom(name: 'AutomotiveStoreBase._insideTemp', context: context);

  double? get insideTemp {
    _$_insideTempAtom.reportRead();
    return super._insideTemp;
  }

  @override
  double? get _insideTemp => insideTemp;

  @override
  set _insideTemp(double? value) {
    _$_insideTempAtom.reportWrite(value, super._insideTemp, () {
      super._insideTemp = value;
    });
  }

  late final _$_driverSeatSettingsAtom =
      Atom(name: 'AutomotiveStoreBase._driverSeatSettings', context: context);

  SeatSettings get driverSeatSettings {
    _$_driverSeatSettingsAtom.reportRead();
    return super._driverSeatSettings;
  }

  @override
  SeatSettings get _driverSeatSettings => driverSeatSettings;

  @override
  set _driverSeatSettings(SeatSettings value) {
    _$_driverSeatSettingsAtom.reportWrite(value, super._driverSeatSettings, () {
      super._driverSeatSettings = value;
    });
  }

  late final _$_driverSeatHeatLevelAtom =
      Atom(name: 'AutomotiveStoreBase._driverSeatHeatLevel', context: context);

  int get driverSeatHeatLevel {
    _$_driverSeatHeatLevelAtom.reportRead();
    return super._driverSeatHeatLevel;
  }

  @override
  int get _driverSeatHeatLevel => driverSeatHeatLevel;

  @override
  set _driverSeatHeatLevel(int value) {
    _$_driverSeatHeatLevelAtom.reportWrite(value, super._driverSeatHeatLevel,
        () {
      super._driverSeatHeatLevel = value;
    });
  }

  late final _$_driverSeatVentilationLevelAtom = Atom(
      name: 'AutomotiveStoreBase._driverSeatVentilationLevel',
      context: context);

  int get driverSeatVentilationLevel {
    _$_driverSeatVentilationLevelAtom.reportRead();
    return super._driverSeatVentilationLevel;
  }

  @override
  int get _driverSeatVentilationLevel => driverSeatVentilationLevel;

  @override
  set _driverSeatVentilationLevel(int value) {
    _$_driverSeatVentilationLevelAtom
        .reportWrite(value, super._driverSeatVentilationLevel, () {
      super._driverSeatVentilationLevel = value;
    });
  }

  late final _$_passengerSeatHeatLevelAtom = Atom(
      name: 'AutomotiveStoreBase._passengerSeatHeatLevel', context: context);

  int get passengerSeatHeatLevel {
    _$_passengerSeatHeatLevelAtom.reportRead();
    return super._passengerSeatHeatLevel;
  }

  @override
  int get _passengerSeatHeatLevel => passengerSeatHeatLevel;

  @override
  set _passengerSeatHeatLevel(int value) {
    _$_passengerSeatHeatLevelAtom
        .reportWrite(value, super._passengerSeatHeatLevel, () {
      super._passengerSeatHeatLevel = value;
    });
  }

  late final _$_passengerSeatVentilationLevelAtom = Atom(
      name: 'AutomotiveStoreBase._passengerSeatVentilationLevel',
      context: context);

  int get passengerSeatVentilationLevel {
    _$_passengerSeatVentilationLevelAtom.reportRead();
    return super._passengerSeatVentilationLevel;
  }

  @override
  int get _passengerSeatVentilationLevel => passengerSeatVentilationLevel;

  @override
  set _passengerSeatVentilationLevel(int value) {
    _$_passengerSeatVentilationLevelAtom
        .reportWrite(value, super._passengerSeatVentilationLevel, () {
      super._passengerSeatVentilationLevel = value;
    });
  }

  late final _$_passengerSeatSettingsAtom = Atom(
      name: 'AutomotiveStoreBase._passengerSeatSettings', context: context);

  SeatSettings get passengerSeatSettings {
    _$_passengerSeatSettingsAtom.reportRead();
    return super._passengerSeatSettings;
  }

  @override
  SeatSettings get _passengerSeatSettings => passengerSeatSettings;

  @override
  set _passengerSeatSettings(SeatSettings value) {
    _$_passengerSeatSettingsAtom
        .reportWrite(value, super._passengerSeatSettings, () {
      super._passengerSeatSettings = value;
    });
  }

  late final _$setDriverSeatSettingsAsyncAction = AsyncAction(
      'AutomotiveStoreBase.setDriverSeatSettings',
      context: context);

  @override
  Future<void> setDriverSeatSettings(SeatSettings seat) {
    return _$setDriverSeatSettingsAsyncAction
        .run(() => super.setDriverSeatSettings(seat));
  }

  late final _$setPassengerSeatSettingsAsyncAction = AsyncAction(
      'AutomotiveStoreBase.setPassengerSeatSettings',
      context: context);

  @override
  Future<void> setPassengerSeatSettings(SeatSettings seat) {
    return _$setPassengerSeatSettingsAsyncAction
        .run(() => super.setPassengerSeatSettings(seat));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
