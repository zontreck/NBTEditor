import 'package:flutter/material.dart';
import 'package:nbteditor/Editor.dart';
import 'package:nbteditor/pages/AddPage.dart';
import 'package:nbteditor/pages/SNBTEditor.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      routes: {
        "/": (context) => const Editor(),
        "/add": (context) => AddPage(),
        "/snbt": (context) => SnbtEdit()
      },
    );
  }
}
