import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TransferPage extends StatefulWidget {
  final int senderId;

  TransferPage({required this.senderId});

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool _isLoading = false;
  List<String> favoriteAccounts = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteAccounts = prefs.getStringList('favorite_accounts') ?? [];
    });
  }

  Future<void> _saveFavorite(String value) async {
    final prefs = await SharedPreferences.getInstance();
    if (!favoriteAccounts.contains(value)) {
      favoriteAccounts.add(value);
      await prefs.setStringList('favorite_accounts', favoriteAccounts);
      _showDialog("Account saved to favorites.");
    } else {
      _showDialog("Account is already in favorites.");
    }
  }

  Future<void> _transferMoney() async {
    final username = usernameController.text.trim();
    final number = numberController.text.trim();
    final amount = double.tryParse(amountController.text.trim());

    if ((username.isEmpty && number.isEmpty) || amount == null || amount <= 0) {
      _showDialog("Please enter a username or number, and a valid amount.");
      return;
    }

    final identifier = username.isNotEmpty ? username : number;

    setState(() => _isLoading = true);

    final url = Uri.parse("http://192.168.1.251/atm/transfer.php");

    try {
      final response = await http.post(url, body: {
        "sender_id": widget.senderId.toString(),
        "receiver_identifier": identifier,
        "amount": amount.toString(),
      });

      final jsonResponse = json.decode(response.body);
      _showDialog(jsonResponse['message']);
    } catch (e) {
      _showDialog("Something went wrong. Try again.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text("Transfer"),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Transfer Funds"),
        previousPageTitle: 'Back',
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Enter receiver details and amount",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),

              if (favoriteAccounts.isNotEmpty) ...[
                Text("Favorites:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: favoriteAccounts.length,
                    separatorBuilder: (_, __) => SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final account = favoriteAccounts[index];
                      return CupertinoButton(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        color: CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.circular(10),
                        child: Text(account, style: TextStyle(color: CupertinoColors.black)),
                        onPressed: () {
                          if (RegExp(r'^\d+$').hasMatch(account)) {
                            numberController.text = account;
                          } else {
                            usernameController.text = account;
                          }
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],

              Text("Receiver Username"),
              SizedBox(height: 6),
              CupertinoTextField(
                controller: usernameController,
                placeholder: 'e.g. johndoe',
                keyboardType: TextInputType.text,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(height: 20),

              Text("Receiver Phone Number"),
              SizedBox(height: 6),
              CupertinoTextField(
                controller: numberController,
                placeholder: 'e.g. 09123456789',
                keyboardType: TextInputType.phone,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(height: 20),

              Text("Amount"),
              SizedBox(height: 6),
              CupertinoTextField(
                controller: amountController,
                placeholder: '₱ Amount',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      child: Text("Save Account"),
                      onPressed: () {
                        final value = usernameController.text.trim().isNotEmpty
                            ? usernameController.text.trim()
                            : numberController.text.trim();
                        if (value.isNotEmpty) {
                          _saveFavorite(value);
                        } else {
                          _showDialog("Enter a username or number to save.");
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _isLoading
                        ? CupertinoActivityIndicator()
                        : CupertinoButton.filled(
                      child: Text("Send"),
                      onPressed: _transferMoney,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
