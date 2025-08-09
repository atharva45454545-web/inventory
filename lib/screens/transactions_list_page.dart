// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class TransactionListPage extends StatelessWidget {
//   const TransactionListPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     const Color backgroundColor = Color(0xFFF4F6FD);
//     const Color primaryColor = Color.fromARGB(255, 0, 183, 255);
//     const Color textColor = Color(0xFF212121);
//     const Color iconColor = Color(0xFF3949AB);

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: const Text('All Transactions'),
//         centerTitle: true,
//         elevation: 4,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream:
//             FirebaseFirestore.instance.collection('transactions').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           final docs = snapshot.data?.docs ?? [];
//           if (docs.isEmpty) {
//             return const Center(child: Text('No transactions found.'));
//           }

//           final items =
//               docs.map((doc) {
//                 final data = doc.data() as Map<String, dynamic>;
//                 final status = (data['status'] ?? 'active').toString();
//                 final ts = data['timestamp'] as Timestamp?;
//                 return {'doc': doc, 'status': status, 'timestamp': ts};
//               }).toList();

//           items.sort((a, b) {
//             final dataA =
//                 (a['doc']! as QueryDocumentSnapshot).data()
//                     as Map<String, dynamic>;
//             final dataB =
//                 (b['doc']! as QueryDocumentSnapshot).data()
//                     as Map<String, dynamic>;

//             final typeA = (dataA['type'] ?? '').toString().toLowerCase();
//             final typeB = (dataB['type'] ?? '').toString().toLowerCase();

//             // Returnable comes before non-returnable
//             if (typeA == 'returnable' && typeB != 'returnable') return -1;
//             if (typeA != 'returnable' && typeB == 'returnable') return 1;

//             // Then sort by returned status
//             final statusA = a['status'].toString();
//             final statusB = b['status'].toString();
//             if (statusA == 'returned' && statusB != 'returned') return 1;
//             if (statusA != 'returned' && statusB == 'returned') return -1;

//             // Then sort by timestamp (older first)
//             final tsA = a['timestamp'] as Timestamp?;
//             final tsB = b['timestamp'] as Timestamp?;
//             if (tsA == null || tsB == null) return 0;
//             return tsA.compareTo(tsB);
//           });

//           return ListView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             itemCount: items.length,
//             itemBuilder: (context, index) {
//               final doc = items[index]['doc'] as QueryDocumentSnapshot;
//               final data = doc.data() as Map<String, dynamic>;
//               final type = (data['type'] ?? '').toString();
//               final userName = (data['userName'] ?? '').toString();
//               final email = (data['userEmail'] ?? '').toString();
//               final status = (data['status'] ?? 'active').toString();
//               final ts = data['timestamp'] as Timestamp?;
//               final date =
//                   ts != null
//                       ? DateFormat(
//                         'dd-MM-yy HH:mm',
//                       ).format(ts.toDate().toLocal())
//                       : 'Unknown';
//               final reqTs = data['returnRequestedAt'] as Timestamp?;
//               final reqDate =
//                   reqTs != null
//                       ? DateFormat(
//                         'dd-MM-yy HH:mm',
//                       ).format(reqTs.toDate().toLocal())
//                       : null;
//               final apprTs = data['returnApprovedAt'] as Timestamp?;
//               final apprDate =
//                   apprTs != null
//                       ? DateFormat(
//                         'dd-MM-yy HH:mm',
//                       ).format(apprTs.toDate().toLocal())
//                       : null;

//               // Load items based on status
//               List<Map<String, dynamic>> itemsList = [];
//               if (status == 'returned' && data['returnRequest'] != null) {
//                 itemsList = List<Map<String, dynamic>>.from(
//                   data['returnRequest']['items'] ?? [],
//                 );
//               } else {
//                 itemsList = List<Map<String, dynamic>>.from(
//                   data['items'] ?? [],
//                 );
//               }

//               final isReturned = status == 'returned';
//               final isReturnable = type.toLowerCase() == 'returnable';
//               final isOverdue =
//                   ts != null &&
//                   isReturnable && // Only mark returnable as overdue
//                   !isReturned &&
//                   DateTime.now().difference(ts.toDate().toLocal()) >
//                       const Duration(hours: 24);

