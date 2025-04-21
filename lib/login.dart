import 'package:atmapp/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'homepage.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showAlert(context, "Please fill in both fields.");
      return;
    }

    final url = Uri.parse('https://cashngo.space/atm/login.php');

    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );

      final jsonResponse = json.decode(response.body);

      if (jsonResponse['success']) {
        final int userId = jsonResponse['user']['id']; // <-- get user ID
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (_) => HomePage(userId: userId)),
        );
      } else {
        _showAlert(context, jsonResponse['message'] ?? "Invalid credentials.");
      }
    } catch (e) {
      _showAlert(context, "Connection error. Please try again.");
    }
  }

  void _showAlert(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Login'),
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
        middle: Text('Log In'),
        previousPageTitle: 'Back',
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
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
                    'Login to your account',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),

                  Text(
                    'Email or Username',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.systemGrey2,
                    ),
                  ),
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

                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.systemGrey2,
                    ),
                  ),
                  SizedBox(height: 6),
                  CupertinoTextField(
                    controller: passwordController,
                    placeholder: 'Enter your password',
                    obscureText: true,
                    padding: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                      onPressed: () {
                        // TODO: Add forgot password logic
                      },
                    ),
                  ),
                  SizedBox(height: 24),

                  CupertinoButton.filled(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    borderRadius: BorderRadius.circular(12),
                    child: Text(
                      'Log In',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () => _login(context),
                  ),
                  CupertinoButton(
                    child: Text('Create an Account here'),
                    onPressed: () {
                      // TODO: Navigate to account creation
                      Navigator.of(context).push(
                        CupertinoPageRoute(builder: (_) => SignupPage()),
                      );
                    },
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
