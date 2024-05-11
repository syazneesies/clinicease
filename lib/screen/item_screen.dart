import 'package:clinicease/models/item_model.dart';
import 'package:clinicease/screen/cart_screen.dart';
import 'package:clinicease/screen/item_detail_screen.dart';
import 'package:clinicease/screen/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:clinicease/services/item_service.dart';
//import 'package:clinicease/screen/cart_page.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({Key? key}) : super(key: key);

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final ItemService _itemService = ItemService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item List'),
        actions: [
          GestureDetector(
            onTap: () {
               // Replace ... with your item object
              Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MyProfileScreen(), // Navigate to your CartPage
              ));
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.shopping_cart), // Add your cart icon here
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _itemService.getItem(),
        builder: (context, AsyncSnapshot<List<ItemModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return ItemCardWidget(item: item);
              },
            );
          }
        },
      ),
    );
  }
}

class ItemCardWidget extends StatelessWidget {
  const ItemCardWidget({Key? key, required this.item}) : super(key: key);

  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.network(
                item.imageUrl!,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reward name
                  FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      item.itemName!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text('RM ${item.itemPrice}'),
                  const SizedBox(height: 16),

                  // Button
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ItemDetailScreen(itemId: item.itemId!),
                        ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(80),
                        ),
                        child: const Text('Buy Now', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
