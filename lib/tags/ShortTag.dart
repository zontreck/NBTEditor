import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:libac_dart/nbt/impl/ShortTag.dart';

import 'Tag.dart';

extension ShortTagExt on ShortTag {
  Node getNode(String path) {
    return Node(key: path, label: "TAG_Short ${getKey()}", data: this);
  }

  Widget render() {
    return ListTile(
      title: Text("TAG_Short (${getKey()})"),
      subtitle: TagExt.getElementDescriptor(
          "${value}", false, true, canBeNamed(this)),
    );
  }
}
