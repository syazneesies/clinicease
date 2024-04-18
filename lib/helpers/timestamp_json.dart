import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}


class ListTimestampConverter implements JsonConverter<List<DateTime>, List<Timestamp>> {
  const ListTimestampConverter();

  @override
  List<DateTime> fromJson(List<Timestamp> timestamps) {
    return timestamps.map((timestamp) => timestamp.toDate()).toList();
    // List<DateTime> convertedTimestamp = [];

    // for (var element in timestamps) {
    //   var e = element.toDate();
    //   convertedTimestamp.add(e);
    // }

    // return convertedTimestamp;
  }

  @override
  List<Timestamp> toJson(List<DateTime> dates) {
    return dates.map((date) => Timestamp.fromDate(date)).toList();
    // List<Timestamp> convertedDateTime = [];

    // for (var element in dateTime) {
    //   var e = Timestamp.fromDate(element);
    //   convertedDateTime.add(e);
    // }

    // return convertedDateTime;
  }
}
