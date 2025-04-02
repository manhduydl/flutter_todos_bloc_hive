import 'package:intl/intl.dart';

/// Show Selected Date As String Format
String showDate(DateTime? date, {String placeholder = "No due date"}) {
  if (date == null) {
    return placeholder;
  }
  return DateFormat.yMMMd().format(date).toString();
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
