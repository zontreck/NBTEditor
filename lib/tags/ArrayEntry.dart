import 'package:libac_dart/nbt/Tag.dart';

class ArrayEntry {
  Tag parent;
  dynamic value;
  int index;

  ArrayEntry({required this.parent, required this.value, required this.index});
}