//               return Opacity(
//                 opacity: status == 'pending_return' ? 0.6 : 1.0,
//                 child: Card(
//                   color:
//                       status == 'pending_return'
//                           ? Colors.grey[200]
//                           : Colors.white,
//                   elevation: 2,
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(14),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // ─ Header
//                         Text(
//                           "${type.isNotEmpty ? type[0].toUpperCase() + type.substring(1) : 'Transaction'} by $userName",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: isOverdue ? Colors.red : textColor,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'Email: $email',
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'Date: $date',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: isOverdue ? Colors.red : textColor,
//                           ),
//                         ),
//                         if (reqDate != null)
//                           Padding(
//                             padding: const EdgeInsets.only(top: 4),
//                             child: Text(
//                               'Return requested: $reqDate',
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.orange,
//                               ),
//                             ),
//                           ),
//                         if (status == 'returned' && apprDate != null)
//                           Padding(
//                             padding: const EdgeInsets.only(top: 4),
//                             child: Text(
//                               'Return approved: $apprDate',
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.green,
//                               ),
//                             ),
//                           ),
//                         const Divider(height: 20),

//                         // ─ Items
//                         ...itemsList.map((e) {
//                           final itemId = e['itemId'] as String;
//                           final qty =
//                               (e['quantity'] ?? e['requestedQty']) as int;
//                           return FutureBuilder<DocumentSnapshot>(
//                             future:
//                                 FirebaseFirestore.instance
//                                     .collection('items')
//                                     .doc(itemId)
//                                     .get(),
//                             builder: (context, snap) {
//                               if (snap.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return const ListTile(
//                                   title: Text('Loading item...'),
//                                 );
//                               }
//                               if (snap.hasError) {
//                                 return ListTile(
//                                   title: Text('Error: ${snap.error}'),
//                                   trailing: Text('Qty: $qty'),
//                                 );
//                               }
//                               if (!snap.hasData || !snap.data!.exists) {
//                                 return ListTile(
//                                   title: const Text('Unknown item'),
//                                   trailing: Text('Qty: $qty'),
//                                 );
//                               }
//                               final itemData =
//                                   snap.data!.data() as Map<String, dynamic>;
//                               final name =
//                                   itemData['name'] as String? ?? 'Unnamed';
//                               final teamName =
//                                   itemData['teamname']?.toString() ??
//                                   'Unknown Team';

