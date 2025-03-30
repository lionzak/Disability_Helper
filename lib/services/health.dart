import 'package:hive/hive.dart';

part 'health.g.dart';

@HiveType(typeId: 2)
class Health {
  Health({required this.isMale, required this.age, this.allergies, this.diseases});
  @HiveField(0)
  bool isMale;

  @HiveField(1)
  int age;

   @HiveField(2)
  final List<String>? allergies;

   @HiveField(3)
  final List<String>? diseases;
}