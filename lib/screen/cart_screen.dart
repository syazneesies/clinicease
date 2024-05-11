import 'package:flutter/material.dart';
import 'package:clinicease/models/item_model.dart';
import 'package:clinicease/services/cart_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key, required this.item}) : super(key: key);

  final ItemModel item;


  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  late Future<List<ItemModel>> _cartItemsFuture;

  @override
  void initState() {
    super.initState();
    _refreshCartItems();
  }

  Future<void> _refreshCartItems() async {
    setState(() {
      _cartItemsFuture = _cartService.getCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
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
            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                   leading: item.imageUrl != null
                      ? Image.network(item.imageUrl!)
                      : Placeholder(), // Placeholder image or any default image
                  title: Text(item.itemName ?? 'Unknown'),
                  subtitle: Text('Price: ${item.itemPrice}'),
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
            );
          } else {
            return Center(child: Text('Your cart is empty.'));
          }
        },
      ),
    );
  }
}
