import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:libac_dart/nbt/impl/LongArrayTag.dart';

import 'Tag.dart';

extension LongArrayTagExt on LongArrayTag {
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

  Widget render(BuildContext context) {
    return ListTile(
      title: Text("TAG_LongArray (${getKey()})"),
      subtitle: TagExt.getElementDescriptor("${value.length} entries", true,
          false, canBeNamed(this), this, context),
      leading: const Image(image: AssetImage("Icons/PNG/LongArray.png")),
    );
  }
}
