import 'package:hive_flutter/adapters.dart';

part 'student.g.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  int? age;
  @HiveField(2)
  String? gender;

  Student({
    this.name,
    this.age,
    this.gender,
  });
}
