import 'package:clinicease/screen/home_screen.dart';
import 'package:flutter/material.dart';

class MyProfileScreen extends StatelessWidget {
  TextStyle _textStyle = TextStyle(
    fontFamily: 'PoppinsRegular',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(
            fontFamily: 'PoppinsRegular',
            color: Color(0xFF202050),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF202050)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              onTap: () {
                // Handle Personal Information onTap
              },
              title: Text(
                'Personal Information',
                style: _textStyle,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          SizedBox(height: 20.0),
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              onTap: () {
                // Handle My Rewards onTap
              },
              title: Text(
                'My Rewards',
                style: _textStyle,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          SizedBox(height: 20.0),
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              onTap: () {
                // Handle Log Out onTap
              },
              title: Text(
                'Log Out',
                style: _textStyle,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }
}
