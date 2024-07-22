import 'package:flutter/material.dart';
import 'package:libac_dart/nbt/Tag.dart';
import 'package:libac_dart/nbt/impl/StringTag.dart';

class EditValuePrompt extends StatefulWidget {
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
      Tag tag = args as Tag;
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
        icon: Icon(Icons.edit_document),
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
              child: Text("Submit")),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"))
        ],
        content: TextField(
          controller: TEC,
          decoration: InputDecoration(border: OutlineInputBorder()),
        ));
  }
}
