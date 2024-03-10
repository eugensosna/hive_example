import 'dart:ffi';

import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 1)
class Person {
  Person({
    required this.name,
    required this.age,
  });


  @HiveField(1)
  String name;

  @HiveField(2)
  int age;

}