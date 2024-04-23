import 'package:clinicease/models/item_model.dart';
import 'package:clinicease/services/item_service.dart';
import 'package:flutter/material.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({Key? key, required this.itemId}) : super(key: key);

  final String itemId;

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late Future<ItemModel?> _itemDataFuture;
  final ItemService _itemService = ItemService(); 

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
                            Text(item.itemName!.toUpperCase(), style: Theme.of(context).textTheme.headline6),
                            Text(item.itemDescription!),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Item Information', style: Theme.of(context).textTheme.subtitle1),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Display service details here
                            // Replace this with your actual service details widget
                            // Below are placeholders, replace them with actual service details
                            Text('Point Needed: ${item.itemPrice}'),
                            // Add more widgets to display other service details
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        print('id: ${item.itemId}');
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => ServiceConfirmationScreen(
                        //     itemId: item.itemId!,
                        //   ),
                        // ));
                      },
                      child: const Text('Book Now'),
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
