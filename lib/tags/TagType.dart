enum TagType {
  End,
  Byte,
  Short,
  Int,
  Long,
  Float,
  Double,
  ByteArray,
  String,
  List,
  Compound,
  IntArray,
  LongArray
}

extension TagTypeExtension on TagType {
  int toByte() {
    switch (this) {
      case TagType.End:
        return 0;
      case TagType.Byte:
        return 1;
      case TagType.Short:
        return 2;
      case TagType.Int:
        return 3;
      case TagType.Long:
        return 4;
      case TagType.Float:
        return 5;
      case TagType.Double:
        return 6;
      case TagType.ByteArray:
        return 7;
      case TagType.String:
        return 8;
      case TagType.List:
        return 9;
      case TagType.Compound:
        return 10;
      case TagType.IntArray:
        return 11;
      case TagType.LongArray:
        return 12;
      default:
        throw Exception('Unknown TagType: $this');
    }
  }

  static TagType fromByte(int type) {
    switch (type) {
      case 0:
        return TagType.End;
      case 1:
        return TagType.Byte;
      case 2:
        return TagType.Short;
      case 3:
        return TagType.Int;
      case 4:
        return TagType.Long;
      case 5:
        return TagType.Float;
      case 6:
        return TagType.Double;
      case 7:
        return TagType.ByteArray;
      case 8:
        return TagType.String;
      case 9:
        return TagType.List;
      case 10:
        return TagType.Compound;
      case 11:
        return TagType.IntArray;
      case 12:
        return TagType.LongArray;
      default:
        throw Exception("Unknown TagType $type");
    }
  }
}
