
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:libac_dart/nbt/NbtIo.dart';
import 'package:libac_dart/nbt/SnbtIo.dart';
import 'package:libac_dart/nbt/Tag.dart';
import 'package:libac_dart/nbt/impl/CompoundTag.dart';
import 'package:nbteditor/Constants.dart';
import 'package:nbteditor/Consts2.dart';
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

  void didChangeState() {
    setState(() {});
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
              Text("Created by Tara Piccari"),
              Text("Version: $VERSION")
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
          ),
          ListTile(
            title: const Text("S A V E  N B T"),
            subtitle: const Text("Save to NBT"),
            leading: const Image(
              image: AssetImage("Icons/PNG/AppLogo.png"),
            ),
            onTap: () async {
              // Prompt for where to save
              String? filePath = await FilePicker.platform
                  .saveFile(dialogTitle: "Where do you want to save the file?");
              if (filePath == null) {
                print("No file selected");
                return;
              }
              print(filePath);

              var result = await showDialog(
                  context: context,
                  builder: (builder) {
                    return AlertDialog(
                      title: const Text("Compress the data?"),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text("YES")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("No"))
                      ],
                    );
                  });

              if (result == null) {
                // Save uncompressed
                NbtIo.write(
                    filePath, controller.children[0].data as CompoundTag);
              } else {
                NbtIo.writeCompressed(
                    filePath, controller.children[0].data as CompoundTag);
              }
            },
          ),
          ListTile(
            title: const Text("S A V E  S N B T"),
            subtitle: const Text("Save to SNBT"),
            leading: const Image(
              image: AssetImage("Icons/PNG/String.png"),
            ),
            onTap: () async {
              // Prompt for where to save
              String? filePath = await FilePicker.platform
                  .saveFile(dialogTitle: "Where do you want to save the file?");
              if (filePath == null) {
                print("No file selected");
                return;
              }
              print(filePath);

              SnbtIo.writeToFile(
                  filePath, controller.children[0].data as CompoundTag);
            },
          )
        ]),
      ),
      body: TreeView(
        nodeBuilder: (context, node) {
          if (node.data is Tag) {
            return TagExt.render(node.data as Tag, context, didChangeState);
          } else {
            return ListTile(
              title: Text(node.label),
            );
          }
        },
        controller: controller,
      ),
    );
  }
}
