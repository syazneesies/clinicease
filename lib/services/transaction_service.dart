import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinicease/models/transaction_model.dart';

class TransactionService {
  final CollectionReference transactionCollection =
      FirebaseFirestore.instance.collection('transactions');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to retrieve transactions based on receipt ID
  Future<List<TransactionModel>> getTransactionByReceiptID(String receiptID) async {
    List<TransactionModel> transactions = [];

    try {
      QuerySnapshot querySnapshot = await transactionCollection.where('receiptId', isEqualTo: receiptID).get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        TransactionModel transaction = TransactionModel.fromJson(data);
        transactions.add(transaction);
      }
    } catch (e) {
      print("Error getting transactions by receipt ID: $e");
    }

    return transactions;
  }
}
