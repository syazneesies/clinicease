import 'package:flutter/material.dart';
import 'package:clinicease/screen/purchased_item_detail_screen.dart';
import 'package:clinicease/services/cart_service.dart';
import 'package:clinicease/services/storage_service.dart';
import 'package:intl/intl.dart';

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

  String formatDate(dynamic date) {
    if (date is String) {
      date = DateTime.parse(date);
    }
    return DateFormat('dd-MM-yyyy').format(date);
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
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text('Order ID: ${purchase['id']}'),
                                subtitle: Text('Date Purchased: ${formatDate(purchase['date'])}'),
                                trailing: Text('Total: RM${purchase['totalPrice'].toStringAsFixed(2)}'),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => PurchaseDetailScreen(purchaseItemId: purchase['id']),
                                      ),
                                    );
                                  },
                                  child: Text('View Details'),
                                ),
                              ),
                            ],
                          ),
                        ),
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
