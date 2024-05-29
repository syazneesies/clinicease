import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinicease/models/user_model.dart';
import 'package:clinicease/screen/add_reward_screen.dart';
import 'package:clinicease/screen/item_screen.dart';
import 'package:clinicease/screen/login_screen.dart';
import 'package:clinicease/screen/my_booking_screen.dart';
import 'package:clinicease/screen/my_profile_screen.dart';
import 'package:clinicease/screen/my_purchased_item_screen.dart';
import 'package:clinicease/screen/my_reward_screen.dart';
import 'package:clinicease/screen/reward_screen.dart';
import 'package:clinicease/screen/service_screen.dart';
import 'package:clinicease/services/auth_service.dart';
import 'package:clinicease/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
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

    onRefresh();

    super.initState();
  }

  onRefresh() async {
    // Get user data from storage
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    await _auth.getUserData(firebaseUser!.uid).then((value) {
      if (value != null) {
        StorageService.setUserData(value);
      }
    });

    user = StorageService.getUserData();
    setState(() {});
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
      body: RefreshIndicator(
        onRefresh: () async => onRefresh(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        '$greeting, ${user?.fullName ?? 'User'}!',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF202050),
                        ),
                        maxLines: 2,
                        minFontSize: 8,
                        maxFontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              DisplayCardWidget(user: user),
              const SizedBox(height: 20),
              const MenuCategoriesWidget(),
            ],
          ),
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => MyPurchasedItemScreen()
                  )
                );
              },
            ),
            ListTile(
              title: const Text(
                'My Booking History',
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const MyBookingsScreen()
                  )
                );
              },
            ),
            ListTile(
              title: const Text(
                'My Purchased Rewards',
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const MyRewardScreen()
                  )
                );
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
  final UserModel? user;

  const DisplayCardWidget({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFDC830), Color(0xFFEAB23F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.card_giftcard,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'My Rewards',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Points: ${user?.rewardPoints ?? '-'}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Text(
              'ClinicEase',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.5),
              ),
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
        const SizedBox(height: 1),
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
              gradientColors: [const Color.fromARGB(255, 17, 83, 137), Colors.lightBlueAccent],
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ServiceScreen(),
                  ),
                );
              },
            ),
            MenuCategoryCard(
              icon: Icons.shopping_cart,
              label: 'e-Medication Shop',
              gradientColors: [Colors.green, Colors.lightGreenAccent],
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ItemScreen(),
                  ),
                );
              },
            ),
            MenuCategoryCard(
              icon: Icons.card_giftcard,
              label: 'Reward Shop',
              gradientColors: [Colors.orange, Colors.deepOrangeAccent],
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RewardScreen(),
                  ),
                );
              },
            ),
            MenuCategoryCard(
              icon: Icons.person,
              label: 'My Profile',
              gradientColors: [Colors.purple, Colors.deepPurpleAccent],
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
              gradientColors: [Color.fromARGB(255, 138, 19, 59), Colors.pinkAccent],
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddRewardScreen() ,
                  ),
                );
              }
            ),
            MenuCategoryCard(
              icon: Icons.call,
              label: 'Emergency',
              gradientColors: [const Color.fromARGB(255, 172, 43, 34), Colors.redAccent],
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
  final List<Color> gradientColors;
  final void Function()? onTap;

  const MenuCategoryCard({super.key, 
    required this.icon,
    required this.label,
    required this.gradientColors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
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
      ),
    );
  }
}
