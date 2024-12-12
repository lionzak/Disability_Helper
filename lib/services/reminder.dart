import 'package:hive/hive.dart';

part 'reminder.g.dart';

@HiveType(typeId: 1)
class Reminder {
  Reminder({required this.title, required this.date, required this.notificationId, this.dosage = 1, required this.beforeFood});
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime date;

   @HiveField(2)
  final int notificationId;

   @HiveField(3)
  final int dosage;

   @HiveField(4)
  final bool beforeFood;
}