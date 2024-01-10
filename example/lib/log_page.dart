import 'dart:convert';

import 'package:android_automotive_plugin_example/automotive_store.dart';
import 'package:android_automotive_plugin_example/file_writer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class LogPage extends StatelessWidget {
  final AutomotiveStore automotiveStore;

  LogPage({super.key, required this.automotiveStore});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logs"),
        actions: [
          ElevatedButton(
            onPressed: () {
              try {
                FileWriter.writeFileToDownloadsDir(
                    utf8.encode(automotiveStore.log), "log.txt");
              } catch (e) {
                print(e);
              }
            },
            child: const Text("Save log"),
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white24),
        ),
        child: Scrollbar(
          controller: _scrollController,
          child: Observer(
            builder: (context) => SingleChildScrollView(
              controller: _scrollController,
              child: Text(
                automotiveStore.log,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
