import 'package:hive/hive.dart';

Future<bool> isDataExists(String id, Box box) async {
  final data = box.get(id);
  return data != null;
}