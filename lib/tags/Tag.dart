import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:nbteditor/tags/ByteArrayTag.dart';
import 'package:nbteditor/tags/ByteTag.dart';
import 'package:nbteditor/tags/CompoundTag.dart';
import 'package:nbteditor/tags/DoubleTag.dart';
import 'package:nbteditor/tags/FloatTag.dart';
import 'package:nbteditor/tags/IntArrayTag.dart';
import 'package:nbteditor/tags/IntTag.dart';
import 'package:nbteditor/tags/ListTag.dart';
import 'package:nbteditor/tags/LongArrayTag.dart';
import 'package:nbteditor/tags/LongTag.dart';
import 'package:nbteditor/tags/NbtIo.dart';
import 'package:nbteditor/tags/ShortTag.dart';
import 'package:nbteditor/tags/StringTag.dart';
import 'package:nbteditor/tags/TagType.dart';

abstract class Tag {
  String Name = "";
  Tag();

  late String key;

  void setKey(String key) {
    this.key = key;
  }

  Widget render();

  Node getNode(String path);

  ByteTag asByte() {
    if (this is ByteTag)
      return this as ByteTag;
    else
      return ByteTag();
  }

  ShortTag asShort() {
    if (this is ShortTag)
      return this as ShortTag;
    else
      return ShortTag();
  }

  IntTag asInt() {
    if (this is IntTag)
      return this as IntTag;
    else
      return IntTag();
  }

  LongTag asLong() {
    if (this is LongTag)
      return this as LongTag;
    else
      return LongTag();
  }

  FloatTag asFloat() {
    if (this is FloatTag)
      return this as FloatTag;
    else
      return FloatTag();
  }

  DoubleTag asDouble() {
    if (this is DoubleTag)
      return this as DoubleTag;
    else
      return DoubleTag();
  }

  ByteArrayTag asByteArray() {
    if (this is ByteArrayTag)
      return this as ByteArrayTag;
    else
      return ByteArrayTag();
  }

  StringTag asString() {
    if (this is StringTag)
      return this as StringTag;
    else
      return StringTag();
  }

  ListTag asListTag() {
    if (this is ListTag)
      return this as ListTag;
    else
      return ListTag();
  }

  CompoundTag asCompoundTag() {
    if (this is CompoundTag)
      return this as CompoundTag;
    else
      return CompoundTag();
  }

  IntArrayTag asIntArrayTag() {
    if (this is IntArrayTag)
      return this as IntArrayTag;
    else
      return IntArrayTag();
  }

  LongArrayTag asLongArrayTag() {
    if (this is LongArrayTag)
      return this as LongArrayTag;
    else
      return LongArrayTag();
  }

  Tag withNick(String name) {
    Name = name;
    return this;
  }

  void setName(String name) {
    Name = name;
  }

  static Tag read(ByteLayer layer) {
    TagType tagType = readTagType(layer);
    return readTag(layer, tagType, false);
  }

  static Tag readTag(ByteLayer layer, TagType tagType, bool isList) {
    Tag tag;
    switch (tagType) {
      case TagType.Byte:
        {
          tag = ByteTag();
          break;
        }
      case TagType.Short:
        {
          tag = ShortTag();
          break;
        }
      case TagType.Int:
        {
          tag = IntTag();
          break;
        }
      case TagType.Long:
        {
          tag = LongTag();
          break;
        }
      case TagType.Float:
        {
          tag = FloatTag();
          break;
        }
      case TagType.Double:
        {
          tag = DoubleTag();
          break;
        }
      case TagType.ByteArray:
        {
          tag = ByteArrayTag();
          break;
        }
      case TagType.String:
        {
          tag = StringTag();
          break;
        }
      case TagType.List:
        {
          tag = ListTag();
          break;
        }
      case TagType.Compound:
        {
          tag = CompoundTag();
          break;
        }
      case TagType.IntArray:
        {
          tag = IntArrayTag();
          break;
        }
      case TagType.LongArray:
        {
          tag = LongArrayTag();
          break;
        }
      default:
        {
          print(
              "Unknown tag: ${tagType}, aborting read at ${layer.currentPosition - 1} bytes");

          throw Exception("Unknown tag, could not deserialize");
        }
    }

    print("Read ${tagType}");

    if (!isList) tag.readHeader(layer);

    print("Name: ${tag.Name}");

    tag.readValue(layer);

    return tag;
  }

  static TagType readTagType(ByteLayer layer) {
    int type = layer.readByte();
    TagType tagType = TagTypeExtension.fromByte(type);

    return tagType;
  }

  void readHeader(ByteLayer layer);
  void readValue(ByteLayer layer);

  TagType getTagType();
  void writeTagType(ByteLayer layer);
  void writeHeader(ByteLayer layer);
  void writeValue(ByteLayer layer);
}
