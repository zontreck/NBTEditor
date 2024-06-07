import 'package:flutter/material.dart';
import 'package:libac_dart/nbt/Tag.dart';
import 'package:nbteditor/Constants.dart';

class AddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddState();
}

class AddState extends State<AddPage> {
  @override
  void didChangeDependencies() {
    var args = ModalRoute.of(context)!.settings.arguments as AddElementArgs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Tag"),
        backgroundColor: Constants.TITLEBAR_COLOR,
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}

class AddElementArgs {
  Tag tag;
  AddElementArgs({required this.tag});
}
