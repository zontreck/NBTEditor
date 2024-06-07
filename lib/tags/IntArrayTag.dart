import 'package:flutter/material.dart';
import 'package:flutter_treeview/src/models/node.dart';
import 'package:libac_dart/nbt/impl/IntArrayTag.dart';

import 'Tag.dart';

extension IntArrayTagExt on IntArrayTag {
  Node getNode(String path) {
    List<Node> entries = [];
    int count = 0;
    for (var element in value) {
      entries.add(Node(key: "$path/$count", label: "$element", data: element));
      count++;
    }

    return Node(
        key: path,
        label: "TAG_IntArray (${getKey()})",
        data: this,
        children: entries);
  }

  Widget render() {
    return ListTile(
      title: Text("TAG_IntArray (${getKey()})"),
      subtitle: TagExt.getElementDescriptor(
          "${value.length} entries", true, false, canBeNamed(this)),
    );
  }
}
