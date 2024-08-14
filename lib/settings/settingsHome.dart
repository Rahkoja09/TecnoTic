// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class settingsHome extends StatefulWidget {
  const settingsHome({super.key});

  @override
  State<settingsHome> createState() => _settingsHomeState();
}

class _settingsHomeState extends State<settingsHome> {
  @override
  Widget build(BuildContext context) {
    AppBar(
      title: const Text("Paramettres"),
    );
    return const SafeArea(
      child: SingleChildScrollView(
        child: Scaffold(),
      ),
    );
  }
}
