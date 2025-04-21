import 'package:flutter/cupertino.dart';
import 'login.dart';
import 'signup.dart';
void main() => runApp(CashNGoApp());

class CashNGoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Cash n Go',
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Image.asset(
                    'assets/cash_n_go.png',
                    height: 100,
                  ),
                ),

                // Welcome Text
                Text(
                  'Welcome to Cash n Go',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.activeBlue,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12),

                // Subtext
                Text(
                  'Fast. Easy. Reliable banking.',
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.systemGrey,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 40),

                // Login Button
                CupertinoButton.filled(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text('Log In'),
                  onPressed: () {
                    // TODO: Navigate to login screen
                    Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => LoginPage()),
                    );
                  },
                ),

                SizedBox(height: 16),

                // Open Account Button

              ],
            ),
          ),
        ),
      ),
    );
  }
}
