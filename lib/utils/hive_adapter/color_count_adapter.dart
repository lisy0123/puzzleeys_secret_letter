import 'package:hive/hive.dart';

class ColorCountAdapter extends TypeAdapter<Map<String, int>> {
  @override
  final typeId = 1;

  @override
  Map<String, int> read(BinaryReader reader) {
    final map = reader.readMap().cast<String, int>();
    return map;
  }

  @override
  void write(BinaryWriter writer, Map<String, int> obj) {
    writer.writeMap(obj);
  }
}
