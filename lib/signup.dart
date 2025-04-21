import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController numberController = TextEditingController(); // 👈 added

  Future<void> _signup(BuildContext context) async {
    final String username = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String number = numberController.text.trim(); // 👈 added

    if (username.isEmpty || email.isEmpty || password.isEmpty || number.isEmpty) {
      _showAlert(context, "All fields are required.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.251/atm/signup.php'), // Update if needed
        body: {
          'username': username,
          'email': email,
          'password': password,
          'number': number, // 👈 added
        },
      );

      final data = json.decode(response.body);

      if (data['success']) {
        _showAlert(context, "Signup successful!");
        // Optionally navigate to login or home
      } else {
        _showAlert(context, data['message'] ?? "Signup failed. Try again.");
      }
    } catch (e) {
      _showAlert(context, "Error: ${e.toString()}");
    }
  }

  void _showAlert(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text('Signup'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Sign Up'),
        previousPageTitle: 'Back',
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/cash_n_go.png',
                      height: 80,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Create a new account',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),

                  // Name field
                  Text('Full Name',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CupertinoColors.systemGrey2)),
                  SizedBox(height: 6),
                  CupertinoTextField(
                    controller: nameController,
                    placeholder: 'Your full name',
                    padding: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(height: 18),

                  // Email field
                  Text('Email Address',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CupertinoColors.systemGrey2)),
                  SizedBox(height: 6),
                  CupertinoTextField(
                    controller: emailController,
                    placeholder: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                    padding: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(height: 18),

                  // Phone Number field 👇
                  Text('Phone Number',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CupertinoColors.systemGrey2)),
                  SizedBox(height: 6),
                  CupertinoTextField(
                    controller: numberController,
                    placeholder: 'e.g. 09123456789',
                    keyboardType: TextInputType.phone,
                    padding: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(height: 18),

                  // Password field
                  Text('Password',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CupertinoColors.systemGrey2)),
                  SizedBox(height: 6),
                  CupertinoTextField(
                    controller: passwordController,
                    placeholder: 'Create a password',
                    obscureText: true,
                    padding: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Signup Button
                  CupertinoButton.filled(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    borderRadius: BorderRadius.circular(12),
                    child: Text('Sign Up', style: TextStyle(fontSize: 18)),
                    onPressed: () => _signup(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
