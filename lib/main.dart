import 'package:flutter/material.dart';
import 'package:nbteditor/Editor.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      routes: {"/": (context) => const Editor()},
    );
  }
}
