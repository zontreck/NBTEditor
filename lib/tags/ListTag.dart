import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_treeview/src/models/node.dart';
import 'package:nbteditor/tags/NbtIo.dart';
import 'package:nbteditor/tags/Tag.dart';
import 'package:nbteditor/tags/TagType.dart';

class ListTag extends Tag {
  List<Tag> _value = [];

  @override
  Node getNode(String path) {
    List<Node> nodes = [];

    int count = 0;
    for (var element in _value) {
      nodes.add(element.getNode("$path/$count"));
      count++;
    }

    return Node(key: path, label: Name, data: this, children: nodes);
  }

  @override
  void readHeader(ByteLayer layer) {
    setName(layer.readTagName());
  }

  bool add(Tag tag) {
    if (_value.length > 0) {
      if (tag.getTagType() == _value[0].getTagType()) {
        _value.add(tag);

        return true;
      } else {
        return false;
      }
    } else {
      _value.add(tag);
      return true;
    }
  }

  @override
  void readValue(ByteLayer layer) {
    TagType type = Tag.readTagType(layer);
    int count = layer.readInt();

    if (count == 0) return;

    for (int i = 0; i < count; i++) {
      add(Tag.readTag(layer, type, true));
    }
  }

  @override
  Widget render() {
    return ListTile(
      title: Text("TAG_List (${Name}) (${getListTagType()})"),
      subtitle: Text("${_value.length} entries"),
    );
  }

  @override
  void writeHeader(ByteLayer layer) {
    layer.writeTagName(Name);
  }

  @override
  void writeTagType(ByteLayer layer) {
    layer.writeByte(TagType.List.toByte());
  }

  TagType getListTagType() {
    if (_value.length > 0) {
      return TagType.End;
    } else
      return _value[0].getTagType();
  }

  @override
  void writeValue(ByteLayer layer) {
    if (_value.length > 0) {
      _value[0].writeTagType(layer);
    } else {
      layer.writeByte(TagType.End.toByte());
    }

    layer.writeInt(_value.length);

    for (var element in _value) {
      element.writeValue(layer);
    }
  }

  @override
  TagType getTagType() {
    return TagType.List;
  }
}
