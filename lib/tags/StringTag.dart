import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:libac_dart/nbt/impl/StringTag.dart';

import 'Tag.dart';

extension StringTagExt on StringTag {
  Node getNode(String path) {
    return Node(key: path, label: "TAG_String ${getKey()}", data: this);
  }

  Widget render(BuildContext context, Function didChangeState) {
    return ListTile(
      title: Text("TAG_String (${getKey()})"),
      subtitle: TagExt.getElementDescriptor(value),
      leading: TagExt.getTagIcon(getTagType()),
      trailing: TagExt.getElementButtons(
          false, canBeNamed(this), true, this, context, didChangeState),
    );
  }
}
