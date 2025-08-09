import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactions =
        FirebaseFirestore.instance
            .collection('transactions')
            .orderBy('borrowDate', descending: true)
            .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('All Transactions')),
      body: StreamBuilder<QuerySnapshot>(
        stream: transactions,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No transactions yet.'));
          }

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final borrowTs = (data['borrowDate'] as Timestamp).toDate();
              final returnTs =
                  data['returnDate'] != null
                      ? (data['returnDate'] as Timestamp).toDate()
                      : null;

              return ListTile(
                title: Text(data['borrowerName'] ?? 'Unknown'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Item ID: ${data['itemId']}'),
                    Text('Borrowed: $borrowTs'),
                    if (returnTs != null) Text('Returned: $returnTs'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
