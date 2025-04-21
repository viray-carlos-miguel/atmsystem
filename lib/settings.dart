import 'package:atmapp/support.dart';
import 'package:atmapp/terms_and_privacy.dart';
import 'package:flutter/cupertino.dart';
import 'account.dart';
import 'login.dart'; // Make sure this import is correct for your LoginPage

class SettingsPage extends StatelessWidget {
  final int userId;

  SettingsPage({required this.userId});

  void _confirmLogout(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          CupertinoDialogAction(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text("Logout"),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _logout(context);       // Perform logout
            },
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (_) => LoginPage()), // Ensure LoginPage exists
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Settings'),
        previousPageTitle: 'Home',
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: [
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  title: Text('Account'),
                  leading: Icon(CupertinoIcons.person),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => AccountPage(userId: userId)),
                    );
                  },
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  title: Text('Support'),
                  leading: Icon(CupertinoIcons.question_circle),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => SupportPage(userId: userId),
                      ),
                    );
                  },
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  title: Text('Terms & Privacy'),
                  leading: Icon(CupertinoIcons.doc_text),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => TermsPrivacyPage(userId: userId),
                      ),
                    );
                  },
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  title: Text('Log Out', style: TextStyle(color: CupertinoColors.systemRed)),
                  leading: Icon(CupertinoIcons.square_arrow_right, color: CupertinoColors.systemRed),
                  onTap: () {
                    _confirmLogout(context); // Show confirmation dialog
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
