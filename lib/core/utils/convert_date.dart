import 'package:intl/intl.dart';

String convertDateTime(String utcDateTime) {
  DateTime utcTime = DateTime.parse(utcDateTime);
  DateTime indonesianTime = utcTime.add(const Duration(hours: 16));
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(indonesianTime);
}
