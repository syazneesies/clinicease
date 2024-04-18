import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinicease/models/item_model.dart';

class ItemService {
  final CollectionReference itemCollection =
      FirebaseFirestore.instance.collection('items');

  Future<List<ItemModel>> getItems() async {
    List<ItemModel> items = [];

    try {
      QuerySnapshot querySnapshot = await itemCollection.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        ItemModel item = ItemModel.fromJson(data);
        items.add(item);
      }
    } catch (e) {
      print("Error getting services: $e");
    }

    return items;
  }
}
