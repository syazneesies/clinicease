import 'package:clinicease/helpers/image_json.dart';
import 'package:json_annotation/json_annotation.dart';
part 'service_model.g.dart';

@JsonSerializable()
class ServiceModel {
  String? serviceId;
  final String? serviceName;
  final String? serviceDescription;
  final String? serviceDate;
  final String? servicePIC;
  final String? serviceQuantity;
  @ImageUrlConverter()
  final String? imageUrl;

  ServiceModel({
    required this.serviceId,
    required this.serviceName,
    required this.serviceDescription,
    required this.serviceDate,
    required this.servicePIC,
    required this.serviceQuantity,
    required this.imageUrl,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => _$ServiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);
}
