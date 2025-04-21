import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'settings.dart'; // ✅ Make sure this import is correct

import 'deposit.dart';
import 'paybills.dart';
import 'transfer.dart';
import 'history.dart';

class HomePage extends StatefulWidget {
  final int userId;

  HomePage({required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isBalanceVisible = true;
  double? _balance;
  bool _isLoadingBalance = true;
  Timer? _timer;

  List<Map<String, dynamic>> _recentTransactions = [];

  @override
  void initState() {
    super.initState();
    _fetchBalance();
    _fetchRecentTransactions();

    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      _fetchBalance();
      _fetchRecentTransactions();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchBalance() async {
    final url = Uri.parse("http://192.168.1.251/atm/get_balance.php?user_id=${widget.userId}");

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['success']) {
        setState(() {
          _balance = double.tryParse(data['balance'].toString());
          _isLoadingBalance = false;
        });
      } else {
        setState(() => _isLoadingBalance = false);
        _showError(data['message']);
      }
    } catch (e) {
      setState(() => _isLoadingBalance = false);
      _showError("Failed to load balance");
    }
  }

  Future<void> _fetchRecentTransactions() async {
    final url = Uri.parse("http://192.168.1.251/atm/get_recent_transactions.php?user_id=${widget.userId}");

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['success']) {
        setState(() {
          _recentTransactions = List<Map<String, dynamic>>.from(data['transactions']);
        });
      }
    } catch (e) {
      // Optional: handle error
    }
  }

  void _showError(String message) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text("Error"),
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
        middle: Text('Cash n Go'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.gear, size: 26),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (_) => SettingsPage(userId: widget.userId)),
            );
          },
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hello, User 👋',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.black,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Available Balance', style: TextStyle(color: CupertinoColors.white, fontSize: 16)),
                          SizedBox(height: 6),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _isLoadingBalance
                                  ? 'Loading...'
                                  : (_isBalanceVisible
                                  ? '₱ ${_balance?.toStringAsFixed(2) ?? "0.00"}'
                                  : '••••••••'),
                              style: TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 16,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(
                            _isBalanceVisible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                            color: CupertinoColors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            setState(() => _isBalanceVisible = !_isBalanceVisible);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    icon: CupertinoIcons.money_dollar,
                    label: 'Pay Bills',
                    onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => PayBillsPage(userId: widget.userId)),
                    ),
                  ),
                  _buildActionButton(
                    icon: CupertinoIcons.arrow_down_circle,
                    label: 'Deposit',
                    onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => DepositPage(userId: widget.userId)),
                    ),
                  ),
                  _buildActionButton(
                    icon: CupertinoIcons.arrow_right_arrow_left,
                    label: 'Transfer',
                    onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => TransferPage(senderId: widget.userId)),
                    ),
                  ),
                  _buildActionButton(
                    icon: CupertinoIcons.clock,
                    label: 'History',
                    onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => HistoryPage(userId: widget.userId)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              ..._recentTransactions.map((tx) {
                final isNegative = ['withdraw', 'bill_payment', 'transfer'].contains(tx['type']);
                final amountStr = (isNegative ? "-₱ " : "+₱ ") +
                    double.parse(tx['amount'].toString()).toStringAsFixed(2);
                return _buildTransactionItem(
                  title: _formatTransactionTitle(tx['type']),
                  date: tx['date'],
                  amount: amountStr,
                );
              }).toList(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return Column(
      children: [
        CupertinoButton(
          padding: EdgeInsets.all(14),
          color: CupertinoColors.systemGrey5,
          borderRadius: BorderRadius.circular(30),
          child: Icon(icon, size: 28),
          onPressed: onTap,
        ),
        SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildTransactionItem({required String title, required String date, required String amount}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(height: 4),
            Text(date, style: TextStyle(fontSize: 13, color: CupertinoColors.systemGrey)),
          ]),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: amount.startsWith('-') ? CupertinoColors.systemRed : CupertinoColors.activeGreen,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTransactionTitle(String type) {
    switch (type) {
      case 'deposit':
        return 'Deposit';
      case 'bill_payment':
        return 'Bill Payment';
      case 'transfer':
        return 'Transfer';
      default:
        return 'Transaction';
    }
  }
}
