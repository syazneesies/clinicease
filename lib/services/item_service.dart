import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinicease/models/item_model.dart';

class ItemService {
  final CollectionReference itemCollection =
      FirebaseFirestore.instance.collection('items');
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   Future<List<ItemModel>> getItem() async {
    List<ItemModel> items = [];

    try {
      QuerySnapshot querySnapshot = await itemCollection.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print("Item Fetched: $data");
        ItemModel item = ItemModel.fromJson(data);
        item.itemId = doc.id;
        items.add(item);
      }
    } catch (e) {
      print("Error getting items: $e");
    }

    return items;
  }

  Future<ItemModel?> getItemData(String itemUID) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('items').doc(itemUID).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> itemData = documentSnapshot.data() as Map<String, dynamic>;
        ItemModel item = ItemModel.fromJson(itemData);
        item.itemId = documentSnapshot.id;
        return item;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching item data: $e");
      return null;
    }
  }
  
}
