import 'package:flutter/material.dart';
import 'package:libac_dart/nbt/Tag.dart';
import 'package:libac_dart/nbt/impl/StringTag.dart';

class InputPrompt extends StatefulWidget {
  String titleText;
  String PromptText;
  String value;
  InputPrompt(
      {required this.titleText,
      required this.PromptText,
      super.key,
      this.value = ""});

  @override
  State<StatefulWidget> createState() {
    return InputPromptState(
        title: Text(titleText), prompt: Text(PromptText), value: value);
  }
}

class InputPromptState extends State<InputPrompt> {
  final Widget title;
  final Widget prompt;
  TextEditingController _editor = TextEditingController();

  InputPromptState({required this.title, required this.prompt, String? value}) {
    if (value != null) _editor.text = value;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: title,
        actions: [
          ElevatedButton(
              onPressed: () async {
                Navigator.pop(context, _editor.text);
              },
              child: Text("Confirm")),
          ElevatedButton(
              onPressed: () async {
                Navigator.pop(context, "");
              },
              child: Text("Cancel"))
        ],
        content: SizedBox(
          width: 200,
          height: 100,
          child: Column(children: [
            prompt,
            TextField(
              controller: _editor,
            )
          ]),
        ));
  }
}

class EditValuePrompt extends StatefulWidget {
  const EditValuePrompt({super.key});

  @override
  State<StatefulWidget> createState() {
    return EditValueState();
  }
}

class EditValueState extends State<EditValuePrompt> {
  TagType TagValueType = TagType.String;
  Tag MainTag = StringTag.valueOf("str");

  TextEditingController TEC = TextEditingController();

  @override
  void didChangeDependencies() {
    var args = ModalRoute.of(context)!.settings.arguments;

    if (args == null) return;

    if (args is Tag) {
      Tag tag = args;
      setState(() {
        TagValueType = tag.getTagType();
        MainTag = tag;

        TEC.text = "${MainTag.getValue()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        icon: const Icon(Icons.edit_document),
        title: Text("Edit Value - ${MainTag.getKey()}"),
        actions: [
          ElevatedButton(
              onPressed: () {
                dynamic val = TEC.text;
                switch (MainTag.getTagType()) {
                  case TagType.Byte:
                  case TagType.Int:
                  case TagType.Long:
                  case TagType.Short:
                    {
                      val = int.parse(val);
                      break;
                    }
                  case TagType.Double:
                  case TagType.Float:
                    {
                      val = double.parse(val);
                      break;
                    }

                  default:
                    {
                      break;
                    }
                }
                Navigator.pop(context, val);
              },
              child: const Text("Submit")),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"))
        ],
        content: TextField(
          controller: TEC,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ));
  }
}