//                               return ListTile(
//                                 leading: const Icon(
//                                   Icons.widgets_outlined,
//                                   color: iconColor,
//                                 ),
//                                 title: Text(
//                                   name,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 subtitle: Text(
//                                   'Team: $teamName',
//                                   style: const TextStyle(
//                                     fontSize: 13,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 trailing: Text('Qty: $qty'),
//                               );
//                             },
//                           );
//                         }).toList(),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({Key? key}) : super(key: key);

  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  Map<String, String> _itemNameCache = {}; // itemId -> name mapping

  String _filterType =
      'all'; // 'all' | 'returnable' | 'nonreturnable' | 'overdue'
  bool _sortAscending = true;
  String _searchEmail = '';
  final TextEditingController _searchController = TextEditingController();
  String _searchComponent = '';
  final TextEditingController _componentSearchController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadItemNames(); // ✅ This loads the component names when the page opens
  }

  @override
  void dispose() {
    _searchController.dispose();
    _componentSearchController.dispose(); // ✅ added here
    super.dispose();
  }

  Future<void> _loadItemNames() async {
    final snapshot = await FirebaseFirestore.instance.collection('items').get();
    setState(() {
      _itemNameCache = {
        for (var doc in snapshot.docs)
          doc.id: (doc['name'] ?? '').toString().toLowerCase(),
      };
    });
  }

  /// Converts the entire transaction (and its item entries) from non-returnable to returnable
  Future<void> _convertToReturnable(String transactionId) async {
    final docRef = FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionId);

    try {
      // 1. Read the current document
      final snapshot = await docRef.get();
      final data = snapshot.data() as Map<String, dynamic>;

      // 2. Build a new items array where each map’s `type` is now 'returnable'
      //    and the old `reason` field is removed
      final items = List<Map<String, dynamic>>.from(data['items'] ?? []);
      final updatedItems =
          items.map((item) {
            final newItem = Map<String, dynamic>.from(item);
            newItem['type'] = 'returnable';
            newItem.remove('reason');
            return newItem;
          }).toList();

      // 3. Update the transaction doc in-place:
      //    – set root-level `type` to 'returnable'
      //    – overwrite the `items` array with our updated version
      await docRef.update({'type': 'returnable', 'items': updatedItems});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction converted to returnable')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error converting: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF4F6FD);
    const primaryColor = Color.fromARGB(255, 0, 183, 255);
    const textColor = Color(0xFF212121);
    const iconColor = Color(0xFF3949AB);

    final query = FirebaseFirestore.instance
        .collection('transactions')
        .orderBy('timestamp', descending: !_sortAscending);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('All Transactions'),
        centerTitle: true,
        elevation: 4,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
            100,
          ), // Increased height for two bars
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by email',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged:
                      (value) => setState(
                        () => _searchEmail = value.trim().toLowerCase(),
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: TextField(
                  controller: _componentSearchController,
                  decoration: InputDecoration(
                    hintText: 'Search by component name',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.widgets_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged:
                      (value) => setState(
                        () => _searchComponent = value.trim().toLowerCase(),
                      ),
                ),
              ),
            ],
          ),
        ),

        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) => setState(() => _filterType = value),
            itemBuilder:
                (_) => const [
                  PopupMenuItem(value: 'all', child: Text('All')),
                  PopupMenuItem(value: 'returnable', child: Text('Returnable')),
                  PopupMenuItem(
                    value: 'nonreturnable',
                    child: Text('Non-returnable'),
                  ),
                  PopupMenuItem(value: 'overdue', child: Text('Overdue')),
                ],
          ),
          IconButton(
            icon: Icon(
              _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
            ),
            tooltip: 'Toggle sort order',
            onPressed: () => setState(() => _sortAscending = !_sortAscending),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }

          final items =
              docs
                  .map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return {
                      'doc': doc,
                      'type': (data['type'] ?? '').toString().toLowerCase(),
                      'timestamp':
                          (data['timestamp'] ?? data['borrowedAt'])
                              as Timestamp?,
                      'reqTs': data['returnRequestedAt'] as Timestamp?,
                      'apprTs': data['returnApprovedAt'] as Timestamp?,
                      'email':
                          (data['userEmail'] ?? data['email'] ?? '')
                              .toString()
                              .toLowerCase(),
                    };
                  })
                  .where((item) {
                    final type = item['type'] as String;
                    final ts = item['timestamp'] as Timestamp?;
                    final reqTs = item['reqTs'] as Timestamp?;
                    final apprTs = item['apprTs'] as Timestamp?;

                    // ✅ Transaction type filter
                    bool typeMatch;
                    switch (_filterType) {
                      case 'returnable':
                        typeMatch = type == 'returnable';
                        break;
                      case 'nonreturnable':
                        typeMatch = type != 'returnable';
                        break;
                      case 'overdue':
                        if (type != 'returnable' || ts == null) return false;
                        final overdue =
                            DateTime.now().difference(ts.toDate().toLocal()) >
                            const Duration(hours: 24);
                        typeMatch = overdue && reqTs == null && apprTs == null;
                        break;
                      default:
                        typeMatch = true;
                    }
                    if (!typeMatch) return false;

                    // ✅ Email search
                    if (_searchEmail.isNotEmpty) {
                      final email = item['email'] as String;
                      if (!email.contains(_searchEmail)) return false;
                    }

                    // ✅ Component name search
                    if (_searchComponent.isNotEmpty) {
                      final data =
                          (item['doc'] as QueryDocumentSnapshot).data()
                              as Map<String, dynamic>;
                      final itemsList = List<Map<String, dynamic>>.from(
                        data['items'] ?? [],
                      );

                      bool found = false;
                      for (var comp in itemsList) {
                        final itemId = (comp['itemId'] ?? '').toString();
                        final itemName = _itemNameCache[itemId] ?? '';
                        if (itemName.contains(_searchComponent)) {
                          found = true;
                          break;
                        }
                      }
                      if (!found) return false;
                    }

                    return true;
                  })
                  .toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final doc = items[index]['doc'] as QueryDocumentSnapshot;
              final data = doc.data() as Map<String, dynamic>;
              final type = data['type']?.toString() ?? '';
              final userName = data['userName']?.toString() ?? '';
              final email =
                  (data['userEmail'] ?? data['email'] ?? '').toString();
              final ts = items[index]['timestamp'] as Timestamp?;
              final dateStr =
                  ts != null
                      ? DateFormat(
                        'dd-MM-yy HH:mm',
                      ).format(ts.toDate().toLocal())
                      : 'Unknown';
              final reqDate = (items[index]['reqTs'] as Timestamp?)
                  ?.toDate()
                  .toLocal()
                  .let((d) => DateFormat('dd-MM-yy HH:mm').format(d));

              final apprDate = (items[index]['apprTs'] as Timestamp?)
                  ?.toDate()
                  .toLocal()
                  .let((d) => DateFormat('dd-MM-yy HH:mm').format(d));
              final status =
                  data['status']?.toString().toLowerCase() ?? 'active';
              final itemsList =
                  status == 'returned' && data['returnRequest'] != null
                      ? List<Map<String, dynamic>>.from(
                        data['returnRequest']['items'] ?? [],
                      )
                      : List<Map<String, dynamic>>.from(data['items'] ?? []);

              final isReturnable = type.toLowerCase() == 'returnable';
              final isOverdue =
                  ts != null &&
                  isReturnable &&
                  status != 'returned' &&
                  DateTime.now().difference(ts.toDate().toLocal()) >
                      const Duration(hours: 24);

              return Opacity(
                opacity: status == 'pending_return' ? 0.6 : 1.0,
                child: Card(
                  color:
                      status == 'pending_return'
                          ? Colors.grey[200]
                          : Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${type.isNotEmpty ? '${type[0].toUpperCase()}${type.substring(1)}' : 'Transaction'} by $userName",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isOverdue ? Colors.red : textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Email: $email',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Date: $dateStr',
                          style: TextStyle(
                            fontSize: 14,
                            color: isOverdue ? Colors.red : textColor,
                          ),
                        ),
                        if (reqDate != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Return requested: $reqDate',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.orange,
                              ),
                            ),
                          ),

                        // from Code B: if fully returned, display approval time
                        if (status == 'returned' && apprDate != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Return approved: $apprDate',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        const Divider(height: 20),
                        ...itemsList.map((item) {
                          final itemId = item['itemId'] as String;
                          final qty =
                              (item['quantity'] ?? item['requestedQty']) as int;
                          return FutureBuilder<DocumentSnapshot>(
                            future:
                                FirebaseFirestore.instance
                                    .collection('items')
                                    .doc(itemId)
                                    .get(),
                            builder: (context, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return const ListTile(
                                  title: Text('Loading item...'),
                                );
                              }
                              if (snap.hasError) {
                                return ListTile(
                                  title: Text('Error: ${snap.error}'),
                                  trailing: Text('Qty: $qty'),
                                );
                              }
                              if (!snap.hasData || !snap.data!.exists) {
                                return ListTile(
                                  title: const Text('Unknown item'),
                                  trailing: Text('Qty: $qty'),
                                );
                              }
                              final itemData =
                                  snap.data!.data() as Map<String, dynamic>;
                              final name =
                                  itemData['name'] as String? ?? 'Unnamed';
                              final teamName =
                                  itemData['teamname']?.toString() ??
                                  'Unknown Team';
                              return ListTile(
                                leading: const Icon(
                                  Icons.widgets_outlined,
                                  color: iconColor,
                                ),
                                title: Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  'Team: $teamName',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                trailing: Text('Qty: $qty'),
                              );
                            },
                          );
                        }).toList(),

                        // <- Here’s the new button, only for non-returnable transactions
                        if (!isReturnable)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: ElevatedButton(
                              onPressed: () => _convertToReturnable(doc.id),
                              child: const Text('Convert to Returnable'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Helper extension for nullable mapping
extension LetExtension<T> on T {
  R let<R>(R Function(T) op) => op(this);
}
