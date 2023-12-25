import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:nbteditor/tags/TagType.dart';

class ByteLayer {
  Uint8List _byteBuffer = Uint8List(0);
  int _position = 0;

  ByteLayer() {
    _byteBuffer = Uint8List(0); // Initial size, can be adjusted
    _position = 0;
  }

  int get length => _byteBuffer.length;

  int get currentPosition => _position;

  Uint8List get bytes => _byteBuffer.sublist(0, _position);

  void _ensureCapacity(int additionalBytes) {
    final requiredCapacity = _position + additionalBytes;
    if (requiredCapacity > _byteBuffer.length) {
      final newCapacity =
          _position * 2 + additionalBytes; // Adjust capacity as needed
      final newBuffer = Uint8List(newCapacity);
      newBuffer.setAll(0, _byteBuffer);
      _byteBuffer = newBuffer;
    }
  }

  void writeInt(int value) {
    _ensureCapacity(4);
    _byteBuffer.buffer.asByteData().setInt32(_position, value, Endian.big);
    _position += 4;
  }

  void writeDouble(double value) {
    _ensureCapacity(8);
    _byteBuffer.buffer.asByteData().setFloat64(_position, value, Endian.big);
    _position += 8;
  }

  void writeString(String value) {
    final encoded = utf8.encode(value);
    writeShort(encoded.length);
    _ensureCapacity(encoded.length);
    _byteBuffer.setAll(_position, encoded);
    _position += encoded.length;
  }

  int readInt() {
    final value =
        _byteBuffer.buffer.asByteData().getInt32(_position, Endian.big);
    _position += 4;
    return value;
  }

  double readDouble() {
    final value =
        _byteBuffer.buffer.asByteData().getFloat64(_position, Endian.big);
    _position += 8;
    return value;
  }

  String readString() {
    final length = readShort();
    final encoded = _byteBuffer.sublist(_position, _position + length);
    _position += length;
    return utf8.decode(encoded);
  }

  void writeIntZigZag(int value) {
    final zigzag = (value << 1) ^ (value >> 31);
    writeInt(zigzag);
  }

  int readIntZigZag() {
    final zigzag = readInt();
    final value = (zigzag >> 1) ^ -(zigzag & 1);
    return value;
  }

  void writeByte(int value) {
    _ensureCapacity(1);
    _byteBuffer[_position] = value & 0xFF;
    _position++;
  }

  int readByte() {
    final value = _byteBuffer[_position];
    _position++;
    return value;
  }

  void writeVarInt(int value) {
    while ((value & ~0x7F) != 0) {
      writeByte((value & 0x7F) | 0x80);
      value = (value >> 7) & 0x1FFFFFFF;
    }
    writeByte(value & 0x7F);
  }

  int readVarInt() {
    int result = 0;
    int shift = 0;
    int byte;
    do {
      byte = readByte();
      result |= (byte & 0x7F) << shift;
      if ((byte & 0x80) == 0) {
        break;
      }
      shift += 7;
    } while (true);

    return result;
  }

  void writeVarIntNoZigZag(int value) {
    while ((value & ~0x7F) != 0) {
      writeByte((value & 0x7F) | 0x80);
      value >>= 7;
    }
    writeByte(value & 0x7F);
  }

  int readVarIntNoZigZag() {
    int result = 0;
    int shift = 0;
    int byte;
    do {
      byte = readByte();
      result |= (byte & 0x7F) << shift;
      if ((byte & 0x80) == 0) {
        break;
      }
      shift += 7;
    } while (true);

    return result;
  }

  void writeShort(int value) {
    _ensureCapacity(2);
    _byteBuffer.buffer.asByteData().setInt16(_position, value, Endian.big);
    _position += 2;
  }

  int readShort() {
    final value =
        _byteBuffer.buffer.asByteData().getInt16(_position, Endian.big);
    _position += 2;
    return value;
  }

  void writeFloat(double value) {
    _ensureCapacity(4);
    _byteBuffer.buffer.asByteData().setFloat32(_position, value, Endian.big);
    _position += 2;
  }

  double readFloat() {
    final value =
        _byteBuffer.buffer.asByteData().getFloat32(_position, Endian.big);

    _position += 2;
    return value;
  }

  void writeTagName(String name) {
    final encodedName = utf8.encode(name);
    writeShort(encodedName.length);
    _ensureCapacity(encodedName.length);
    _byteBuffer.setAll(_position, encodedName);
    _position += encodedName.length;
  }

  String readTagName() {
    final length = readShort();
    final encodedName = _byteBuffer.sublist(_position, _position + length);
    _position += length;
    return utf8.decode(encodedName);
  }

  void resetPosition() {
    _position = 0;
  }

  void clear() {
    resetPosition();
    _byteBuffer = Uint8List(0);
  }

  Future<void> writeToFile(String filePath) async {
    final file = File(filePath);
    await file.writeAsBytes(bytes);
  }

  Future<void> readFromFile(String filePath) async {
    final file = File(filePath);
    final exists = await file.exists();
    if (!exists) {
      print('File does not exist.');
      return;
    }

    _byteBuffer = await file.readAsBytes();
    resetPosition();
  }

  Future<void> compress() async {
    final gzip = GZipCodec();
    final compressedData = gzip.encode(_byteBuffer);
    _byteBuffer = Uint8List.fromList(compressedData);
    _position = _byteBuffer.length;
  }

  Future<void> decompress() async {
    final gzip = GZipCodec();
    final decompressedData = gzip.decode(_byteBuffer);
    _byteBuffer = Uint8List.fromList(decompressedData);
    _position = _byteBuffer.length;
  }

  void writeLong(int value) {
    _ensureCapacity(8);
    _byteBuffer.buffer.asByteData().setInt64(_position, value, Endian.big);
    _position += 8;
  }

  int readLong() {
    final value =
        _byteBuffer.buffer.asByteData().getInt64(_position, Endian.big);
    _position += 8;
    return value;
  }
}

class NbtIo {
  static ByteLayer _io = ByteLayer();

  // Handle various helper functions here!

  static Future<void> _read(String file) async {
    _io = ByteLayer();

    await _io.readFromFile(file);
  }

  // This function will read the file and check if it is infact gzipped
  static Future<bool> read(String file) async {
    await _read(file);
    if (_io.readByte() == TagType.Compound.toByte()) {
      _io.resetPosition();
      return false;
    } else {
      // Is likely gzip compressed
      await _readCompressed(file);
      _io.resetPosition();
      return true;
    }
  }

  static Future<void> _readCompressed(String file) async {
    _io = ByteLayer();
    await _io.readFromFile(file);
    await _io.decompress();
  }

  static Future<void> write(String file) async {
    await _io.writeToFile(file);
  }

  static Future<void> writeCompressed(String file) async {
    await _io.compress();
    await _io.writeToFile(file);
  }

  static ByteLayer getStream() {
    return _io;
  }
}
