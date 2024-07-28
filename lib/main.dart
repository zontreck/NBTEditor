import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nbteditor/Editor.dart';
import 'package:nbteditor/pages/AddPage.dart';
import 'package:nbteditor/pages/SNBTEditor.dart';
import 'package:nbteditor/pages/permsrequired.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({
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
    } else {
      return false;
    }
  } else {
    return false;
  }
}
