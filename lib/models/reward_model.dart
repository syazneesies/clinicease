
import 'package:clinicease/helpers/image_json.dart';
import 'package:json_annotation/json_annotation.dart';
part 'reward_model.g.dart';

@JsonSerializable()
class RewardModel {
  String? rewardId;
  final String? rewardName;
  final String? rewardDescription;
  final String? rewardDate;
  final String? rewardPIC;
  final String? rewardQuantity;
  final String? rewardStatus;
  final int? rewardPoint;
  @ImageUrlConverter()
  final String? imageUrl;

  RewardModel({
    required this.rewardId,
    required this.rewardName,
    required this.rewardDescription,
    required this.rewardDate,
    required this.rewardQuantity,
    required this.rewardPIC,
    required this.rewardStatus,
    required this.rewardPoint,
    required this.imageUrl,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json)=> _$RewardModelFromJson(json);
  Map<String, dynamic> toJson() => _$RewardModelToJson(this);
}
