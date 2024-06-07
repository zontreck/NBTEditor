import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:libac_dart/nbt/Tag.dart';
import 'package:libac_dart/nbt/impl/ByteArrayTag.dart';
import 'package:libac_dart/nbt/impl/ByteTag.dart';
import 'package:libac_dart/nbt/impl/CompoundTag.dart';
import 'package:libac_dart/nbt/impl/DoubleTag.dart';
import 'package:libac_dart/nbt/impl/FloatTag.dart';
import 'package:libac_dart/nbt/impl/IntArrayTag.dart';
import 'package:libac_dart/nbt/impl/IntTag.dart';
import 'package:libac_dart/nbt/impl/ListTag.dart';
import 'package:libac_dart/nbt/impl/LongArrayTag.dart';
import 'package:libac_dart/nbt/impl/LongTag.dart';
import 'package:libac_dart/nbt/impl/ShortTag.dart';
import 'package:libac_dart/nbt/impl/StringTag.dart';
import 'package:nbteditor/pages/AddPage.dart';
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
import 'package:nbteditor/tags/ShortTag.dart';
import 'package:nbteditor/tags/StringTag.dart';

class TagExt {
  static Widget render(Tag tag, BuildContext context) {
    switch (tag.getTagType()) {
      case TagType.List:
        {
          return (tag as ListTag).render(context);
        }
      case TagType.Byte:
        {
          return (tag as ByteTag).render(context);
        }
      case TagType.Int:
        {
          return (tag as IntTag).render(context);
        }
      case TagType.Double:
        {
          return (tag as DoubleTag).render(context);
        }
      case TagType.LongArray:
        {
          return (tag as LongArrayTag).render(context);
        }
      case TagType.Long:
        {
          return (tag as LongTag).render(context);
        }
      case TagType.IntArray:
        {
          return (tag as IntArrayTag).render(context);
        }
      case TagType.ByteArray:
        {
          return (tag as ByteArrayTag).render(context);
        }
      case TagType.String:
        {
          return (tag as StringTag).render(context);
        }
      case TagType.Compound:
        {
          return (tag as CompoundTag).render(context);
        }
      case TagType.Short:
        {
          return (tag as ShortTag).render(context);
        }
      case TagType.Float:
        {
          return (tag as FloatTag).render(context);
        }
      case TagType.End:
        {
          return SizedBox();
        }
    }
  }

  static Node getNode(String path, Tag tag) {
    switch (tag.getTagType()) {
      case TagType.List:
        {
          return (tag as ListTag).getNode(path);
        }
      case TagType.Byte:
        {
          return (tag as ByteTag).getNode(path);
        }
      case TagType.Int:
        {
          return (tag as IntTag).getNode(path);
        }
      case TagType.Double:
        {
          return (tag as DoubleTag).getNode(path);
        }
      case TagType.LongArray:
        {
          return (tag as LongArrayTag).getNode(path);
        }
      case TagType.Long:
        {
          return (tag as LongTag).getNode(path);
        }
      case TagType.IntArray:
        {
          return (tag as IntArrayTag).getNode(path);
        }
      case TagType.ByteArray:
        {
          return (tag as ByteArrayTag).getNode(path);
        }
      case TagType.String:
        {
          return (tag as StringTag).getNode(path);
        }
      case TagType.Compound:
        {
          return (tag as CompoundTag).getNode(path);
        }
      case TagType.Short:
        {
          return (tag as ShortTag).getNode(path);
        }
      case TagType.Float:
        {
          return (tag as FloatTag).getNode(path);
        }
      case TagType.End:
        {
          return Node(key: "ENDTAG", label: "");
        }
    }
  }

  static Widget getElementDescriptor(String descript, bool canAddElements,
      bool editableValue, bool isNamed, Tag tag, BuildContext ctx) {
    return Row(
      children: [
        Text(descript),
        SizedBox(
          width: 100,
        ),
        if (canAddElements)
          ElevatedButton(
              onPressed: () async {
                var response = await Navigator.pushNamed(ctx, "/add",
                    arguments: AddElementArgs(tag: tag));
              },
              child: Icon(Icons.add)),
        if (isNamed)
          ElevatedButton(onPressed: () {}, child: Text("R E N A M E")),
        if (editableValue)
          ElevatedButton(onPressed: () {}, child: Text("E D I T"))
      ],
    );
  }
}

bool canBeNamed(Tag tag) {
  return tag.parentTagType == TagType.List ? false : true;
}
