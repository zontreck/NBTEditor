import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nbteditor/Editor.dart';
import 'package:nbteditor/pages/AddPage.dart';
import 'package:nbteditor/pages/SNBTEditor.dart';
import 'package:nbteditor/pages/permsrequired.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      routes: {
        "/": (context) => const Editor(),
        "/add": (context) => const AddPage(),
        "/snbt": (context) => const SnbtEdit(),
        "/perms": (context) => const PermissionsRequiredPage()
      },
    );
  }
}

bool needsPermissions() {
  return Platform.isIOS || Platform.isMacOS || Platform.isAndroid;
}

Future<bool> needsPermissionsPage() async {
  if (needsPermissions()) {
    if (await Permission.manageExternalStorage.isDenied) {
      return true;
    } else
      return false;
  } else
    return false;
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return StartPageState();
  }
}

class StartPageState extends State<StartPage> {
  @override
  void didChangeDependencies() {
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS)
      checkPermissions();
    else
      Navigator.pushReplacementNamed(context, "/edit");
  }

  Future<void> checkPermissions() async {
    if (await Permission.manageExternalStorage.isDenied) {
      await Future.delayed(const Duration(seconds: 5), () {
        Navigator.pushReplacementNamed(context, "/perms");
      });
    } else {
      await Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, "/edit");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          SizedBox(height: 100),
          Image(
            image: AssetImage("Icons/PNG/nbteditor.png"),
            height: 500,
            width: 500,
          )
        ],
      ),
    );
  }
}
