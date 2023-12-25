import 'package:flutter/material.dart';
import 'package:flutter_treeview/src/models/node.dart';
import 'package:nbteditor/tags/NbtIo.dart';
import 'package:nbteditor/tags/Tag.dart';
import 'package:nbteditor/tags/TagType.dart';

class ShortTag extends Tag {
  int _value = 0;

  @override
  Node getNode(String path) {
    return Node(key: path, label: "$_value", data: this);
  }

  @override
  void readHeader(ByteLayer layer) {
    setName(layer.readTagName());
  }

  @override
  void readValue(ByteLayer layer) {
    _value = layer.readShort();
  }

  @override
  Widget render() {
    return ListTile(
      title: Text("TAG_Short ($Name)"),
      subtitle: Text("$_value"),
    );
  }

  @override
  void writeHeader(ByteLayer layer) {
    layer.writeTagName(Name);
  }

  @override
  void writeTagType(ByteLayer layer) {
    layer.writeByte(TagType.Short.toByte());
  }

  @override
  void writeValue(ByteLayer layer) {
    layer.writeShort(_value);
  }

  @override
  TagType getTagType() {
    return TagType.Short;
  }
}
