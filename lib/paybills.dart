import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PayBillsPage extends StatefulWidget {
  final int userId;

  PayBillsPage({required this.userId});

  @override
  _PayBillsPageState createState() => _PayBillsPageState();
}

class _PayBillsPageState extends State<PayBillsPage> {
  final List<String> billers = [
    "Meralco",
    "Maynilad",
    "Manila Water",
    "PLDT",
    "Globe Telecom",
    "Smart Communications",
    "SkyCable",
    "Cignal TV",
    "Sun Cellular",
    "Pag-IBIG Fund",
    "SSS",
    "PhilHealth",
    "VECO",
    "Netflix PH",
    "Spotify PH",
    "Amazon Prime Video",
    "Converge ICT",
    "BIR",
    "Home Credit",
  ];

  String selectedBiller = "Meralco";
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool _isLoading = false;

  Future<void> _payBill() async {
    final reference = referenceController.text.trim();
    final amount = double.tryParse(amountController.text.trim());

    if (reference.isEmpty || amount == null || amount <= 0) {
      _showDialog("Please enter a valid reference number and amount.");
      return;
    }

    setState(() => _isLoading = true);

    final url = Uri.parse("https://cashngo.space/atm/pay_bills.php");

    try {
      final response = await http.post(url, body: {
        "user_id": widget.userId.toString(),
        "biller": selectedBiller,
        "reference": reference,
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
        title: Text("Pay Bills"),
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
        middle: Text("Pay Bills"),
        previousPageTitle: 'Back',
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Choose a biller",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),

              // Biller Picker
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedBiller,
                          style: TextStyle(fontSize: 16)),
                      Icon(CupertinoIcons.chevron_down, size: 18),
                    ],
                  ),
                ),
                onPressed: () => _showBillerPicker(),
              ),

              SizedBox(height: 20),
              Text("Reference / Account Number",
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              CupertinoTextField(
                controller: referenceController,
                placeholder: 'Enter Reference No.',
                keyboardType: TextInputType.text,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              SizedBox(height: 20),
              Text("Amount",
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
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

              SizedBox(height: 30),
              _isLoading
                  ? Center(child: CupertinoActivityIndicator())
                  : SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  child: Text("Pay Now"),
                  onPressed: _payBill,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBillerPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              color: CupertinoColors.systemGrey5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text("Done"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: billers.indexOf(selectedBiller),
                ),
                itemExtent: 32,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedBiller = billers[index];
                  });
                },
                children: billers.map((biller) => Text(biller)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
