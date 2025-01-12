// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_settings_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SeatSettingsStore on _SeatSettingsStore, Store {
  late final _$driverSeatSettingsAtom =
      Atom(name: '_SeatSettingsStore.driverSeatSettings', context: context);

  @override
  SeatSettings get driverSeatSettings {
    _$driverSeatSettingsAtom.reportRead();
    return super.driverSeatSettings;
  }

  @override
  set driverSeatSettings(SeatSettings value) {
    _$driverSeatSettingsAtom.reportWrite(value, super.driverSeatSettings, () {
      super.driverSeatSettings = value;
    });
  }

  late final _$passengerSeatSettingsAtom =
      Atom(name: '_SeatSettingsStore.passengerSeatSettings', context: context);

  @override
  SeatSettings get passengerSeatSettings {
    _$passengerSeatSettingsAtom.reportRead();
    return super.passengerSeatSettings;
  }

  @override
  set passengerSeatSettings(SeatSettings value) {
    _$passengerSeatSettingsAtom.reportWrite(value, super.passengerSeatSettings,
        () {
      super.passengerSeatSettings = value;
    });
  }

  late final _$_loadSettingsAsyncAction =
      AsyncAction('_SeatSettingsStore._loadSettings', context: context);

  @override
  Future<void> _loadSettings() {
    return _$_loadSettingsAsyncAction.run(() => super._loadSettings());
  }

  late final _$_saveSettingsAsyncAction =
      AsyncAction('_SeatSettingsStore._saveSettings', context: context);

  @override
  Future<void> _saveSettings() {
    return _$_saveSettingsAsyncAction.run(() => super._saveSettings());
  }

  late final _$setDriverSeatSettingsAsyncAction =
      AsyncAction('_SeatSettingsStore.setDriverSeatSettings', context: context);

  @override
  Future<void> setDriverSeatSettings(SeatSettings settings) {
    return _$setDriverSeatSettingsAsyncAction
        .run(() => super.setDriverSeatSettings(settings));
  }

  late final _$setPassengerSeatSettingsAsyncAction = AsyncAction(
      '_SeatSettingsStore.setPassengerSeatSettings',
      context: context);

  @override
  Future<void> setPassengerSeatSettings(SeatSettings settings) {
    return _$setPassengerSeatSettingsAsyncAction
        .run(() => super.setPassengerSeatSettings(settings));
  }

  @override
  String toString() {
    return '''
driverSeatSettings: ${driverSeatSettings},
passengerSeatSettings: ${passengerSeatSettings}
    ''';
  }
}
