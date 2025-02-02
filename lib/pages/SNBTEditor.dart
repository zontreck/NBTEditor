import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/vs.dart';
import 'package:libac_dart/nbt/SnbtIo.dart';
import 'package:libac_dart/nbt/impl/CompoundTag.dart';
import 'package:libacflutter/Prompt.dart';
import 'package:nbteditor/Constants.dart';
import 'package:nbteditor/SessionData.dart';
import 'package:nbteditor/pages/EditValue.dart';

class SnbtEdit extends StatefulWidget {
  const SnbtEdit({super.key});

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
        title: const Text("SNBT Editor"),
        backgroundColor: Constants.TITLEBAR_COLOR,
        actions: [
          IconButton(
              onPressed: () async {
                var searchResponse = await showCupertinoDialog(
                    context: context,
                    builder: (searchBuilder) {
                      return InputPrompt(
                          title: "Search",
                          prompt: "What do you want to search for?",
                          type: InputPromptType.Text);
                    });
              },
              icon: Icon(CupertinoIcons.search))
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          try {
            CompoundTag ct =
                (await SnbtIo.readFromString(snbt.text)).asCompoundTag();
            snbt.setCursor(0);

            setState(() {
              SessionData.ROOT_TAG = ct;
            });

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Successfully edited NBT data")));

            Navigator.pop(context);
          } catch (E) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("FATAL ERROR: Your SNBT Syntax is not valid")));
          }
        },
        child: const Text("Compile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
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
