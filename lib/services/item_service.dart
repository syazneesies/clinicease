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
        ItemModel item = ItemModel.fromJson(data);
        item.itemId = doc.id;
        items.add(item);
      }
    } catch (e) {
      print("Error getting items: $e");
    }

    return items;
  }

    // Retrieve service data by UID from Firestore
  Future<ItemModel?> getItemData(String itemUID) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('items').doc(itemUID).get();

      if (documentSnapshot.exists) {
        // Service data found, parse it into UserModel
        Map<String, dynamic> itemData = documentSnapshot.data() as Map<String, dynamic>;
        ItemModel item = ItemModel.fromJson(itemData);
        item.itemId= documentSnapshot.id;
        return item;
      } else {
        // Service data not found
        return null;
      }
    } catch (e) {
      // Error occurred while fetching user data
      print("Error fetching item data: $e");
      return null;
    }
  }
}
