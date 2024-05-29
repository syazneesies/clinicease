import 'package:flutter/material.dart';
import 'package:clinicease/models/item_model.dart';
import 'package:clinicease/screen/item_detail_screen.dart';
import 'package:clinicease/services/item_service.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({Key? key}) : super(key: key);

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final ItemService _itemService = ItemService();
  late List<ItemModel> _items = [];
  late List<ItemModel> _filteredItems = [];
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final items = await _itemService.getItem();
    setState(() {
      _items = items;
      _filteredItems = List.from(_items);
    });
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = _items
          .where((item) => item.itemName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("e-Medication Shop"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterItems,
              decoration: InputDecoration(
                hintText: 'Search by item name...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return ItemCardWidget(item: item);
              },
            ),
          ),
        ],
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
                  // Item name
                  FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      item.itemName!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text('RM ${item.itemPrice}'),
                  const SizedBox(height: 16),

                  // Buy Now Button
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

class ItemSearchDelegate extends SearchDelegate<String> {
  final List<ItemModel> items;
  final Function(String) onSearch;

  ItemSearchDelegate(this.items, this.onSearch);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch(query);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item.itemName!),
          onTap: () {
            close(context, item.itemName!);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? items
        : items.where((item) => item.itemName!.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final item = suggestionList[index];
        return ListTile(
          title: Text(item.itemName!),
          onTap: () {
            close(context, item.itemName!);
          },
        );
      },
    );
  }
}
