import 'package:flutter/material.dart';
import 'package:flutter_treeview/src/models/node.dart';
import 'package:libac_dart/nbt/impl/ByteTag.dart';
import 'package:nbteditor/tags/Tag.dart';

extension ByteTagExt on ByteTag {
  Node getNode(String path) {
    return Node(key: path, label: "TAG_Byte ${getKey()}", data: this);
  }

  Widget render(BuildContext context, Function didChangeState) {
    return ListTile(
      title: Text("TAG_Byte (${getKey()})"),
      subtitle: TagExt.getElementDescriptor(
        "$value",
      ),
      leading: TagExt.getTagIcon(getTagType()),
      trailing: TagExt.getElementButtons(
          false, canBeNamed(this), true, this, context, didChangeState, true),
    );
  }
}
