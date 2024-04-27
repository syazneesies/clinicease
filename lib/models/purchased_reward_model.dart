import 'package:clinicease/helpers/timestamp_json.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'purchased_reward_model.g.dart';

@JsonSerializable()
class PurchasedRewardModel {
  String? purchased_rewardId;
  final String? rewardId;
  final String? userId;
  final String? rewardName;
  final String? rewardDescription;
  @TimestampConverter()
  final DateTime? rewardDate;
  @TimestampConverter()
  final DateTime? createdAt;

  PurchasedRewardModel({
    required this.rewardId,
    required this.userId,
    required this.rewardName,
    required this.rewardDescription,
    required this.rewardDate,
    required this.createdAt,
  });

  factory PurchasedRewardModel.fromJson(Map<String, dynamic> json) => _$PurchasedRewardModelFromJson(json);
  Map<String, dynamic> toJson() => _$PurchasedRewardModelToJson(this);
}



