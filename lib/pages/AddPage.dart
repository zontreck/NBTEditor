import 'package:flutter/material.dart';
import 'package:libac_dart/nbt/Tag.dart';
import 'package:libac_dart/nbt/impl/ByteArrayTag.dart';
import 'package:libac_dart/nbt/impl/IntArrayTag.dart';
import 'package:libac_dart/nbt/impl/ListTag.dart';
import 'package:libac_dart/nbt/impl/LongArrayTag.dart';
import 'package:nbteditor/Constants.dart';
import 'package:nbteditor/pages/EditValue.dart';
import 'package:nbteditor/pages/RenamePrompt.dart';

import '../tags/Tag.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<StatefulWidget> createState() => AddState();
}

class AddState extends State<AddPage> {
  List<TagType> allowedTagTypes = [];
  bool canAddAnyType = false;
  bool isList = false;
  bool isArray = false;
  String newTagName = "";
  dynamic val;
  Tag? ParentTag;
  bool singleShot = true;

  Function? didChangeState;

  @override
  void didChangeDependencies() {
    var args = ModalRoute.of(context)!.settings.arguments as AddElementArgs;

    canAddAnyType = args.allowAllTagTypes;
    isList = args.tag.getTagType() == TagType.List;
    isArray = args.tag.getTagType() == TagType.ByteArray ||
        args.tag.getTagType() == TagType.IntArray ||
        args.tag.getTagType() == TagType.LongArray;

    if (isList || isArray) {
      allowedTagTypes = args.allowedTagTypes;
    }

    if (canAddAnyType) {
      allowedTagTypes.clear();
      for (TagType type in TagType.values) {
        if (type == TagType.End) {
          continue;
        } else {
          allowedTagTypes.add(type);
        }
      }
    }

    didChangeState = args.didChangeState;
    ParentTag = args.tag;
  }

  Future<void> processTagType(TagType type) async {
    if (!(isArray || isList)) {
      var reply = await showDialog(
          context: context,
          routeSettings: const RouteSettings(arguments: ""),
          builder: (builder) {
            return const RenamePrompt();
          });
      newTagName = reply as String;
    }
    var nTag = Tag.makeTagOfType(type);
    bool hasValue = true;

    if (type == TagType.List ||
        type == TagType.ByteArray ||
        type == TagType.LongArray ||
        type == TagType.IntArray ||
        type == TagType.Compound) {
      hasValue = false;
    } else {
      nTag.setKey(newTagName);
      var reply = await showDialog(
          context: context,
          routeSettings: RouteSettings(arguments: nTag),
          builder: (builder) {
            return const EditValuePrompt();
          });
      val = reply;
    }

    if (isArray) {
      switch (ParentTag!.getTagType()) {
        case TagType.LongArray:
          {
            LongArrayTag LAT = ParentTag! as LongArrayTag;
            LAT.value.add(val);
            break;
          }
        case TagType.IntArray:
          {
            IntArrayTag IAT = ParentTag! as IntArrayTag;
            IAT.value.add(val);
            break;
          }

        case TagType.ByteArray:
          {
            ByteArrayTag BAT = ParentTag! as ByteArrayTag;
            BAT.value.add(val);
            break;
          }
        default:
          {
            break;
          }
      }
    } else {
      if (hasValue) nTag.setValue(val);

      if (isList) {
        ListTag lst = ParentTag! as ListTag;
        lst.add(nTag);
      } else {
        ParentTag!.asCompoundTag().put(newTagName, nTag);
      }
    }

    didChangeState!.call();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isList || isArray && !canAddAnyType && singleShot) {
      singleShot = false;

      Future.delayed(const Duration(seconds: 2), () {
        processTagType(allowedTagTypes[0]);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Tag - Select Tag Type"),
        backgroundColor: Constants.TITLEBAR_COLOR,
      ),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (builder, index) {
              return ListTile(
                title: Text(allowedTagTypes[index].name),
                leading: TagExt.getTagIcon(allowedTagTypes[index]),
                onTap: () async {
                  processTagType(allowedTagTypes[index]);
                },
              );
            },
            itemCount: allowedTagTypes.length,
          )),
    );
  }
}

class AddElementArgs {
  Tag tag;
  bool allowAllTagTypes;
  bool isArray;
  Function didChangeState;

  List<TagType> allowedTagTypes;

  AddElementArgs(
      {required this.tag,
      required this.allowAllTagTypes,
      required this.isArray,
      this.allowedTagTypes = const [],
      required this.didChangeState});
}
