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

  late final _$_driverSeatAutoHeatTimeAtom = Atom(
      name: 'AutomotiveStoreBase._driverSeatAutoHeatTime', context: context);

  SeatHeatTime get driverSeatAutoHeatTime {
    _$_driverSeatAutoHeatTimeAtom.reportRead();
    return super._driverSeatAutoHeatTime;
  }

  @override
  SeatHeatTime get _driverSeatAutoHeatTime => driverSeatAutoHeatTime;

  @override
  set _driverSeatAutoHeatTime(SeatHeatTime value) {
    _$_driverSeatAutoHeatTimeAtom
        .reportWrite(value, super._driverSeatAutoHeatTime, () {
      super._driverSeatAutoHeatTime = value;
    });
  }

  late final _$_driverSeatAutoHeatTempThresholdAtom = Atom(
      name: 'AutomotiveStoreBase._driverSeatAutoHeatTempThreshold',
      context: context);

  SeatHeatTempThreshold get driverSeatAutoHeatTempThreshold {
    _$_driverSeatAutoHeatTempThresholdAtom.reportRead();
    return super._driverSeatAutoHeatTempThreshold;
  }

  @override
  SeatHeatTempThreshold get _driverSeatAutoHeatTempThreshold =>
      driverSeatAutoHeatTempThreshold;

  @override
  set _driverSeatAutoHeatTempThreshold(SeatHeatTempThreshold value) {
    _$_driverSeatAutoHeatTempThresholdAtom
        .reportWrite(value, super._driverSeatAutoHeatTempThreshold, () {
      super._driverSeatAutoHeatTempThreshold = value;
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

  late final _$_passengerSeatAutoHeatTimeAtom = Atom(
      name: 'AutomotiveStoreBase._passengerSeatAutoHeatTime', context: context);

  SeatHeatTime get passengerSeatAutoHeatTime {
    _$_passengerSeatAutoHeatTimeAtom.reportRead();
    return super._passengerSeatAutoHeatTime;
  }

  @override
  SeatHeatTime get _passengerSeatAutoHeatTime => passengerSeatAutoHeatTime;

  @override
  set _passengerSeatAutoHeatTime(SeatHeatTime value) {
    _$_passengerSeatAutoHeatTimeAtom
        .reportWrite(value, super._passengerSeatAutoHeatTime, () {
      super._passengerSeatAutoHeatTime = value;
    });
  }

  late final _$_passengerSeatAutoHeatTempThresholdAtom = Atom(
      name: 'AutomotiveStoreBase._passengerSeatAutoHeatTempThreshold',
      context: context);

  SeatHeatTempThreshold get passengerSeatAutoHeatTempThreshold {
    _$_passengerSeatAutoHeatTempThresholdAtom.reportRead();
    return super._passengerSeatAutoHeatTempThreshold;
  }

  @override
  SeatHeatTempThreshold get _passengerSeatAutoHeatTempThreshold =>
      passengerSeatAutoHeatTempThreshold;

  @override
  set _passengerSeatAutoHeatTempThreshold(SeatHeatTempThreshold value) {
    _$_passengerSeatAutoHeatTempThresholdAtom
        .reportWrite(value, super._passengerSeatAutoHeatTempThreshold, () {
      super._passengerSeatAutoHeatTempThreshold = value;
    });
  }

  late final _$AutomotiveStoreBaseActionController =
      ActionController(name: 'AutomotiveStoreBase', context: context);

  @override
  void setSeatHeatLevel(bool isDriverSeat, int level) {
    final _$actionInfo = _$AutomotiveStoreBaseActionController.startAction(
        name: 'AutomotiveStoreBase.setSeatHeatLevel');
    try {
      return super.setSeatHeatLevel(isDriverSeat, level);
    } finally {
      _$AutomotiveStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSeatAutoHeatTime(bool isDriverSeat, SeatHeatTime time) {
    final _$actionInfo = _$AutomotiveStoreBaseActionController.startAction(
        name: 'AutomotiveStoreBase.setSeatAutoHeatTime');
    try {
      return super.setSeatAutoHeatTime(isDriverSeat, time);
    } finally {
      _$AutomotiveStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSeatAutoHeatTempTheshold(
      bool isDriverSeat, SeatHeatTempThreshold temp) {
    final _$actionInfo = _$AutomotiveStoreBaseActionController.startAction(
        name: 'AutomotiveStoreBase.setSeatAutoHeatTempTheshold');
    try {
      return super.setSeatAutoHeatTempTheshold(isDriverSeat, temp);
    } finally {
      _$AutomotiveStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
