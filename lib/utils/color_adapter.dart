import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class ColorAdapter extends TypeAdapter<Color> {
  @override
  final typeId = 1;

  @override
  Color read(BinaryReader reader) {
    return Color(reader.readInt());
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.writeInt(obj.toARGB32());
  }
}
