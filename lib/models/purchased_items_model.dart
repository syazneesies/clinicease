import 'package:json_annotation/json_annotation.dart';
part 'purchased_items_model.g.dart';

@JsonSerializable()
class PurchasedItemModel {
  String purchaseItemid;
  final String imageUrl;
  final String itemDescription;
  final String itemId;
  final String itemName;
  final double itemPrice;
  final int itemQuantity;
  final String itemRemark;
  final String itemStatus;
  final int quantity;
  final DateTime timestamp;
  final double totalPrice;
  final String userId;

  PurchasedItemModel({
    required this.purchaseItemid,
    required this.imageUrl,
    required this.itemDescription,
    required this.itemId,
    required this.itemName,
    required this.itemPrice,
    required this.itemQuantity,
    required this.itemRemark,
    required this.itemStatus,
    required this.quantity,
    required this.timestamp,
    required this.totalPrice,
    required this.userId,
  });

  factory PurchasedItemModel.fromJson(Map<String, dynamic> json) => _$PurchasedItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$PurchasedItemModelToJson(this);
}
