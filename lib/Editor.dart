import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:nbteditor/Constants.dart';
import 'package:nbteditor/tags/CompoundTag.dart';
import 'package:nbteditor/tags/NbtIo.dart';
import 'package:nbteditor/tags/Tag.dart';

class Editor extends StatefulWidget {
  Editor({super.key});

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
    } else
      return "";
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
          DrawerHeader(
              child: Column(
            children: [
              Text("Named Binary Tag Editor"),
              Text("Created by Tara Piccari")
            ],
          )),
          ListTile(
            title: Text("N E W"),
            subtitle: Text("Create a new NBT Document"),
            leading: Icon(Icons.add),
            onTap: () {
              setState(() {
                nodes.clear();

                // Add a new compound tag as the root
                Tag tag = CompoundTag();
                nodes.add(tag.getNode("/"));
              });
            },
          ),
          ListTile(
            title: Text("O P E N"),
            leading: Icon(Icons.folder),
            subtitle: Text("Open an existing NBT Document for editing"),
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
                compressed = await NbtIo.read(filePath);
              }

              setState(() {
                nodes.clear();
                nodes.add(Tag.read(NbtIo.getStream()).getNode("/"));

                controller = TreeViewController(children: nodes);
              });
            },
          )
        ]),
      ),
      body: TreeView(
        nodeBuilder: (context, node) {
          return (node.data as Tag).render();
        },
        controller: controller,
      ),
    );
  }
}

class FileSelectionScreen extends StatelessWidget {
  Future<void> openFilePicker(BuildContext context) async {
    try {} catch (e) {
      // Handle errors
      print('Error selecting file: $e');
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Selection'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => openFilePicker(context),
          child: Text('Select File'),
        ),
      ),
    );
  }
}
