import 'package:flutter/material.dart';
import 'package:flutter_treeview/src/models/node.dart';
import 'package:libac_dart/nbt/impl/DoubleTag.dart';
import 'package:nbteditor/tags/Tag.dart';

extension DoubleTagExt on DoubleTag {
  Node getNode(String path) {
    return Node(key: path, label: "TAG_Double ${getKey()}", data: this);
  }

  Widget render(BuildContext context) {
    return ListTile(
      title: Text("TAG_Double (${getKey()})"),
      subtitle: TagExt.getElementDescriptor(
          "${value}", false, true, canBeNamed(this), this, context),
    );
  }
}
