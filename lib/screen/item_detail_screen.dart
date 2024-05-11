import 'package:clinicease/screen/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:clinicease/models/item_model.dart';
import 'package:clinicease/services/item_service.dart';
import 'package:clinicease/services/cart_service.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({Key? key, required this.itemId}) : super(key: key);

  final String itemId;

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late Future<ItemModel?> _itemDataFuture;
  final ItemService _itemService = ItemService();
  final CartService _cartService = CartService();
  int _quantity = 1; 
  int _maxQuantity = 10;

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  onRefresh() {
    setState(() {
      _itemDataFuture = _itemService.getItemData(widget.itemId);
    });

    _itemDataFuture.then((item) {
      if (item != null) {
        print('Item UID fetched: ${item.itemId}');
      } else {
        print('Item data not found');
      }
    });
  }

  void addToCart(ItemModel item, int quantity) {
  _cartService.addItemToCart(item, quantity);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CartPage(item: item), // Assuming your cart page is named CartPage
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Info'),
      ),
      body: FutureBuilder<ItemModel?>(
        future: _itemDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final item = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.network(
                      item.imageUrl!,
                      width: 200,
                      height: 200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              item.itemName!.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(item.itemDescription!),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Item Information',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Item Price: ${item.itemPrice}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Quantity:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          if (_quantity > 1) {
                                            _quantity--;
                                          }
                                        });
                                      },
                                    ),
                                    Text(
                                      '$_quantity',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          _quantity++;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        addToCart(item, _quantity);
                      },
                      child: const Text('Add to cart'),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No item data found'));
          }
        },
      ),
    );
  }
}
