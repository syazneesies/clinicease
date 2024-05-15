import 'package:flutter/material.dart';
import 'package:clinicease/screen/purchased_item_detail_screen.dart';
import 'package:clinicease/services/cart_service.dart';
import 'package:clinicease/services/storage_service.dart';

class MyPurchasedItemScreen extends StatefulWidget {
  @override
  _MyPurchasedItemScreenState createState() => _MyPurchasedItemScreenState();
}

class _MyPurchasedItemScreenState extends State<MyPurchasedItemScreen> {
  final CartService _cartService = CartService();
  late Future<List<Map<String, dynamic>>> _purchaseHistoryFuture;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = StorageService.getUID();
    if (userId != null) {
      _purchaseHistoryFuture = _cartService.getPurchaseHistory(userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Purchased Items'),
      ),
      body: userId == null
          ? Center(child: Text('User not logged in'))
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: _purchaseHistoryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final purchases = snapshot.data!;
                  return ListView.builder(
                    itemCount: purchases.length,
                    itemBuilder: (context, index) {
                      final purchase = purchases[index];
                      return ListTile(
                        title: Text('Order ID: ${purchase['id']}'),
                        subtitle: Text('Date Purchased: ${purchase['date']}'),
                        trailing: Text('Total: \$${purchase['totalPrice'].toStringAsFixed(2)}'),
                        onTap: () {
                          // Pass the purchase item ID to the details screen
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PurchaseDetailScreen(purchaseItemId: purchase['id']),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No purchases found.'));
                }
              },
            ),
    );
  }
}
