import 'package:flutter/material.dart';
import 'package:nbteditor/Constants.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsRequiredPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("NBT Editor - Permissions Denied"),
          backgroundColor: Constants.TITLEBAR_COLOR,
        ),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                      "We require only one permission, it is being denied by your device. Please grant file permissions to be able to open or save files."),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (await Permission.manageExternalStorage.isDenied) {
                        var stat =
                            await Permission.manageExternalStorage.request();
                        if (stat.isPermanentlyDenied) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "The storage permission is reporting it is permanently denied. Please open settings and allow that permission.")));
                        } else if (stat.isGranted) {
                          Future.delayed(Duration(seconds: 5), () {
                            Navigator.pushReplacementNamed(context, "/edit");
                          });
                        }
                      }
                    },
                    child: Text("GRANT"))
              ],
            ),
          ),
        ));
  }
}
