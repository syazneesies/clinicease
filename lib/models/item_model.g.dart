// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => ItemModel(
      itemId: json['itemId'] as String?,
      itemName: json['itemName'] as String?,
      itemDescription: json['itemDescription'] as String?,
      itemDate: json['itemDate'] as String?,
      itemQuantity: json['itemQuantity'] as String?,
      itemPrice: json['itemPrice'] as String?,
      itemStatus: json['itemStatus'] as String?,
      itemRemark: json['itemRemark'] as String?,
      imageUrl: const ImageUrlConverter().fromJson(json['imageUrl']),
    );

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) => <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemDescription': instance.itemDescription,
      'itemDate': instance.itemDate,
      'itemPrice': instance.itemPrice,
      'itemQuantity': instance.itemQuantity,
      'itemStatus': instance.itemStatus,
      'itemRemark': instance.itemRemark,
      'imageUrl': _$JsonConverterToJson<dynamic, String>(
          instance.imageUrl, const ImageUrlConverter().toJson),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
