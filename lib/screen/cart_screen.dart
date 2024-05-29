import 'package:clinicease/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:clinicease/models/item_model.dart';
import 'package:clinicease/screen/home_screen.dart';
import 'package:clinicease/screen/receipt_screen.dart';
import 'package:clinicease/services/storage_service.dart';
import 'package:clinicease/screen/item_screen.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key, required this.item}) : super(key: key);

  final ItemModel item;

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  late Future<List<ItemModel>> _cartItemsFuture;
  String? userId;

  @override
  void initState() {
    super.initState();
    _refreshCartItems();
    userId = StorageService.getUID();
  }

  Future<void> _refreshCartItems() async {
    setState(() {
      _cartItemsFuture = _cartService.getCartItems();
    });
  }

  Future<void> _handlePayNow() async {
    final cartItems = await _cartService.getCartItems();
    await _cartService.storeCartItemsInFirestore(cartItems, userId!);
    await _cartService.clearCart();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order placed successfully!')),
    );
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => HomeScreen(),
    ));
  }

  Future<void> _handlePayAtCounter() async {
    final cartItems = await _cartService.getCartItems();
    final docId = await _cartService.storeCartItemsInFirestore(cartItems, userId!);
    await _cartService.updateItemQuantities(cartItems);
    await _cartService.clearCart();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ReceiptPage(items: cartItems, documentId: docId),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add to Cart'),
      ),
      body: FutureBuilder<List<ItemModel>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final cartItems = snapshot.data!;
            double totalPrice = 0;
            for (var item in cartItems) {
              totalPrice += item.itemPrice! * item.quantity!;
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: item.imageUrl != null
                            ? SizedBox(
                                width: 60,
                                height:100,
                                child: Image.network(
                                  item.imageUrl!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Placeholder(),
                        title: Text(item.itemName ?? 'Unknown'),
                        subtitle: Text('Price: \RM${item.itemPrice}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Quantity: ${item.quantity}'),
                            IconButton(
                              icon: Icon(Icons.remove_shopping_cart),
                              onPressed: () {
                                _cartService.removeItemFromCart(item);
                                _refreshCartItems();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TOTAL:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\RM${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handlePayAtCounter,
                    child: Text('Pay At Counter'),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('Your cart is empty.'));
          }
        },
      ),
    );
  }
}
