import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:libac_dart/nbt/impl/CompoundTag.dart';
import 'package:nbteditor/tags/Tag.dart';

extension CompoundTagExt on CompoundTag {
  Widget render(BuildContext context, Function didChangeState) {
    return ListTile(
      title: Text("TAG_Compound (${getKey()})"),
      subtitle: TagExt.getElementDescriptor(
        value.length == 0
            ? "No Tags"
            : ("${value.length} tag${value.length > 1 ? "s" : ""}"),
      ),
      leading: TagExt.getTagIcon(getTagType()),
      trailing: TagExt.getElementButtons(
          true, canBeNamed(this), false, this, context, didChangeState),
    );
  }

  Node getNode(String path) {
    List<Node> childTags = [];

    for (var element in value.entries) {
      childTags.add(TagExt.getNode("$path/${element.key}", element.value));
    }
    Node me = Node(key: path, label: getKey(), data: this, children: childTags);
    return me;
  }
}
