import 'package:clinicease/screen/login_screen.dart';
import 'package:clinicease/screen/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetStorage _box = GetStorage();
  String? userId;

  @override
  void initState() {
    userId = _box.read('uid');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ClinicEase',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF202050),
        elevation: 4.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity, // Make My Rewards banner fill screen width
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFF6ABAE1), // Background color for My Rewards banner
              child: const Row(
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
            const DisplayCardWidget(),
            const SizedBox(height: 20), // Add some space between the cards and menu
            const MenuCategoriesWidget(),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF202050),
              ),
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
            ),
            ListTile(
              title: const Text(
                'My Transaction History',
              ),
              onTap: () {
                // Add onTap functionality for Transaction History
              },
            ),
            ListTile(
              title: const Text(
                'My Profile',
              ),
              onTap: () {
                // Close drawer
                Navigator.pop(context);

                // Navigate to My Profile screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const MyProfileScreen()
                  )
                );
              },
            ),
            ListTile(
              title: const Text(
                'Log Out',
              ),
              onTap: () {
                // Clear user ID from storage
                _box.remove('uid');

                // Navigate to login screen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
class DisplayCardWidget extends StatelessWidget {
  const DisplayCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6ABAE1),
        borderRadius: BorderRadius.circular(10),
      ),
      
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Text(
            'My Rewards',
            
            style: TextStyle( // Use _textStyle
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
      
          SizedBox(height: 8,),
          Text(
            'Points: 100', // Display rewards points here
            style: TextStyle( // Use _textStyle
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
  const MenuCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Menu Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'PoppinsRegular', 
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2, // Two columns
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // Disable scroll for GridView
          children: [
            const MenuCategoryCard(
              icon: Icons.calendar_today,
              label: 'Book Appointment',
              backgroundColor: Colors.blue,
            ),
            const MenuCategoryCard(
              icon: Icons.shopping_cart,
              label: 'E-Medi Shop',
              backgroundColor: Colors.green,
            ),
            const MenuCategoryCard(
              icon: Icons.card_giftcard,
              label: 'Reward Shop',
              backgroundColor: Colors.orange,
            ),
            MenuCategoryCard(
              icon: Icons.person,
              label: 'My Profile',
              backgroundColor: Colors.purple,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyProfileScreen(),
                  ),
                );
              }
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
  final void Function()? onTap;

  const MenuCategoryCard({super.key, 
    required this.icon,
    required this.label,
    required this.backgroundColor,
    this.onTap,
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
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
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

  const MenuCategoryItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 40,
          color: const Color(0xFF202050),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'PoppinsRegular',
          ),
        ),
      ],
    );
  }
}



 

