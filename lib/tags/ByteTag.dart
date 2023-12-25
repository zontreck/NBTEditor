import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_treeview/src/models/node.dart';
import 'package:nbteditor/tags/NbtIo.dart';
import 'package:nbteditor/tags/Tag.dart';
import 'package:nbteditor/tags/TagType.dart';

class ByteTag extends Tag {
  int _value = 0;

  @override
  Node getNode(String path) {
    return Node(key: path, label: "TAG_Byte ${Name}", data: this);
  }

  @override
  void readHeader(ByteLayer layer) {
    setName(layer.readTagName());
  }

  @override
  void readValue(ByteLayer layer) {
    this._value = layer.readByte();
  }

  @override
  Widget render() {
    return ListTile(
      title: Text("TAG_Byte (${Name})"),
      subtitle: Text("${_value}"),
    );
  }

  @override
  void writeHeader(ByteLayer layer) {
    layer.writeTagName(Name);
  }

  @override
  void writeTagType(ByteLayer layer) {
    layer.writeByte(TagType.Byte.toByte());
  }

  @override
  void writeValue(ByteLayer layer) {
    layer.writeByte(this._value);
  }

  @override
  TagType getTagType() {
    return TagType.Byte;
  }
}
