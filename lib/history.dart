import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  final int userId;
  const HistoryPage({required this.userId});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final url = Uri.parse("http://192.168.1.251/atm/history.php");

    try {
      final response = await http.post(
        url,
        body: {
          'user_id': widget.userId.toString(),
        },
      );

      final data = json.decode(response.body);

      if (data['success']) {
        setState(() {
          transactions = data['transactions'];
          isLoading = false;
        });
      } else {
        _showError(data['message']);
        setState(() => isLoading = false);
      }
    } catch (e) {
      _showError("Failed to load history.");
      setState(() => isLoading = false);
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
        middle: Text("Transaction History"),
      ),
      child: SafeArea(
        child: isLoading
            ? Center(child: CupertinoActivityIndicator())
            : transactions.isEmpty
            ? Center(child: Text("No transactions found."))
            : ListView.separated(
          padding: EdgeInsets.all(20),
          itemCount: transactions.length,
          separatorBuilder: (_, __) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final txn = transactions[index];
            final type = txn['type'];
            final amount = txn['amount'].toString();
            final date = txn['date'].toString();
            final details = txn['details'] ?? '';

            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        date,
                        style: TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 13,
                        ),
                      ),
                      if (details.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(
                          details,
                          style: TextStyle(
                            color: CupertinoColors.systemGrey2,
                            fontSize: 12,
                          ),
                        ),
                      ]
                    ],
                  ),
                  Text(
                    type == 'pay bills' ? '-$amount' : '+$amount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: type == 'pay bills'
                          ? CupertinoColors.systemRed
                          : CupertinoColors.activeGreen,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
