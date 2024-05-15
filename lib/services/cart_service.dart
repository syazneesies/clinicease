import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clinicease/models/item_model.dart';

class CartService {
  static const String _cartKey = 'cart';
   final CollectionReference _ordersCollection = FirebaseFirestore.instance.collection('purchased_items');

  Future<List<ItemModel>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString(_cartKey);
    if (cartData != null) {
      final List<dynamic> decodedData = json.decode(cartData);
      final List<ItemModel> cartItems = decodedData.map((itemJson) => ItemModel.fromJson(itemJson)).toList();
      return cartItems;
    } else {
      return [];
    }
  }

  Future<void> addItemToCart(ItemModel item, int quantity) async {
    final cartItems = await getCartItems();
    final existingItemIndex = cartItems.indexWhere((cartItem) => cartItem.itemId == item.itemId);
    if (existingItemIndex != -1) {
      cartItems[existingItemIndex].quantity += quantity;
    } else {
      item.quantity = quantity;
      cartItems.add(item);
    }
    final prefs = await SharedPreferences.getInstance();
    final encodedCartData = json.encode(cartItems.map((item) => item.toJson()).toList());
    await prefs.setString(_cartKey, encodedCartData);
  }

  Future<void> removeItemFromCart(ItemModel item) async {
    final cartItems = await getCartItems();
    cartItems.removeWhere((cartItem) => cartItem.itemId == item.itemId);
    final prefs = await SharedPreferences.getInstance();
    final encodedCartData = json.encode(cartItems.map((item) => item.toJson()).toList());
    await prefs.setString(_cartKey, encodedCartData);
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }

   Future<void> storeCartItemsInFirestore(List<ItemModel> cartItems,  String userId) async {
    CollectionReference orders = FirebaseFirestore.instance.collection('purchased_items');

    List<Map<String, dynamic>> items = cartItems.map((item) => item.toJson()).toList();

    await orders.add({
      'userId' : userId,
      'items': items,
      'totalPrice': items.fold(0.0, (sum, item) => sum + item['itemPrice'] * item['quantity']),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

    Future<List<Map<String, dynamic>>> getPurchaseHistory(String userId) async {
    QuerySnapshot snapshot = await _ordersCollection.where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'date': (doc['timestamp'] as Timestamp).toDate(),
        'totalPrice': doc['totalPrice'],
      };
    }).toList();
  }
}
