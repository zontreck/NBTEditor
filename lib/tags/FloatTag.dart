import 'package:flutter/material.dart';
import 'package:flutter_treeview/src/models/node.dart';
import 'package:libac_dart/nbt/impl/FloatTag.dart';

import 'Tag.dart';

extension FloatTagExt on FloatTag {
  Node getNode(String path) {
    return Node(key: path, label: "TAG_Float ${getKey()}", data: this);
  }

  Widget render(BuildContext context, Function didChangeState) {
    return ListTile(
      title: Text("TAG_Float (${getKey()})"),
      subtitle: TagExt.getElementDescriptor("$value"),
      leading: TagExt.getTagIcon(getTagType()),
      trailing: TagExt.getElementButtons(
          false, canBeNamed(this), true, this, context, didChangeState),
    );
  }
}
