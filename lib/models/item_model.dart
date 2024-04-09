import 'package:clinicease/helpers/image_json.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ItemModel {
  final String? itemId;
  final String? itemName;
  final String? itemDescription;
  final String? itemDate;
  final String? itemPrice;
  final String? itemQuantity;
  final String? itemStatus;
  final String? itemRemark;

  @ImageUrlConverter()
  final String? imageUrl;

  ItemModel({
    required this.itemId,
    required this.itemName,
    required this.itemDescription,
    required this.itemDate,
    required this.itemQuantity,
    required this.itemPrice,
    required this.itemStatus,
    required this.itemRemark,
    required this.imageUrl,
  });
}
