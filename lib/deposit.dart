import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DepositPage extends StatefulWidget {
  final int userId;

  DepositPage({required this.userId});

  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;

  Future<void> _depositMoney() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showDialog("Invalid amount");
      return;
    }

    setState(() => _isLoading = true);

    final url = Uri.parse('https://cashngo.space/atm/deposit.php');

    try {
      final response = await http.post(url, body: {
        'user_id': widget.userId.toString(),
        'amount': amount.toString(),
      });

      final jsonResponse = json.decode(response.body);
      _showDialog(jsonResponse['message']);
    } catch (e) {
      _showDialog("Something went wrong. Please try again.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text("Deposit"),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: Text("OK"),
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
        middle: Text('Deposit'),
        previousPageTitle: 'Back',
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'Enter Deposit Amount',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              CupertinoTextField(
                controller: _amountController,
                placeholder: '₱ 0.00',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              SizedBox(height: 30),
              _isLoading
                  ? CupertinoActivityIndicator()
                  : CupertinoButton.filled(
                child: Text("Deposit"),
                onPressed: _depositMoney,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
