import 'package:disability_helper/services/boxes.dart';

Future<bool> isDataExists(String id) async {
  final data = boxPhones.get(id);
  return data != null;
}