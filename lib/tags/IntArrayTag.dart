import 'package:flutter/material.dart';
import 'package:flutter_treeview/src/models/node.dart';
import 'package:nbteditor/tags/NbtIo.dart';
import 'package:nbteditor/tags/Tag.dart';
import 'package:nbteditor/tags/TagType.dart';

class IntArrayTag extends Tag {
  final List<int> _value = [];

  @override
  Node getNode(String path) {
    List<Node> entries = [];
    int count = 0;
    for (var element in _value) {
      entries.add(Node(key: "$path/$count", label: "$element"));
      count++;
    }

    return Node(key: path, label: Name, data: this, children: entries);
  }

  @override
  void readHeader(ByteLayer layer) {
    setName(layer.readTagName());
  }

  @override
  void readValue(ByteLayer layer) {
    int count = layer.readInt();
    for (int i = 0; i < count; i++) {
      _value.add(layer.readInt());
    }
  }

  @override
  Widget render() {
    return ListTile(
      title: Text("TAG_IntArray ($Name)"),
      subtitle: Text("${_value.length} entries"),
    );
  }

  @override
  void writeHeader(ByteLayer layer) {
    layer.writeTagName(Name);
  }

  @override
  void writeTagType(ByteLayer layer) {
    layer.writeByte(TagType.IntArray.toByte());
  }

  @override
  void writeValue(ByteLayer layer) {
    layer.writeInt(_value.length);

    for (var element in _value) {
      layer.writeInt(element);
    }
  }

  @override
  TagType getTagType() {
    return TagType.IntArray;
  }
}
