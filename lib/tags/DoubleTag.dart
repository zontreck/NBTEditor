import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_treeview/src/models/node.dart';
import 'package:nbteditor/tags/NbtIo.dart';
import 'package:nbteditor/tags/Tag.dart';
import 'package:nbteditor/tags/TagType.dart';

class DoubleTag extends Tag {
  double _value = 0.0;

  @override
  Node getNode(String path) {
    return Node(key: path, label: "", data: this);
  }

  @override
  void readHeader(ByteLayer layer) {
    setName(layer.readTagName());
  }

  @override
  void readValue(ByteLayer layer) {
    _value = layer.readDouble();
  }

  @override
  Widget render() {
    return ListTile(
      title: Text("TAG_Double (${Name})"),
      subtitle: Text("${_value}"),
    );
  }

  @override
  void writeHeader(ByteLayer layer) {
    layer.writeTagName(Name);
  }

  @override
  void writeTagType(ByteLayer layer) {
    layer.writeByte(TagType.Double.toByte());
  }

  @override
  void writeValue(ByteLayer layer) {
    layer.writeDouble(_value);
  }

  @override
  TagType getTagType() {
    return TagType.Double;
  }
}
