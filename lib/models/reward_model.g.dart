// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardModel _$RewardModelFromJson(Map<String, dynamic> json) => RewardModel(
      rewardId: json['rewardId'] as String?,
      rewardName: json['rewardName'] as String?,
      rewardDescription: json['rewardDescription'] as String?,
      rewardDate:
          const TimestampConverter().fromJson(json['rewardDate'] as Timestamp?),
      rewardQuantity: (json['rewardQuantity'] as num?)?.toInt(),
      rewardPIC: json['rewardPIC'] as String?,
      rewardStatus: json['rewardStatus'] as String?,
      rewardPoint: (json['rewardPoint'] as num?)?.toInt(),
      imageUrl: const ImageUrlConverter().fromJson(json['imageUrl']),
    );

Map<String, dynamic> _$RewardModelToJson(RewardModel instance) =>
    <String, dynamic>{
      'rewardId': instance.rewardId,
      'rewardName': instance.rewardName,
      'rewardDescription': instance.rewardDescription,
      'rewardDate': const TimestampConverter().toJson(instance.rewardDate),
      'rewardPIC': instance.rewardPIC,
      'rewardQuantity': instance.rewardQuantity,
      'rewardStatus': instance.rewardStatus,
      'rewardPoint': instance.rewardPoint,
      'imageUrl': _$JsonConverterToJson<dynamic, String>(
          instance.imageUrl, const ImageUrlConverter().toJson),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
