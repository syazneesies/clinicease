import 'package:clinicease/models/user_model.dart';
import 'package:clinicease/services/storage_service.dart';
import 'package:clinicease/services/transaction_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddRewardScreen extends StatefulWidget {
  const AddRewardScreen({Key? key}) : super(key: key);

  @override
  _AddRewardScreenState createState() => _AddRewardScreenState();
}

class _AddRewardScreenState extends State<AddRewardScreen> {
  TextEditingController _receiptNumberController = TextEditingController();
  UserModel? user;
  String? userId;
  int? _rewardPoints; 

  Future<bool> checkReceiptExistence(String receiptNumber) async {
  try {
    var transactionsCollection = FirebaseFirestore.instance.collection('transactions');
    
    // Query for documents where receiptNumber matches the user input
    var querySnapshot = await transactionsCollection.where('receiptNumber', isEqualTo: int.parse(receiptNumber)).get();
    
    // If there are any documents returned, the receipt number exists
    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error checking receipt existence: $e');
    return false;
  }
}


  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  void _initializeScreen() async {
    // Fetch userId from StorageService
    userId = await StorageService.getUID();
    // Fetch user data using userId
    user = await StorageService.getUserData();
    // Set the reward points
    setState(() {
      _rewardPoints = user?.rewardPoints;
    });
  }

  void _fetchUserRewardPoints() async {
    setState(() {
      _rewardPoints = user?.rewardPoints;
    });
  }
  
 void _collectPoints() async {
  // Get the entered receipt number
  String receiptNumber = _receiptNumberController.text.trim();

  // Check if the receipt number exists in the database
  bool receiptExists = await checkReceiptExistence(receiptNumber);

  if (receiptExists) {
    // If receipt number exists, fetch the transaction value
    int? transactionValue = await fetchTransactionValue(receiptNumber);
    
    // If transactionValue is null, handle the case where the value couldn't be fetched
    if (transactionValue != null) {
      // Display a confirmation popup with the transaction value
      _showConfirmationPopup(transactionValue);
    } else {
      // Handle the case where transaction value couldn't be fetched
      print("Error: Transaction value couldn't be fetched.");
    }
  } else {
    // If receipt number doesn't exist, display an error popup
    _showErrorPopup();
  }
}

Future<int?> fetchTransactionValue(String receiptNumber) async {
  try {
    var transactionsCollection = FirebaseFirestore.instance.collection('transactions');
    var querySnapshot = await transactionsCollection.where('receiptNumber', isEqualTo: int.parse(receiptNumber)).get();
    
    if (querySnapshot.docs.isNotEmpty) {
      // If a document with the receipt number exists, fetch the transaction value
      var transactionData = querySnapshot.docs.first.data();
      return transactionData['transactionValue'] as int?;
    } else {
      // Handle the case where the receipt number doesn't exist
      print("Error: Receipt number doesn't exist.");
      return null;
    }
  } catch (e) {
    // Handle any errors that occur during the query
    print('Error fetching transaction value: $e');
    return null;
  }
}

void _showConfirmationPopup(int transactionValue) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirmation'),
      content: Text('Would you like to redeem $transactionValue points?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the popup
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // Implement the logic to redeem points and update reward points
            await _redeemPointsAndUpdate(transactionValue);
            Navigator.pop(context); // Close the popup
          },
          child: Text('Confirm'),
        ),
      ],
    ),
  );
}

Future<void> _redeemPointsAndUpdate(int transactionValue) async {
  try {
    // Calculate new reward points after redemption
    int newRewardPoints = (_rewardPoints ?? 0) + transactionValue;

    // Update reward points in Firestore for the current user
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'rewardPoints': newRewardPoints,
    });

    // Update the UI with the new reward points
    setState(() {
      _rewardPoints = newRewardPoints;
    });

    // Display a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reward points updated successfully.')),
    );
  } catch (e) {
    // Handle any errors that occur during the update
    print('Error updating reward points: $e');

    // Display an error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update reward points. Please try again.')),
    );
  }
}


void _showErrorPopup() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Error'),
      content: Text('Receipt Number not found. Please try again.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the popup
          },
          child: Text('Retry'),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reward'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _receiptNumberController,
              decoration: InputDecoration(
                labelText: 'Enter Receipt Number',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _collectPoints,
              child: Text('Collect Points'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Reward Points: ${_rewardPoints ?? "Loading..."}',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _receiptNumberController.dispose();
    super.dispose();
  }
}
