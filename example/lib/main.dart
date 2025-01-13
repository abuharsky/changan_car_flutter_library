import 'package:android_automotive_plugin_example/accessibility_service.dart';
import 'package:android_automotive_plugin_example/background_service.dart';
import 'package:android_automotive_plugin_example/home_page.dart';
import 'package:android_automotive_plugin_example/new/automotive_adapter.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeBackgroundService();
  await initializeAccessibilityService();

  final automotiveAdapter = AutomotiveAdapter();

  runApp(MyApp(automotiveAdapter: automotiveAdapter));
}

class MyApp extends StatefulWidget {
  final AutomotiveAdapter automotiveAdapter;

  const MyApp({super.key, required this.automotiveAdapter});

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
      home: HomePage(automotiveAdapter: widget.automotiveAdapter),
    );
  }
}
