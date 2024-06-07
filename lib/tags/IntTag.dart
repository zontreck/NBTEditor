import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:libac_dart/nbt/impl/IntTag.dart';

import 'Tag.dart';

extension IntTagExt on IntTag {
  Node getNode(String path) {
    return Node(key: path, label: "TAG_Int ${getKey()}", data: this);
  }

  Widget render() {
    return ListTile(
      title: Text("TAG_Int (${getKey()})"),
      subtitle: TagExt.getElementDescriptor(
          "${value}", false, true, canBeNamed(this)),
    );
  }
}
