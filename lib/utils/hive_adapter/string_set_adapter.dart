import 'package:hive/hive.dart';

class StringSetAdapter extends TypeAdapter<Set<String>> {
  @override
  final typeId = 2;

  @override
  Set<String> read(BinaryReader reader) {
    final list = reader.readList().cast<String>();
    return Set<String>.from(list);
  }

  @override
  void write(BinaryWriter writer, Set<String> obj) {
    writer.writeList(obj.toList());
  }
}
