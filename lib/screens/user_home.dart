// lib/screens/user_home.dart

import 'package:flutter/material.dart';
import '/screens/my_borrowings_nonret_page.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

// Existing imports
import 'returnable_page.dart';
import 'non_returnable_page.dart';
import 'my_borrowings_page.dart';

// ← NEW: import the BorrowLaptopPage
// import 'borrow_laptop_page.dart';

class UserHome extends StatelessWidget {
  const UserHome({Key? key}) : super(key: key);

  void _signOut(BuildContext context) {
    context.read<AuthService>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Professional color palette
    const Color backgroundColor = Color(0xFFF4F6FD);
    const Color primaryColor = Color.fromARGB(
      255,
      0,
      183,
      255,
    ); // Indi900 // Light grey background
    // const Color primaryColor = Color(0xFF1A237E); // Indigo 900 (AppBar)
    const Color iconColor = Color(0xFF3949AB); // Indigo 600 (Icons)
    const Color textColor = Color(0xFF212121); // Dark grey (Text)
    const Color accentColor = Color(0xFF00ACC1); // Teal (Highlights)
    const Color logoutColor = Color(0xFFD32F2F); // Bold Red (Logout)

    // Helper to build each grid card
    Widget _buildGridItem({
      required IconData icon,
      required String label,
      required VoidCallback onTap,
      Color? iconTint,
      Color? overlayColor,
    }) {
      return Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: (overlayColor ?? iconTint)?.withOpacity(0.2),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36, color: iconTint ?? iconColor),
                const SizedBox(height: 12),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('User Dashboard'),
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: accentColor,
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Welcome,',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'User',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Grid of actions
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildGridItem(
                      icon: Icons.assignment_returned_outlined,
                      label: 'Returnable Items',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReturnablePage(),
                          ),
                        );
                      },
                      overlayColor: accentColor,
                    ),
                    _buildGridItem(
                      icon: Icons.inventory_2_outlined,
                      label: 'Non-Returnable Items',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NonReturnablePage(),
                          ),
                        );
                      },
                      overlayColor: accentColor,
                    ),

                    // _buildGridItem(
                    //   icon: Icons.laptop_chromebook_outlined,
                    //   label: 'Borrow Others',
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (_) => const BorrowLaptopPage(),
                    //       ),
                    //     );
                    //   },
                    //   overlayColor: accentColor,
                    // ),
                    _buildGridItem(
                      icon: Icons.book_online_outlined,
                      label: 'My Returnables',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyBorrowingsPage(),
                          ),
                        );
                      },
                      overlayColor: accentColor,
                    ),
                    _buildGridItem(
                      icon: Icons.book_online_outlined,
                      label: 'My Non Returnables',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NonReturnableItemsScreen(),
                          ),
                        );
                      },
                      overlayColor: accentColor,
                    ),

                    _buildGridItem(
                      icon: Icons.laptop_chromebook_outlined,
                      label: 'Borrow Others',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Coming Soon!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      overlayColor: accentColor,
                    ),
                  ],
                ),
              ),

              // Logout Button at bottom
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: logoutColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.logout, size: 24),
                  label: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () => _signOut(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
