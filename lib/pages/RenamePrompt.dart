import 'package:flutter/material.dart';

class RenamePrompt extends StatefulWidget {
  const RenamePrompt({super.key});

  @override
  State<StatefulWidget> createState() {
    return RenameState();
  }
}

class RenameState extends State<RenamePrompt> {
  TextEditingController name = TextEditingController();

  @override
  void didChangeDependencies() {
    var args = ModalRoute.of(context)!.settings.arguments as String;

    name.text = args;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        icon: const Icon(Icons.edit_attributes),
        title: const Text("Edit Tag Name"),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context, name.text);
              },
              child: const Text("SUBMIT")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("CANCEL"),
          )
        ],
        content: TextField(
          controller: name,
        ));
  }
}
