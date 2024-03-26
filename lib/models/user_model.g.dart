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
      birthdate: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['birthdate'], const TimestampConverter().fromJson),
      gender: json['gender'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'identificationNumber': instance.identificationNumber,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'birthdate': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.birthdate, const TimestampConverter().toJson),
      'gender': instance.gender,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
