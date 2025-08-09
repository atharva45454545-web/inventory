// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/screens/return_requests_page.dart';
// import 'package:flutter_application_2/screens/transactions_list_page.dart';
// import 'package:flutter_application_2/screens/team_overview_page.dart';
// import 'package:flutter_application_2/services/auth_service.dart';
// import 'package:provider/provider.dart';
// import 'laptop_transactions_page.dart';
// // ← New import for AddLaptopPage
// import 'add_laptop_page.dart';
// import 'add_item_page.dart';

// class AdminHome extends StatelessWidget {
//   const AdminHome({Key? key}) : super(key: key);

//   void _signOut(BuildContext context) {
//     context.read<AuthService>().signOut();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin'),
//         actions: [
//           // In admin_home.dart
//           IconButton(
//             icon: const Icon(Icons.laptop_mac),
//             tooltip: 'Laptop Transactions',
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => LaptopTransactionsPage()),
//               );
//             },
//           ),

//           // Team Inventory icon
//           IconButton(
//             icon: const Icon(Icons.category),
//             tooltip: 'Team Inventory',
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const TeamOverviewPage()),
//               );
//             },
//           ),

//           // Process Returns icon
//           IconButton(
//             icon: const Icon(Icons.assignment_return),
//             tooltip: 'Process Returns',
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const ReturnRequestsPage()),
//               );
//             },
//           ),

//           // View All Transactions icon
//           IconButton(
//             icon: const Icon(Icons.list_alt),
//             tooltip: 'View Transactions',
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const TransactionListPage()),
//               );
//             },
//           ),

//           // ← NEW: Icon to add a Laptop
//           IconButton(
//             icon: const Icon(Icons.laptop),
//             tooltip: 'Add Laptop',
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const AddLaptopPage()),
//               );
//             },
//           ),

//           // Logout icon
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () => _signOut(context),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Text(
//           'Welcome, Admin!',
//           style: Theme.of(context).textTheme.headlineLarge,
//         ),
//       ),
//       // ← You could keep a FAB for “Add Generic Item,” leaving it as-is
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const AddItemPage()),
//           );
//         },
//         child: const Icon(Icons.inventory),
//       ),
//     );
//   }
// }
