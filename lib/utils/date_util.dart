import 'package:intl/intl.dart';

/// Show Selected Date As String Format
String showDate(DateTime? date) {
  if (date == null) {
    return "No due date";
  }
  return DateFormat.yMMMEd().format(date).toString();
}
