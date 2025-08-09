// // lib/screens/user_home.dart

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/auth_service.dart';

// // Existing imports
// import 'returnable_page.dart';
// import 'non_returnable_page.dart';
// import 'my_borrowings_page.dart';

// // ← NEW: import the BorrowLaptopPage
// import 'borrow_laptop_page.dart';

// class UserHome extends StatelessWidget {
//   const UserHome({Key? key}) : super(key: key);

//   void _signOut(BuildContext context) {
//     context.read<AuthService>().signOut();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Dashboard'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () => _signOut(context),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Returnable Items
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const ReturnablePage()),
//                 );
//               },
//               child: const Text('Returnable Items'),
//             ),

//             const SizedBox(height: 16),

//             // Non-Returnable Items
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const NonReturnablePage()),
//                 );
//               },
//               child: const Text('Non-Returnable Items'),
//             ),

//             const SizedBox(height: 16),

//             // ← NEW: Borrow Laptop
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const BorrowLaptopPage()),
//                 );
//               },
//               child: const Text('Borrow a Laptop'),
//             ),

//             const SizedBox(height: 16),

//             // My Borrowings
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const MyBorrowingsPage()),
//                 );
//               },
//               child: const Text('My Borrowings'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
