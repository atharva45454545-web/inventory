// lib/screens/admin_home.dart

import 'package:flutter/material.dart';
import '/screens/item_list_page_mod.dart';
import '/screens/modification_transaction_page.dart';
import '/screens/return_requests_page.dart';
import '/screens/transactions_list_page.dart';
import '/screens/team_overview_page.dart';
import '/screens/laptop_transactions_page.dart';
import '/screens/add_laptop_page.dart';
import '/screens/add_item_page.dart';
import '/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'pending_account_.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);

  void _signOut(BuildContext context) {
    context.read<AuthService>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Professional color palette
    const Color backgroundColor = Color(0xFFF4F6FD); // Light grey background
    const Color primaryColor = Color.fromARGB(255, 0, 183, 255); // Indi900
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
        title: const Text('Admin Dashboard'),
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
                      Icons.admin_panel_settings,
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
                        'Administrator',
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

              // Grid of actions wrapped in a Scrollbar to indicate scrollability
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true, // Always show the scrollbar thumb
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildGridItem(
                        icon: Icons.assignment_return_outlined,
                        label: 'Process Returns',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ReturnRequestsPage(),
                            ),
                          );
                        },
                        overlayColor: accentColor,
                      ),
                      _buildGridItem(
                        icon: Icons.list_alt_outlined,
                        label: 'View All Transactions',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TransactionListPage(),
                            ),
                          );
                        },
                        overlayColor: accentColor,
                      ),
                      _buildGridItem(
                        icon: Icons.laptop_mac_outlined,
                        label: 'Laptop Transactions',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LaptopTransactionsPage(),
                            ),
                          );
                        },
                        overlayColor: accentColor,
                      ),
                      _buildGridItem(
                        icon: Icons.category_outlined,
                        label: 'Team Inventory',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TeamOverviewPage(),
                            ),
                          );
                        },
                        overlayColor: accentColor,
                      ),
                      _buildGridItem(
                        icon: Icons.laptop_outlined,
                        label: 'Add/ Laptop',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddLaptopPage(),
                            ),
                          );
                        },
                        overlayColor: accentColor,
                      ),
                      _buildGridItem(
                        icon: Icons.add_box,
                        label: 'Add Item',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddItemPage(),
                            ),
                          );
                        },
                        overlayColor: accentColor,
                      ),
                      _buildGridItem(
                        icon: Icons.edit, // Changed icon for Modify Items
                        label: 'Modify Items',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ItemListPage(),
                            ),
                          );
                        },
                        overlayColor: accentColor,
                      ),
                      _buildGridItem(
                        icon:
                            Icons
                                .swap_horiz, // Changed icon for Modify Transactions
                        label: 'Modify Transactions',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdjustmentListPage(),
                            ),
                          );
                        },
                        overlayColor: accentColor,
                      ),
                      _buildGridItem(
                        icon: Icons.verified_user_outlined,
                        label: 'Approve Accounts',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      const PendingAccountsPage(), // Replace with actual widget
                            ),
                          );
                        },
                        overlayColor: accentColor,
                      ),
                    ],
                  ),
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
