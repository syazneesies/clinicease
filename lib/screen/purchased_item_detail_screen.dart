import 'package:clinicease/screen/my_purchased_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinicease/services/cart_service.dart';
import 'package:clinicease/helpers/date_time_utils.dart'; // Import the helper file
import 'package:qr_flutter/qr_flutter.dart';

class PurchaseDetailScreen extends StatefulWidget {
  final String purchaseItemId;

  const PurchaseDetailScreen({Key? key, required this.purchaseItemId}) : super(key: key);

  @override
  _PurchaseDetailScreenState createState() => _PurchaseDetailScreenState();
}

class _PurchaseDetailScreenState extends State<PurchaseDetailScreen> {
  late Future<DocumentSnapshot> _purchaseItemFuture;

  @override
  void initState() {
    super.initState();
    _purchaseItemFuture = CartService.fetchItemDetails(widget.purchaseItemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Detail'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _purchaseItemFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.exists) {
            final purchaseItemData = snapshot.data!.data() as Map<String, dynamic>;
            final items = purchaseItemData['items'] as List<dynamic>;
            double totalPrice = purchaseItemData['totalPrice'];
            DateTime timestamp = (purchaseItemData['timestamp'] as Timestamp).toDate();

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Receipt',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Transaction ID: ${widget.purchaseItemId}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Date Order: ${formatDate(timestamp)}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(thickness: 2),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          child: ListTile(
                            leading: item['imageUrl'] != null
                                ? Image.network(
                                    item['imageUrl'],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  )
                                : SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Placeholder(),
                                  ),
                            title: Text(item['itemName']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Description: ${item['itemDescription']}'),
                                Text('Quantity: ${item['quantity']}'),
                                Text('Price: \RM${(item['itemPrice'] * item['quantity']).toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(thickness: 2),
                  Row(
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
                  SizedBox(height: 20),
                  Center(
                    child: QrImageView(
                      data: widget.purchaseItemId,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => MyPurchasedItemScreen(),
                          ),
                        );
                      },
                      child: Text('Go to Home'),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('Purchase item not found.'));
          }
        },
      ),
    );
  }
}
