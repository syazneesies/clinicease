import 'package:clinicease/helpers/timestamp_json.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String? id;
  final String? fullName;
  final String? identificationNumber;
  final String? phoneNumber;
  final String? email;
  @TimestampConverter()
  final DateTime? birthdate;
  final String? gender;
  final int? rewardPoints;

  UserModel({
    required this.id,
    required this.fullName,
    required this.identificationNumber,
    required this.phoneNumber,
    required this.email,
    required this.birthdate,
    required this.gender,
    required this.rewardPoints,
  });

  // Define copyWith method
  UserModel copyWith({
    String? id,
    String? fullName,
    String? identificationNumber,
    String? phoneNumber,
    String? email,
    String? password,
    DateTime? birthdate,
    String? gender,
    int? rewardPoints,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      rewardPoints: rewardPoints ?? this.rewardPoints,
    );
  }
  
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

