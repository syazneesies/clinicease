import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinicease/services/cart_service.dart';
import 'package:clinicease/helpers/date_time_utils.dart'; // Import the helper file

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
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var item in items) ...[
                    Card(
                      child: ListTile(
                        leading: Image.network(
                          item['imageUrl'], // URL of the image
                          height: 100, // Adjust as needed
                          width: 100, // Adjust as needed
                          fit: BoxFit.cover, // Image fit
                        ),
                        title: Text(item['itemName']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description: ${item['itemDescription']}'),
                            Text('Quantity: ${item['quantity']}'),
                          ],
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 16.0),
                  // Convert the timestamp using formatDate and formatTime functions from the helper file
                  Text('Timestamp: ${formatDate(purchaseItemData['timestamp'].toDate())} ${formatTime(purchaseItemData['timestamp'].toDate())}'),
                  Text('Total Price: ${purchaseItemData['totalPrice']}'),
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
