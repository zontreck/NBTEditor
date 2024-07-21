import 'package:flutter/material.dart';
import 'package:flutter_treeview/src/models/node.dart';
import 'package:libac_dart/nbt/impl/DoubleTag.dart';
import 'package:nbteditor/tags/Tag.dart';

extension DoubleTagExt on DoubleTag {
  Node getNode(String path) {
    return Node(key: path, label: "TAG_Double ${getKey()}", data: this);
  }

  Widget render(BuildContext context, Function didChangeState) {
    return ListTile(
      title: Text("TAG_Double (${getKey()})"),
      subtitle: TagExt.getElementDescriptor("$value"),
      leading: const Image(image: AssetImage("Icons/PNG/Double.png")),
      trailing: TagExt.getElementButtons(
          false, canBeNamed(this), true, this, context, didChangeState),
    );
  }
}
