// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchased_items_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchasedItemModel _$PurchasedItemModelFromJson(Map<String, dynamic> json) =>
    PurchasedItemModel(
      purchaseItemid: json['purchaseItemid'] as String,
      imageUrl: json['imageUrl'] as String,
      itemDescription: json['itemDescription'] as String,
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      itemPrice: (json['itemPrice'] as num).toDouble(),
      itemQuantity: (json['itemQuantity'] as num).toInt(),
      itemRemark: json['itemRemark'] as String,
      itemStatus: json['itemStatus'] as String,
      quantity: (json['quantity'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$PurchasedItemModelToJson(PurchasedItemModel instance) =>
    <String, dynamic>{
      'purchaseItemid': instance.purchaseItemid,
      'imageUrl': instance.imageUrl,
      'itemDescription': instance.itemDescription,
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemPrice': instance.itemPrice,
      'itemQuantity': instance.itemQuantity,
      'itemRemark': instance.itemRemark,
      'itemStatus': instance.itemStatus,
      'quantity': instance.quantity,
      'timestamp': instance.timestamp.toIso8601String(),
      'totalPrice': instance.totalPrice,
      'userId': instance.userId,
    };
