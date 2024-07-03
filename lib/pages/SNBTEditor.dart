import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/vs.dart';
import 'package:libac_dart/nbt/SnbtIo.dart';
import 'package:libac_dart/nbt/impl/CompoundTag.dart';
import 'package:nbteditor/Constants.dart';
import 'package:nbteditor/SessionData.dart';

class SnbtEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SnbtState();
  }
}

class SnbtState extends State<SnbtEdit> {
  CodeController snbt = CodeController();

  @override
  void didChangeDependencies() {
    snbt.text = SnbtIo.writeToString(SessionData.ROOT_TAG);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SNBT Editor"),
        backgroundColor: Constants.TITLEBAR_COLOR,
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          try {
            CompoundTag ct =
                (await SnbtIo.readFromString(snbt.text)).asCompoundTag();
            snbt.text = SnbtIo.writeToString(ct);

            setState(() {
              SessionData.ROOT_TAG = ct;
            });

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Successfully edited NBT data")));
          } catch (E) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("FATAL ERROR: Your SNBT Syntax is not valid")));
          }
        },
        child: Text("Compile"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: CodeTheme(
          data: CodeThemeData(styles: vsTheme),
          child: SingleChildScrollView(
            child: CodeField(
              controller: snbt,
            ),
          ),
        ),
      ),
    );
  }
}
