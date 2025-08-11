// lib/screens/sign_up_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _nameController= TextEditingController();
  final String name="";
  final String _role = 'user';
  List<String> _teams = ['Team Alpha', 'Team Beta', 'Team Gamma'];
List<String> _branches = ['Dadar','Bandra'];

String _selectedTeam = 'Team Alpha';
String _selectedBranch = 'Dadar';

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _showErrorDialog(String message) async {
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Signup Request Sent'),
            content: const Text(
              'Your signup request has been sent and is pending admin approval. You will be notified once approved.',
            ),
            actions: [
              TextButton(
                onPressed:
                    () => Navigator.of(
                      context,
                    ).popUntil((route) => route.isFirst),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
Future<void> _signUp() async {
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();
  final confirmPassword = _confirmController.text.trim();
  final name=  _nameController.text.trim();
    // ✅ Email check
  if (!email.endsWith('@theinnovationstory.com')) {
    await _showErrorDialog('Email must end with @theinnovationstory.com');
    return;
  }

  // ✅ Password match check
  if (password != confirmPassword) {
    await _showErrorDialog('Passwords do not match');
    return;
  }

  // ✅ Dropdown selection check
  if (_selectedTeam == null || _selectedBranch == null) {
    await _showErrorDialog('Please select both team and branch');
    return;
  }

  setState(() => _isLoading = true);

  try {
    // Store user request in Firestore with 'pending' status
    await FirebaseFirestore.instance
        .collection('pending_users')
        .doc(email)
        .set({
          'email': email,
          'password': password, // ❗ Consider hashing or removing before production
          'role': _role,
          'team': _selectedTeam,
          'branch': _selectedBranch,
          'status': 'pending',
          'name': name,
          'createdAt': FieldValue.serverTimestamp(),
        });

    await _showSuccessDialog();
  } catch (e) {
    print("Signup Error: $e");
    await _showErrorDialog('Something went wrong. Please try again.');
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}
  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF4F6FD);
    const Color primaryColor = Color.fromARGB(255, 0, 183, 255);
    const Color iconColor = Color(0xFF3949AB);
    const Color textColor = Color(0xFF212121);
    const Color accentColor = Color(0xFF00ACC1);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Create Account'),
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: accentColor,
                      child: const Icon(
                        Icons.person_add_outlined,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Join Us',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Create a new account',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                         TextField(
                          controller: _nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: const TextStyle(color: iconColor),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: iconColor,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF0F0F0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: accentColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(color: iconColor),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: iconColor,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF0F0F0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: accentColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: iconColor),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: iconColor,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: iconColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF0F0F0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: accentColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _confirmController,
                          obscureText: _obscureConfirm,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: const TextStyle(color: iconColor),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: iconColor,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: iconColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirm = !_obscureConfirm;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF0F0F0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: accentColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Inside your Column in the Card (after confirm password field)
const SizedBox(height: 16),
DropdownButtonFormField<String>(
  value: _selectedTeam,
  decoration: InputDecoration(
    labelText: 'Select Team',
    labelStyle: const TextStyle(color: iconColor),
    prefixIcon: const Icon(Icons.group_outlined, color: iconColor),
    filled: true,
    fillColor: const Color(0xFFF0F0F0),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: accentColor, width: 2),
    ),
  ),
  items: _teams.map((team) {
    return DropdownMenuItem<String>(
      value: team,
      child: Text(team),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      _selectedTeam = value!;
    });
  },
),

const SizedBox(height: 16),
DropdownButtonFormField<String>(
  value: _selectedBranch,
  decoration: InputDecoration(
    labelText: 'Select Branch',
    labelStyle: const TextStyle(color: iconColor),
    prefixIcon: const Icon(Icons.location_city_outlined, color: iconColor),
    filled: true,
    fillColor: const Color(0xFFF0F0F0),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: accentColor, width: 2),
    ),
  ),
  items: _branches.map((branch) {
    return DropdownMenuItem<String>(
      value: branch,
      child: Text(branch),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      _selectedBranch = value!;
    });
  },
),

                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      onPressed: _signUp,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// // lib/screens/sign_up_page.dart

// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';

// import 'otp_verification_page.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({Key? key}) : super(key: key);

//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmController = TextEditingController();
//   final String _role = 'user';

//   bool _obscurePassword = true;
//   bool _obscureConfirm = true;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmController.dispose();
//     super.dispose();
//   }

//   String generateOTP() {
//     var rng = Random();
//     return (100000 + rng.nextInt(900000)).toString();
//   }

//   Future<void> sendEmailOTP(String email, String otp) async {
//     String username = "tisinventory692@gmail.com"; // Use your real email
//     String password =
//         "gpqgrrrerfzwgqsd"; // App password (not your Gmail password)

//     final smtpServer = gmail(username, password);

//     final message =
//         Message()
//           ..from = Address(username, 'The Innovation Story Inventory')
//           ..recipients.add(email)
//           ..subject = "Your OTP for Signup"
//           ..text = "Your OTP code is: $otp";

