// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String?,
      fullName: json['fullName'] as String?,
      identificationNumber: json['identificationNumber'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      birthdate:
          const TimestampConverter().fromJson(json['birthdate'] as Timestamp?),
      gender: json['gender'] as String?,
      rewardPoints: (json['rewardPoints'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'identificationNumber': instance.identificationNumber,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'birthdate': const TimestampConverter().toJson(instance.birthdate),
      'gender': instance.gender,
      'rewardPoints': instance.rewardPoints,
    };
