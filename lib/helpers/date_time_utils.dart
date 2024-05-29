import 'package:intl/intl.dart';

String formatDate(DateTime? date) {
  if (date == null) return 'N/A';
  return DateFormat('dd-MM-yyyy').format(date);
}

String formatTime(DateTime? time) {
  if (time == null) return 'N/A';
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

String formatTimeAMPM(DateTime? time) {
  if (time == null) {
    return 'N/A';
  } else {
    String hour = time.hour < 10 ? '0${time.hour}' : '${time.hour}';
    String minute = time.minute < 10 ? '0${time.minute}' : '${time.minute}';
    String period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}