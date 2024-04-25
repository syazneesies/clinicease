// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      receiptNumber: json['receiptNumber'] as int?,
      transactionValue: json['transactionValue'] as int?,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'receiptNumber': instance.receiptNumber,
      'transactionValue': instance.transactionValue,
    };
