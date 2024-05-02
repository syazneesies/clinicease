import 'package:intl/intl.dart';

String formatDate(DateTime? date) {
  if (date == null) return 'N/A';
  return DateFormat('dd-MM-yyyy').format(date);
}

String formatTime(DateTime? time) {
  if (time == null) return 'N/A';
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}