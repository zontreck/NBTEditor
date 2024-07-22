import 'package:flutter/cupertino.dart';
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
import 'package:nbteditor/Editor.dart';
import 'package:nbteditor/pages/AddPage.dart';
import 'package:nbteditor/pages/EditValue.dart';
import 'package:nbteditor/pages/RenamePrompt.dart';
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
  static Widget render(Tag tag, BuildContext context, Function didChangeState) {
    switch (tag.getTagType()) {
      case TagType.List:
        {
          return (tag as ListTag).render(context, didChangeState);
        }
      case TagType.Byte:
        {
          return (tag as ByteTag).render(context, didChangeState);
        }
      case TagType.Int:
        {
          return (tag as IntTag).render(context, didChangeState);
        }
      case TagType.Double:
        {
          return (tag as DoubleTag).render(context, didChangeState);
        }
      case TagType.LongArray:
        {
          return (tag as LongArrayTag).render(context, didChangeState);
        }
      case TagType.Long:
        {
          return (tag as LongTag).render(context, didChangeState);
        }
      case TagType.IntArray:
        {
          return (tag as IntArrayTag).render(context, didChangeState);
        }
      case TagType.ByteArray:
        {
          return (tag as ByteArrayTag).render(context, didChangeState);
        }
      case TagType.String:
        {
          return (tag as StringTag).render(context, didChangeState);
        }
      case TagType.Compound:
        {
          return (tag as CompoundTag).render(context, didChangeState);
        }
      case TagType.Short:
        {
          return (tag as ShortTag).render(context, didChangeState);
        }
      case TagType.Float:
        {
          return (tag as FloatTag).render(context, didChangeState);
        }
      case TagType.End:
        {
          return const SizedBox();
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
          return const Node(key: "ENDTAG", label: "");
        }
    }
  }

  static Widget getElementButtons(bool canAddElements, bool isNamed,
      bool editableValue, Tag tag, BuildContext ctx, Function didChangeState) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (canAddElements)
          IconButton(
              onPressed: () async {
                bool allowAllTagTypes = true;
                bool isArray = false;
                List<TagType> allowedTypes = [];
                if (tag is CompoundTag) allowAllTagTypes = true;
                if (tag is ListTag) {
                  ListTag lst = tag;
                  if (lst.size() == 0) {
                    allowAllTagTypes = true;
                  } else {
                    allowAllTagTypes = false;
                    allowedTypes = [lst.get(0).getTagType()];
                  }
                }
                if (tag is ByteArrayTag) {
                  allowAllTagTypes = false;
                  isArray = true;
                  allowedTypes = [TagType.Byte];
                }

                if (tag is IntArrayTag) {
                  allowAllTagTypes = false;
                  isArray = true;
                  allowedTypes = [TagType.Int];
                }

                if (tag is LongArrayTag) {
                  allowAllTagTypes = false;
                  isArray = true;
                  allowedTypes = [TagType.Long];
                }

                var response = await Navigator.pushNamed(ctx, "/add",
                    arguments: AddElementArgs(
                        tag: tag,
                        allowAllTagTypes: allowAllTagTypes,
                        isArray: isArray,
                        allowedTagTypes: allowedTypes,
                        didChangeState: didChangeState));
              },
              icon: Icon(Icons.add)),
        if (isNamed)
          IconButton(
              onPressed: () async {
                var response = await showDialog(
                    context: ctx,
                    routeSettings: RouteSettings(arguments: tag.getKey()),
                    builder: (B) {
                      return const RenamePrompt();
                    });

                if (response is String) {
                  tag.setKey(response);

                  EditorState state = EditorState();
                  state.update();
                }
              },
              icon: Icon(Icons.drive_file_rename_outline)),
        if (editableValue)
          IconButton(
              onPressed: () async {
                var response = await showAdaptiveDialog(
                    context: ctx,
                    builder: (B) {
                      return EditValuePrompt();
                    },
                    routeSettings: RouteSettings(arguments: tag));

                if (response == null) {
                  return;
                } else {
                  tag.setValue(response);

                  didChangeState.call();
                }
              },
              icon: Icon(Icons.edit_document))
      ],
    );
  }

  static Widget getElementDescriptor(String descript) {
    return Text(descript);
  }

  static String getTagIconPath(TagType type) {
    return "Icons/PNG/${type.name}.png";
  }

  static Widget getTagIcon(TagType type) {
    return Image(image: AssetImage(getTagIconPath(type)));
  }
}

bool canBeNamed(Tag tag) {
  return tag.parentTagType == TagType.List ? false : true;
}
