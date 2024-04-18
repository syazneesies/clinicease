import 'package:flutter/material.dart';

class AddRewardScreen extends StatefulWidget {
   const AddRewardScreen({super.key});

  @override
  _AddRewardScreenState createState() => _AddRewardScreenState();
}

class _AddRewardScreenState extends State<AddRewardScreen> {
  TextEditingController _receiptIDController = TextEditingController();
  int _rewardPoints = 0;

  void _collectPoints() {
    // Get the text entered by the user
    String enteredReceiptID = _receiptIDController.text;

    // Dummy logic to check if the entered receipt ID is '12345'
    if (enteredReceiptID == '12345') {
      // Update reward points if receipt ID matches
      setState(() {
        _rewardPoints += 10; // Add 10 reward points
      });
    } else {
      // Handle case where receipt ID does not match
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Receipt ID'),
            content: Text('The entered receipt ID is not valid.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
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
              controller: _receiptIDController,
              decoration: InputDecoration(
                labelText: 'Enter Receipt ID',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _collectPoints,
              child: Text('Collect Points'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Reward Points: $_rewardPoints',
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
    _receiptIDController.dispose();
    super.dispose();
  }
}
