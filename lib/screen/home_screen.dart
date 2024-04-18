import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinicease/models/user_model.dart';
import 'package:clinicease/screen/add_reward_screen.dart';
import 'package:clinicease/screen/item_screen.dart';
import 'package:clinicease/screen/login_screen.dart';
import 'package:clinicease/screen/my_profile_screen.dart';
import 'package:clinicease/screen/reward_screen.dart';
import 'package:clinicease/screen/service_screen.dart';
import 'package:clinicease/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime now = DateTime.now();
  UserModel? user;
  String? userId;
  String? greeting;

  @override
  void initState() {
    // Get user ID from storage
    userId = StorageService.getUID();
    if (now.hour < 12) {
      greeting = 'Good Morning';
    } else if (now.hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    // Get user data from storage
    user = StorageService.getUserData();
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFF6ABAE1), // Background color for My Rewards banner
              child: Row(
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 40,
                    color: Color(0xFF202050),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AutoSizeText(
                      '$greeting, ${user?.fullName ?? 'User'}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      minFontSize: 8,
                      maxFontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            const DisplayCardWidget(),
            const SizedBox(height: 20),
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
                StorageService.clearAll();

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
          crossAxisCount: 2, 
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), 
          children: [
            MenuCategoryCard(
              icon: Icons.calendar_today,
              label: 'Book Appointment',
              backgroundColor: Colors.blue,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ServiceScreen(),
                  ),
                );
              },
            ),
           MenuCategoryCard(
              icon: Icons.shopping_cart,
              label: 'Online Shop',
              backgroundColor: Colors.green,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ItemScreen(),
                  ),
                );
              },
            ),
            MenuCategoryCard(
              icon: Icons.card_giftcard,
              label: 'Reward Shop',
              backgroundColor: Colors.orange,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RewardScreen(),
                  ),
                );
              },
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
            MenuCategoryCard(
              icon: Icons.add,
              label: 'Add Reward',
              backgroundColor: Colors.pink,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddRewardScreen() ,
                  ),
                );
              }
            ),
            MenuCategoryCard(
              icon: Icons.call,
              label: 'Emergency',
              backgroundColor: Colors.red,
              onTap: () async {
                if (!await launchUrl(Uri.parse('tel:+60132152852'))) {
                  throw Exception('Could not launch URL');
                }
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



 

