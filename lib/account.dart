import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountPage extends StatefulWidget {
  final int userId;

  AccountPage({required this.userId});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String name = '';
  String email = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final url = Uri.parse('https://cashngo.space/atm/get_user.php?id=${widget.userId}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success']) {
          final user = data['user'];
          setState(() {
            name = user['name'] ?? 'Unknown';
            email = user['email'] ?? 'Not set';
            _loading = false;
          });
        } else {
          _showError(data['message']);
        }
      } else {
        _showError("Server returned error: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Connection error: ${e.toString()}");
    }
  }

  void _showError(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Account Info'),
        previousPageTitle: 'Settings',
      ),
      child: SafeArea(
        child: _loading
            ? Center(child: CupertinoActivityIndicator())
            : ListView(
          padding: const EdgeInsets.all(20),
          children: [
            CupertinoFormSection.insetGrouped(
              header: Text('Profile'),
              children: [
                CupertinoFormRow(
                  prefix: Text('Name'),
                  child: Text(name, style: TextStyle(color: CupertinoColors.black)),
                ),
                CupertinoFormRow(
                  prefix: Text('Email'),
                  child: Text(email, style: TextStyle(color: CupertinoColors.black)),
                ),
              ],
            ),
            SizedBox(height: 30),
            CupertinoButton.filled(
              child: Text("Edit Profile (Coming Soon)"),
              onPressed: () {
                // Future feature
              },
            ),
          ],
        ),
      ),
    );
  }
}
