import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:nbteditor/tags/NbtIo.dart';
import 'package:nbteditor/tags/Tag.dart';
import 'package:nbteditor/tags/TagType.dart';
import 'package:uuid/v4.dart';

class CompoundTag extends Tag {
  UuidV4 v4 = const UuidV4();
  final Map<String, Tag> _children = {};

  CompoundTag() {
    setKey(v4.generate());

    setName("root");
  }

  @override
  Widget render() {
    return ListTile(
      title: Text("TAG_Compound ($Name)"),
      subtitle:
          Text("${_children.length} tag${_children.length > 1 ? "s" : ""}"),
    );
  }

  @override
  Node getNode(String path) {
    List<Node> childTags = [];

    for (var element in _children.entries) {
      childTags.add(element.value.getNode("$path/${element.key}"));
    }
    Node me = Node(key: path, label: Name, data: this, children: childTags);
    return me;
  }

  void put(String name, Tag child) {
    _children[name] = child.withNick(name);
  }

  Tag? get(String name) {
    return _children[name];
  }

  void remove(String name) {
    _children.remove(name);
  }

  @override
  void readValue(ByteLayer layer) {
    TagType type;
    while (true) {
      type = Tag.readTagType(layer);
      if (type == TagType.End) break;

      Tag tag = Tag.readTag(layer, type, false);
      put(tag.Name, tag);
    }
  }

  @override
  void writeValue(ByteLayer layer) {
    for (var entry in _children.entries) {
      layer.writeTagName(entry.key);
      entry.value.writeValue(layer);
    }

    layer.writeByte(TagType.End.toByte());
  }

  @override
  void readHeader(ByteLayer layer) {
    setName(layer.readTagName());
  }

  @override
  void writeHeader(ByteLayer layer) {
    layer.writeTagName(Name);
  }

  @override
  void writeTagType(ByteLayer layer) {
    layer.writeByte(TagType.Compound.toByte());
  }

  @override
  TagType getTagType() {
    return TagType.Compound;
  }
}
