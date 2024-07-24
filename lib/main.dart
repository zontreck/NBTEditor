import 'package:flutter/material.dart';
import 'package:nbteditor/Editor.dart';
import 'package:nbteditor/pages/AddPage.dart';
import 'package:nbteditor/pages/SNBTEditor.dart';
import 'package:nbteditor/pages/permsrequired.dart';
import 'package:permission_handler/permission_handler.dart';

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
        "/": (context) => StartPage(),
        "/edit": (context) => const Editor(),
        "/add": (context) => const AddPage(),
        "/snbt": (context) => const SnbtEdit(),
        "/perms": (context) => PermissionsRequiredPage()
      },
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StartPageState();
  }
}

class StartPageState extends State<StartPage> {
  @override
  void didChangeDependencies() {
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    if (await Permission.manageExternalStorage.isDenied) {
      await Future.delayed(Duration(seconds: 5), () {
        Navigator.pushReplacementNamed(context, "/perms");
      });
    } else {
      Navigator.pushReplacementNamed(context, "/edit");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Image(image: AssetImage("Icons/PNG/nbteditor.png"))],
      ),
    );
  }
}
