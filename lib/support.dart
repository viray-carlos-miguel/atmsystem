import 'package:flutter/cupertino.dart';

class SupportPage extends StatelessWidget {
  final int userId;

  const SupportPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Support'),
        previousPageTitle: 'Settings',
      ),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Text(
              'Need Help?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'If you have any questions or issues, feel free to reach out to our support team.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            CupertinoButton.filled(
              child: Text('Contact Support'),
              onPressed: () {
                _showContactDialog(context);
              },
            ),
            SizedBox(height: 20),
            Text(
              'FAQs and live chat coming soon!',
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text('Contact Support'),
        content: Column(
          children: [
            SizedBox(height: 10),
            Text('Email us at support@atmapp.com\nor call +1234567890'),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