//     try {
//       print("🔄 Attempting to send OTP to $email...");
//       final sendReport = await send(message, smtpServer);
//       print("✅ OTP email sent successfully!");
//       print("SendReport: ${sendReport.toString()}");
//     } catch (e) {
//       print("❌ Email sending failed: $e");
//     }
//   }

//   Future<void> _showErrorDialog() async {
//     await showDialog(
//       context: context,
//       builder:
//           (_) => AlertDialog(
//             title: const Text('Error'),
//             content: const Text('Invalid ID and password'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//     );
//   }

//   Future<void> _signUp() async {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();
//     final confirmPassword = _confirmController.text.trim();

//     if (!email.endsWith('@theinnovationstory.com')) {
//       await _showDomainErrorDialog();
//       return;
//     }

//     if (password != confirmPassword) {
//       await _showErrorDialog();
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       String otp = generateOTP();

//       // Store OTP temporarily in Firestore
//       await FirebaseFirestore.instance
//           .collection('otp_verifications')
//           .doc(email)
//           .set({'otp': otp, 'createdAt': FieldValue.serverTimestamp()});

//       await sendEmailOTP(email, otp);

//       // Navigate to OTP verification screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder:
//               (context) => OTPVerificationPage(
//                 email: email,
//                 password: password,
//                 role: _role,
//               ),
//         ),
//       );
//     } catch (e) {
//       print("Signup Error: $e");
//       await _showErrorDialog();
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _showDomainErrorDialog() async {
//     await showDialog(
//       context: context,
//       builder:
//           (_) => AlertDialog(
//             title: const Text('Invalid Email'),
//             content: const Text('Email must end with @theinnovationstory.com'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Professional color palette (matching SignInPage)
//     const Color backgroundColor = Color(0xFFF4F6FD); // Light grey
//     const Color primaryColor = Color.fromARGB(
//       255,
//       0,
//       183,
//       255,
//     ); // Updated primary
//     const Color iconColor = Color(0xFF3949AB); // Indigo 600
//     const Color textColor = Color(0xFF212121); // Dark grey
//     const Color accentColor = Color(0xFF00ACC1); // Teal

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: const Text('Create Account'),
//         centerTitle: true,
//         elevation: 4,
//       ),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Header
//                 Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 36,
//                       backgroundColor: accentColor,
//                       child: const Icon(
//                         Icons.person_add_outlined,
//                         color: Colors.white,
//                         size: 36,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Join Us',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: textColor,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     const Text(
//                       'Create a new account',
//                       style: TextStyle(fontSize: 16, color: textColor),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 32),

//                 // Form Container
//                 Card(
//                   color: Colors.white,
//                   elevation: 2,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 24,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         // Email Field
//                         TextField(
//                           controller: _emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           decoration: InputDecoration(
//                             labelText: 'Email',
//                             labelStyle: const TextStyle(color: iconColor),
//                             prefixIcon: const Icon(
//                               Icons.email_outlined,
//                               color: iconColor,
//                             ),
//                             filled: true,
//                             fillColor: const Color(0xFFF0F0F0),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide(
//                                 color: Colors.grey.shade300,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide(
//                                 color: accentColor,
//                                 width: 2,
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 16),

//                         // Password Field with toggle
//                         TextField(
//                           controller: _passwordController,
//                           obscureText: _obscurePassword,
//                           decoration: InputDecoration(
//                             labelText: 'Password',
//                             labelStyle: const TextStyle(color: iconColor),
//                             prefixIcon: const Icon(
//                               Icons.lock_outline,
//                               color: iconColor,
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscurePassword
//                                     ? Icons.visibility_off_outlined
//                                     : Icons.visibility_outlined,
//                                 color: iconColor,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscurePassword = !_obscurePassword;
//                                 });
//                               },
//                             ),
//                             filled: true,
//                             fillColor: const Color(0xFFF0F0F0),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide(
//                                 color: Colors.grey.shade300,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide(
//                                 color: accentColor,
//                                 width: 2,
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 16),

//                         // Confirm Password Field with toggle
//                         TextField(
//                           controller: _confirmController,
//                           obscureText: _obscureConfirm,
//                           decoration: InputDecoration(
//                             labelText: 'Confirm Password',
//                             labelStyle: const TextStyle(color: iconColor),
//                             prefixIcon: const Icon(
//                               Icons.lock_outline,
//                               color: iconColor,
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscureConfirm
//                                     ? Icons.visibility_off_outlined
//                                     : Icons.visibility_outlined,
//                                 color: iconColor,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscureConfirm = !_obscureConfirm;
//                                 });
//                               },
//                             ),
//                             filled: true,
//                             fillColor: const Color(0xFFF0F0F0),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide(
//                                 color: Colors.grey.shade300,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide(
//                                 color: accentColor,
//                                 width: 2,
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 24),

//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 // Sign Up Button / Loading Indicator
//                 _isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: accentColor,
//                         foregroundColor: Colors.white,
//                         minimumSize: const Size.fromHeight(50),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         elevation: 2,
//                       ),
//                       onPressed: _signUp,
//                       child: const Text(
//                         'Sign Up',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),

//                 const SizedBox(height: 16),

//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
