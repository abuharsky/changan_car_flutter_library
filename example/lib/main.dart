import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:android_automotive_plugin/car/hvac_property_ids.dart';
import 'package:android_automotive_plugin/car/vehicle_area_seat.dart';
import 'package:android_automotive_plugin_example/accessibility_service.dart';
import 'package:android_automotive_plugin_example/automotive_store.dart';
import 'package:android_automotive_plugin_example/background_service.dart';
import 'package:android_automotive_plugin_example/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeBackgroundService();
  await initializeAccessibilityService();

  final store = AutomotiveStore();
  runApp(MyApp(store: store));
}

class MyApp extends StatefulWidget {
  final AutomotiveStore store;
  const MyApp({super.key, required this.store});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark,
      home: HomePage(store: widget.store),
    );
  }
}
