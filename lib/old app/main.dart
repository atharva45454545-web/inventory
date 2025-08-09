import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'transaction.dart';

// TODO: If using non-default Firebase options, import your firebase_options.dart:
// import 'firebase_options.dart';

/// List of admin emails allowed to add/delete items.
const List<String> adminEmails = ['atharva2304@gmail.com'];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Library',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthGate(),
    );
  }
}

/// Determines if user is signed in or not.
class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData) {
          return const SignInScreen();
        }
        return ItemListScreen(user: snapshot.data!);
      },
    );
  }
}

/// Simple email/password sign-in and registration screen.
class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Sign In' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text(_isLogin ? 'Login' : 'Register'),
            ),
            TextButton(
              onPressed:
                  () => setState(() {
                    _isLogin = !_isLogin;
                    _errorMessage = null;
                  }),
              child: Text(
                _isLogin ? 'Create account' : 'Have an account? Sign in',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Main screen showing list of items. Admins can add/delete; everyone can borrow/return.
class ItemListScreen extends StatelessWidget {
  final User user;
  const ItemListScreen({Key? key, required this.user}) : super(key: key);

  bool get isAdmin => adminEmails.contains(user.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items (${user.email})'),
        actions: [
          // Button to view all transactions
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'View Transactions',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TransactionsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddItemScreen()),
                  ),
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No items found'));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, idx) {
              final doc = docs[idx];
              final data = doc.data();
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(data['title'] ?? ''),
                  subtitle: Text(
                    'Available: ${data['availableQuantity']} / ${data['totalQuantity']}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed:
                            () => _borrowItem(
                              context,
                              doc.id,
                              data['availableQuantity'] as int,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed:
                            () => _returnItem(
                              context,
                              doc.id,
                              data['availableQuantity'] as int,
                              data['totalQuantity'] as int,
                            ),
                      ),
                      if (isAdmin)
                        IconButton(
                          icon: const Icon(Icons.delete_forever),
                          onPressed:
                              () =>
                                  FirebaseFirestore.instance
                                      .collection('items')
                                      .doc(doc.id)
                                      .delete(),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _borrowItem(BuildContext context, String itemId, int available) {
    if (available <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Out of stock')));
      return;
    }
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Borrow Item'),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Your name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  if (name.isEmpty) return;
                  final itemRef = FirebaseFirestore.instance
                      .collection('items')
                      .doc(itemId);
                  final txRef =
                      FirebaseFirestore.instance
                          .collection('transactions')
                          .doc();
                  await FirebaseFirestore.instance.runTransaction((tx) async {
                    final snapshot = await tx.get(itemRef);
                    final curr = snapshot['availableQuantity'] as int;
                    tx.update(itemRef, {'availableQuantity': curr - 1});
                    tx.set(txRef, {
                      'itemId': itemId,
                      'borrowerName': name,
                      'borrowDate': FieldValue.serverTimestamp(),
                      'returnDate': null,
                    });
                  });
                  Navigator.pop(context);
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
    );
  }

  void _returnItem(
    BuildContext context,
    String itemId,
    int available,
    int total,
  ) {
    if (available >= total) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nothing to return')));
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future:
              FirebaseFirestore.instance
                  .collection('transactions')
                  .where('itemId', isEqualTo: itemId)
                  .where('returnDate', isNull: true)
                  .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AlertDialog(
                content: SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }
            final docs = snapshot.data?.docs;
            if (docs == null || docs.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No active borrowers')),
                );
              });
              return const SizedBox.shrink();
            }
            return SimpleDialog(
              title: const Text('Select borrower to return'),
              children:
                  docs.map((doc) {
                    final data = doc.data();
                    return SimpleDialogOption(
                      child: Text(data['borrowerName'] ?? 'Unknown'),
                      onPressed: () async {
                        final txDocRef = doc.reference;
                        final itemRef = FirebaseFirestore.instance
                            .collection('items')
                            .doc(itemId);
                        await FirebaseFirestore.instance.runTransaction((
                          tx,
                        ) async {
                          final itemSnap = await tx.get(itemRef);
                          final curr = itemSnap['availableQuantity'] as int;
                          tx.update(itemRef, {'availableQuantity': curr + 1});
                          tx.update(txDocRef, {
                            'returnDate': FieldValue.serverTimestamp(),
                          });
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
            );
          },
        );
      },
    );
  }
}

/// Screen to add new items (Admin only).
class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _titleCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _qtyCtrl,
              decoration: const InputDecoration(labelText: 'Total Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final title = _titleCtrl.text.trim();
                final qty = int.tryParse(_qtyCtrl.text.trim()) ?? 0;
                if (title.isEmpty || qty <= 0) return;
                await FirebaseFirestore.instance.collection('items').add({
                  'title': title,
                  'totalQuantity': qty,
                  'availableQuantity': qty,
                });
                Navigator.pop(context);
              },
              child: const Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}
