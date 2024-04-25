import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  final int? receiptNumber;
  final int? transactionValue;

  TransactionModel({
    required this.receiptNumber,
    required this.transactionValue,

  });

  // Define copyWith method
  TransactionModel copyWith({
    int? receiptNumber,
    int? transactionValue,
  }) {
    return TransactionModel(
      receiptNumber: receiptNumber ?? this.receiptNumber,
      transactionValue: transactionValue ?? this.transactionValue,
    );
  }
  
  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}

