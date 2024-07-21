import 'package:flutter/material.dart';
import 'package:flutter_treeview/src/models/node.dart';
import 'package:libac_dart/nbt/impl/ByteArrayTag.dart';
import 'package:nbteditor/tags/Tag.dart';

extension ByteArrayTagExt on ByteArrayTag {
  Node getNode(String path) {
    List<Node> entries = [];
    int count = 0;
    for (var element in value) {
      entries.add(Node(key: "$path/$count", label: "$element", data: element));
      count++;
    }

    return Node(
        key: path,
        label: "TAG_ByteArray (${getKey()})",
        data: this,
        children: entries);
  }

  Widget render(BuildContext context) {
    return ListTile(
      title: Text("TAG_ByteArray (${getKey()})"),
      leading: const Image(image: AssetImage("Icons/PNG/ByteArray.png")),
      subtitle: TagExt.getElementDescriptor("${value.length} entries"),
      trailing: TagExt.getElementButtons(
          true, canBeNamed(this), false, this, context),
    );
  }
}
