// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookedServiceModel _$BookedServiceModelFromJson(Map<String, dynamic> json) =>
    BookedServiceModel(
      booked_serviceId: json['booked_serviceId'] as String?,
      serviceId: json['serviceId'] as String?,
      userId: json['userId'] as String?,
      fullName: json['fullName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      serviceDate: const TimestampConverter()
          .fromJson(json['serviceDate'] as Timestamp?),
      serviceTimes: const TimestampConverter()
          .fromJson(json['serviceTimes'] as Timestamp?),
      serviceName: json['serviceName'] as String?,
    );

Map<String, dynamic> _$BookedServiceModelToJson(BookedServiceModel instance) =>
    <String, dynamic>{
      'booked_serviceId': instance.booked_serviceId,
      'serviceId': instance.serviceId,
      'userId': instance.userId,
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'serviceName': instance.serviceName,
      'serviceDate': const TimestampConverter().toJson(instance.serviceDate),
      'serviceTimes': const TimestampConverter().toJson(instance.serviceTimes),
    };
