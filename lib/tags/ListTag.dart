import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:libac_dart/nbt/Tag.dart';
import 'package:libac_dart/nbt/impl/ListTag.dart';
import 'package:nbteditor/tags/Tag.dart';

extension ListTagExt on ListTag {
  Node getNode(String path) {
    List<Node> nodes = [];

    int count = 0;
    for (var element in value) {
      nodes.add(TagExt.getNode("$path/$count", element));
      count++;
    }

    return Node(key: path, label: getKey(), data: this, children: nodes);
  }

  Widget render() {
    TagType type = TagType.End;
    if (value.length > 0) type = get(0).getTagType();

    return ListTile(
        title: Text("TAG_List (${getKey()}) (${type})"),
        subtitle: TagExt.getElementDescriptor(
            "${value.length} entries", true, false, canBeNamed(this)));
  }
}
