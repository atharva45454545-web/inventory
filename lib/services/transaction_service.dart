// lib/services/transaction_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Creates a transaction and decrements stock atomically
  Future<void> createTransaction({
    required bool isReturnable,
    required String userName,
    String? reason,
    required Map<String, int> items,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final email = user.email ?? '';
    final uid = user.uid;

    final batch = _firestore.batch();
    final txRef = _firestore.collection('transactions').doc();

    // Prepare transaction document, now including userEmail and userId
    batch.set(txRef, {
      'userId': uid,
      'userEmail': email,
      'status': 'active', // ← add this line
      'type': isReturnable ? 'returnable' : 'non_returnable',
      'userName': userName,
      if (!isReturnable) 'reason': reason,
      'items':
          items.entries
              .map((e) => {'itemId': e.key, 'quantity': e.value})
              .toList(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Decrement each item's stock
    for (var entry in items.entries) {
      final itemRef = _firestore.collection('items').doc(entry.key);
      batch.update(itemRef, {'quantity': FieldValue.increment(-entry.value)});
    }

    await batch.commit();
  }
}
