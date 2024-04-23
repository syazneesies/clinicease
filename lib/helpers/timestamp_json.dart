import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? value) {
    return value?.toDate();
  }

  @override
  Timestamp? toJson(DateTime? value) {
    return value != null ? Timestamp.fromDate(value) : null;
  }
}

class ListTimestampConverter implements JsonConverter<List<DateTime>, List<dynamic>> {
  const ListTimestampConverter();

  @override
  List<DateTime> fromJson(List<dynamic> timestamps) {
    return timestamps.map((timestamp) => TimestampConverter().fromJson(timestamp as Timestamp?)).whereType<DateTime>().toList();
  }

  @override
  List<dynamic> toJson(List<DateTime> dates) {
    return dates.map((date) => TimestampConverter().toJson(date)).toList();
  }
}
