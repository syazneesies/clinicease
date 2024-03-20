import 'package:clinicease/screen/my_profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  TextStyle _textStyle = TextStyle(
    fontFamily: 'PoppinsRegular',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ClinicEase',
          style: TextStyle(
            fontFamily: 'PoppinsRegular',
          ),
        ),
        backgroundColor: Color(0xFF202050),
        elevation: 4.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity, // Make My Rewards banner fill screen width
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Color(0xFF6ABAE1), // Background color for My Rewards banner
              child: Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 32,
                    color: Color(0xFF202050),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            DisplayCardWidget(),
            SizedBox(height: 20), // Add some space between the cards and menu
            MenuCategoriesWidget(),
          ],
        ),
      ),
      drawer: Drawer( // Add a drawer for the menu bar
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'PoppinsRegular',
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF202050),
              ),
            ),
            ListTile(
              title: Text(
                'My Transaction History',
                style: _textStyle,
              ),
              onTap: () {
                // Add onTap functionality for Transaction History
              },
            ),
            ListTile(
              title: Text(
                'My Profile',
                style: _textStyle,
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => MyProfileScreen()),
                );
              },
            ),
            ListTile(
              title: Text(
                'Log Out',
                style: _textStyle,
              ),
              onTap: () {
                // Add onTap functionality for Log Out
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DisplayCardWidget extends StatelessWidget {
   TextStyle _textStyle = TextStyle(
    fontFamily: 'PoppinsRegular',
   );
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF6ABAE1),
        borderRadius: BorderRadius.circular(10),
      ),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Text(
            'My Rewards',
            style:_textStyle.copyWith( // Use _textStyle
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
      
          SizedBox(height: 8,),
          Text(
            'Points: 100', // Display rewards points here
            style: _textStyle.copyWith( // Use _textStyle
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuCategoriesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Menu Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'PoppinsRegular', // Use Poppins font
            ),
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2, // Two columns
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), // Disable scroll for GridView
          children: [
            MenuCategoryCard(
              icon: Icons.calendar_today,
              label: 'Book Appointment',
              backgroundColor: Colors.blue,
            ),
            MenuCategoryCard(
              icon: Icons.shopping_cart,
              label: 'E-Medi Shop',
              backgroundColor: Colors.green,
            ),
            MenuCategoryCard(
              icon: Icons.card_giftcard,
              label: 'Reward Shop',
              backgroundColor: Colors.orange,
            ),
            MenuCategoryCard(
              icon: Icons.person,
              label: 'My Profile',
              backgroundColor: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }
}

class MenuCategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;

  MenuCategoryCard({
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0, // Add elevation for a raised effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: backgroundColor,
      child: InkWell(
        onTap: () {
          // Add onTap functionality here
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MenuCategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  MenuCategoryItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 40,
          color: Color(0xFF202050),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'PoppinsRegular',
          ),
        ),
      ],
    );
  }
}



 

