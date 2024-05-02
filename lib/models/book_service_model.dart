import 'package:clinicease/helpers/timestamp_json.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'book_service_model.g.dart';

@JsonSerializable()
class BookedServiceModel {
  String? booked_serviceId;
  final String? serviceId;
  final String? userId;
  final String? fullName;
  final String? phoneNumber;
  final String? serviceName;
  @TimestampConverter()
  final DateTime? serviceDate;
  @TimestampConverter()
  final DateTime? serviceTimes;

  BookedServiceModel({
    required this.serviceId,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.serviceDate,
    required this.serviceTimes,
    required this.serviceName,
  });

  factory BookedServiceModel.fromJson(Map<String, dynamic> json) => _$BookedServiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookedServiceModelToJson(this);
}



