import 'package:flutter/material.dart';
import 'package:clinicease/models/item_model.dart';
import 'package:clinicease/screen/home_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiptPage extends StatelessWidget {
  final List<ItemModel> items;
  final String documentId;

  const ReceiptPage({Key? key, required this.items, required this.documentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    for (var item in items) {
      totalPrice += item.itemPrice! * item.quantity!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              'Transaction ID: $documentId',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
                      leading: item.imageUrl != null
                          ? Image.network(
                              item.imageUrl!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : SizedBox(
                              height: 100,
                              width: 100,
                              child: Placeholder(),
                            ),
                      title: Text(item.itemName ?? 'Unknown'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.itemDescription != null)
                            Text('Description: ${item.itemDescription}'),
                          Text('Quantity: ${item.quantity}'),
                          Text('Price: \RM${(item.itemPrice! * item.quantity!).toStringAsFixed(2)}'),
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
                data: documentId,
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
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
                child: Text('Go to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
