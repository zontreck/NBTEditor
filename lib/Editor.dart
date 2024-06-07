import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:libac_dart/nbt/NbtIo.dart';
import 'package:libac_dart/nbt/Tag.dart';
import 'package:libac_dart/nbt/impl/CompoundTag.dart';
import 'package:nbteditor/Constants.dart';
import 'package:nbteditor/tags/CompoundTag.dart';
import 'package:nbteditor/tags/Tag.dart';

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  EditorState createState() => EditorState();
}

class EditorState extends State<Editor> {
  List<Node> nodes = [CompoundTag().getNode("/")];
  bool compressed = false;

  late TreeViewController controller;

  String appendCompressed() {
    if (compressed) {
      return " - Compressed";
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    controller = TreeViewController(children: nodes);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.TITLEBAR_COLOR,
        title: Text("Named Binary Tag Editor${appendCompressed()}"),
      ),
      drawer: Drawer(
        backgroundColor: Constants.DRAWER_COLOR,
        child: Column(children: [
          const DrawerHeader(
              child: Column(
            children: [
              Text("Named Binary Tag Editor"),
              Text("Created by Tara Piccari")
            ],
          )),
          ListTile(
            title: const Text("N E W"),
            subtitle: const Text("Create a new NBT Document"),
            leading: const Icon(Icons.add),
            onTap: () {
              setState(() {
                nodes.clear();

                // Add a new compound tag as the root
                Tag tag = CompoundTag();
                nodes.add(TagExt.getNode("/", tag) as Node);
              });
            },
          ),
          ListTile(
            title: const Text("O P E N"),
            leading: const Icon(Icons.folder),
            subtitle: const Text("Open an existing NBT Document for editing"),
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              String? filePath;
              if (result != null) {
                filePath = result.files.single.path;
                // Do something with the selected file path
                print('Selected file path: $filePath');
              } else {
                // User canceled the picker
                print('File selection canceled.');
              }
              if (filePath == null) {
                // cancelled
                return;
              } else {
                // String!!
                CompoundTag ct = await NbtIo.read(filePath);
                nodes.clear();
                nodes.add(ct.getNode("/") as Node);
              }

              setState(() {
                controller = TreeViewController(children: nodes);
              });
            },
          )
        ]),
      ),
      body: TreeView(
        nodeBuilder: (context, node) {
          return TagExt.render(node.data as Tag, context);
        },
        controller: controller,
      ),
    );
  }
}
