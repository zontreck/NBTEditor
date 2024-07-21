import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:libac_dart/nbt/NbtIo.dart';
import 'package:libac_dart/nbt/Tag.dart';
import 'package:libac_dart/nbt/impl/CompoundTag.dart';
import 'package:nbteditor/Constants.dart';
import 'package:nbteditor/SessionData.dart';
import 'package:nbteditor/tags/CompoundTag.dart';
import 'package:nbteditor/tags/Tag.dart';

class Editor extends StatefulWidget {
  const Editor({super.key});

  @override
  EditorState createState() => EditorState();
}

class EditorState extends State<Editor> {
  //List<Node> nodes = [CompoundTag().getNode("/")];
  bool compressed = false;

  static EditorState? _inst;
  EditorState._() {
    _inst = this;
  }
  late TreeViewController controller;
  factory EditorState() {
    if (_inst == null) {
      return EditorState._();
    } else {
      return _inst!;
    }
  }

  void update() {
    setState(() {});
  }

  String appendCompressed() {
    if (compressed) {
      return " - Compressed";
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    controller =
        TreeViewController(children: [SessionData.ROOT_TAG.getNode("/")]);

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
                SessionData.ROOT_TAG = CompoundTag();
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

                SessionData.ROOT_TAG = ct;
              }

              setState(() {
                controller = TreeViewController(
                    children: [SessionData.ROOT_TAG.getNode("/")]);
              });
            },
          ),
          ListTile(
            title: const Text("R A W"),
            subtitle: const Text("Edit as raw SNBT"),
            leading: const Icon(Icons.edit),
            onTap: () async {
              await Navigator.pushNamed(context, "/snbt");
              setState(() {});
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
