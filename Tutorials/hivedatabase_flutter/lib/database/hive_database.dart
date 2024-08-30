import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hivedatabase_flutter/database/student.dart';

class HiveDatabase {
  BuildContext? context;

  HiveDatabase(this.context);

  Future<List<dynamic>> getAll({
    required String boxName,
  }) async {
    Box box = (Hive.isBoxOpen(boxName))
        ? Hive.box(boxName)
        : await Hive.openBox(boxName);
    List<dynamic> list = box.values.toList().reversed.toList();
    return list;
  }

  void observe({
    required String boxName,
    required Function(List<Student>) onUpdate,
  }) async {
    Box box = (Hive.isBoxOpen(boxName))
        ? Hive.box(boxName)
        : await Hive.openBox(boxName);

    onUpdate.call(List.from(box.values));

    box.watch().listen(
      (event) {
        onUpdate.call(List.from(box.values));
      },
    );
  }

  dynamic getValue({
    required String boxName,
    required String key,
  }) async {
    Box box = (Hive.isBoxOpen(boxName))
        ? Hive.box(boxName)
        : await Hive.openBox(boxName);
    dynamic value = box.get(key);
    return value;
  }

  Future<void> update({
    required String boxName,
    required dynamic key,
    required dynamic value,
  }) async {
    Box box = (Hive.isBoxOpen(boxName))
        ? Hive.box(boxName)
        : await Hive.openBox(boxName);
    await box.put(key, value);
  }

  Future<void> add({
    required String boxName,
    required dynamic value,
  }) async {
    Box box = (Hive.isBoxOpen(boxName))
        ? Hive.box(boxName)
        : await Hive.openBox(boxName);
    await box.add(value);
  }

  Future<void> setValue({
    required String boxName,
    required String key,
    required dynamic value,
  }) async {
    Box box = (Hive.isBoxOpen(boxName))
        ? Hive.box(boxName)
        : await Hive.openBox(boxName);
    await box.put(key, value);
  }
}
