// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) => ServiceModel(
      serviceId: json['serviceId'] as String?,
      serviceName: json['serviceName'] as String?,
      serviceDescription: json['serviceDescription'] as String?,
      serviceDate: const TimestampConverter()
          .fromJson(json['serviceDate'] as Timestamp?),
      servicePIC: json['servicePIC'] as String?,
      serviceQuantity: (json['serviceQuantity'] as num?)?.toInt(),
      serviceTimes:
          const ListTimestampConverter().fromJson(json['serviceTimes'] as List),
      imageUrl: const ImageUrlConverter().fromJson(json['imageUrl']),
    );

Map<String, dynamic> _$ServiceModelToJson(ServiceModel instance) =>
    <String, dynamic>{
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'serviceDescription': instance.serviceDescription,
      'serviceDate': const TimestampConverter().toJson(instance.serviceDate),
      'servicePIC': instance.servicePIC,
      'serviceQuantity': instance.serviceQuantity,
      'serviceTimes':
          const ListTimestampConverter().toJson(instance.serviceTimes),
      'imageUrl': _$JsonConverterToJson<dynamic, String>(
          instance.imageUrl, const ImageUrlConverter().toJson),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
