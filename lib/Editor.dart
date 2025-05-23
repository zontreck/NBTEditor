import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:libac_dart/nbt/NbtIo.dart';
import 'package:libac_dart/nbt/SnbtIo.dart';
import 'package:libac_dart/nbt/Tag.dart';
import 'package:libac_dart/nbt/impl/ByteArrayTag.dart';
import 'package:libac_dart/nbt/impl/CompoundTag.dart';
import 'package:libac_dart/nbt/impl/IntArrayTag.dart';
import 'package:libac_dart/nbt/impl/LongArrayTag.dart';
import 'package:libacflutter/Prompt.dart';
import 'package:nbteditor/Constants.dart';
import 'package:nbteditor/Consts2.dart';
import 'package:nbteditor/SessionData.dart';
import 'package:nbteditor/main.dart';
import 'package:nbteditor/tags/ArrayEntry.dart';
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
        actions: [
          IconButton(
              onPressed: () async {
                // Show input prompt
                var searchResponse = await showCupertinoDialog(
                    context: context,
                    builder: (dialogBuilder) {
                      return InputPrompt(
                          title: "What tag name to search for?",
                          prompt:
                              "Enter the tag name or value you want to search for",
                          type: InputPromptType.Text);
                    });
              },
              icon: const Icon(CupertinoIcons.search_circle))
        ],
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
            subtitle:
                const Text("Open an existing NBT/SNBT Document for editing"),
            onTap: () async {
              if (await needsPermissionsPage()) {
                Navigator.pushNamed(context, "/perms");
                return;
              }
              XTypeGroup typeGroup = const XTypeGroup(
                  label: 'NBT', extensions: <String>["nbt", "snbt", "dat"]);
              var result =
                  await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
              String? filePath;
              if (result != null) {
                // Do something with the selected file path
                print('Selected file path: $filePath');
                filePath = result.path;
              } else {
                // User canceled the picker
                print('File selection canceled.');
              }
              if (filePath == null) {
                // cancelled
                return;
              } else {
                // String!!
                CompoundTag ct = CompoundTag();
                if (filePath.endsWith(".txt") || filePath.endsWith(".snbt")) {
                  var strData = await result!.readAsString();
                  ct = await SnbtIo.readFromString(strData) as CompoundTag;
                } else {
                  var data = await result!.readAsBytes();
                  ct = await NbtIo.readFromStream(data) as CompoundTag;
                }

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
              image: AssetImage("Icons/PNG/Compound.png"),
            ),
            onTap: () async {
              if (await needsPermissionsPage()) {
                Navigator.pushNamed(context, "/perms");
                return;
              }
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

              // Prompt for where to save
              print("Begin picking file to save to");
              var FSL = await getSaveLocation();
              String? filePath;

              if (FSL != null) {
                filePath = FSL.path;
              }

              if (filePath == null) {
                print("No file selected");
                return;
              }
              print(filePath);
              CompoundTag tag = controller.children[0].data as CompoundTag;
              Uint8List data = Uint8List(0);
              if (result == null) {
                // Save uncompressed
                data = await NbtIo.writeToStream(tag);
              } else {
                data = await NbtIo.writeToStreamCompressed(tag);
              }
              var dataFile = XFile.fromData(data);
              await dataFile.saveTo(filePath);
            },
          ),
          ListTile(
            title: const Text("S A V E  S N B T"),
            subtitle: const Text("Save to SNBT"),
            leading: const Image(
              image: AssetImage("Icons/PNG/String.png"),
            ),
            onTap: () async {
              if (await needsPermissionsPage()) {
                Navigator.pushNamed(context, "/perms");
                return;
              }
              // Prompt for where to save
              print("Begin picking file to save to");
              var FSL = await getSaveLocation();
              String? filePath;

              if (FSL != null) {
                filePath = FSL.path;
              }

              if (filePath == null) {
                print("No file selected");
                return;
              }
              print(filePath);
              Uint8List data = Uint8List(0);

              String str = SnbtIo.writeToString(
                  controller.children[0].data as CompoundTag);

              var dataFile = XFile.fromData(Uint8List.fromList(str.codeUnits));
              await dataFile.saveTo(filePath);
            },
          )
        ]),
      ),
      body: TreeView(
        nodeBuilder: (context, node) {
          if (node.data is Tag) {
            return TagExt.render(node.data as Tag, context, didChangeState);
          } else if (node.data is ArrayEntry) {
            ArrayEntry entry = node.data as ArrayEntry;
            return ListTile(
              title: Text(entry.value),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Delete entry
                  ElevatedButton(
                      onPressed: () {
                        if (entry.parent is ByteArrayTag) {
                          ByteArrayTag bat = entry.parent as ByteArrayTag;
                          bat.value.removeAt(entry.index);
                        }
                        if (entry.parent is IntArrayTag) {
                          IntArrayTag iat = entry.parent as IntArrayTag;
                          iat.value.removeAt(entry.index);
                        }
                        if (entry.parent is LongArrayTag) {
                          LongArrayTag lat = entry.parent as LongArrayTag;
                          lat.value.removeAt(entry.index);
                        }

                        didChangeState();
                      },
                      child: const Icon(Icons.delete_forever))
                ],
              ),
            );
          } else {
            return ListTile(title: Text(node.label));
          }
        },
        controller: controller,
      ),
    );
  }
}
