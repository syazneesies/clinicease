// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => ItemModel(
      itemId: json['itemId'] as String?,
      itemName: json['itemName'] as String?,
      itemDescription: json['itemDescription'] as String?,
      itemPrice: json['itemPrice'] is double ? json['itemPrice'] : double.tryParse(json['itemPrice'] ?? '0.0'),
      itemQuantity: json['itemQuantity'] is int ? json['itemQuantity'] : int.tryParse(json['itemQuantity'] ?? '0'),
      itemStatus: json['itemStatus'] as String?,
      itemRemark: json['itemRemark'] as String?,
      imageUrl: const ImageUrlConverter().fromJson(json['imageUrl']),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) => <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemDescription': instance.itemDescription,
      'itemPrice': instance.itemPrice,
      'itemQuantity': instance.itemQuantity,
      'itemStatus': instance.itemStatus,
      'itemRemark': instance.itemRemark,
      'quantity': instance.quantity,
      'imageUrl': _$JsonConverterToJson<dynamic, String>(
          instance.imageUrl, const ImageUrlConverter().toJson),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
