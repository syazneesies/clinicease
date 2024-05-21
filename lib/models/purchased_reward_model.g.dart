// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchased_reward_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchasedRewardModel _$PurchasedRewardModelFromJson(
        Map<String, dynamic> json) =>
    PurchasedRewardModel(
      rewardId: json['rewardId'] as String?,
      userId: json['userId'] as String?,
      rewardName: json['rewardName'] as String?,
      rewardDescription: json['rewardDescription'] as String?,
      rewardDate:
          const TimestampConverter().fromJson(json['rewardDate'] as Timestamp?),
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      rewardStatus: json['rewardStatus'] as String?,
    )..purchased_rewardId = json['purchased_rewardId'] as String?;

Map<String, dynamic> _$PurchasedRewardModelToJson(
        PurchasedRewardModel instance) =>
    <String, dynamic>{
      'purchased_rewardId': instance.purchased_rewardId,
      'rewardId': instance.rewardId,
      'userId': instance.userId,
      'rewardName': instance.rewardName,
      'rewardDescription': instance.rewardDescription,
      'rewardDate': const TimestampConverter().toJson(instance.rewardDate),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'rewardStatus': instance.rewardStatus,
    };
