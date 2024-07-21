import 'package:flutter/material.dart';
import 'package:flutter_treeview/src/models/node.dart';
import 'package:libac_dart/nbt/impl/FloatTag.dart';

import 'Tag.dart';

extension FloatTagExt on FloatTag {
  Node getNode(String path) {
    return Node(key: path, label: "TAG_Float ${getKey()}", data: this);
  }

  Widget render(BuildContext context) {
    return ListTile(
      title: Text("TAG_Float (${getKey()})"),
      subtitle: TagExt.getElementDescriptor(
          "$value", false, true, canBeNamed(this), this, context),
      leading: const Image(image: AssetImage("Icons/PNG/Float.png")),
    );
  }
}
