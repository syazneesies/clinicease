import 'package:clinicease/helpers/image_json.dart';
import 'package:clinicease/helpers/timestamp_json.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'service_model.g.dart';

@JsonSerializable()
class ServiceModel {
  String? serviceId;
  final String? serviceName;
  final String? serviceDescription;
  @TimestampConverter()
  final DateTime? serviceDate;
  final String? servicePIC;
  final int? serviceQuantity;
   @ListTimestampConverter()
  final List<DateTime> serviceTime; 
  @ImageUrlConverter()
  final String? imageUrl;

  ServiceModel({
    required this.serviceId,
    required this.serviceName,
    required this.serviceDescription,
    required this.serviceDate,
    required this.servicePIC,
    required this.serviceQuantity,
    required this.serviceTime,
    required this.imageUrl,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => _$ServiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);
}



