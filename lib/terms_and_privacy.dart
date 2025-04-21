import 'package:flutter/cupertino.dart';

class TermsPrivacyPage extends StatelessWidget {
  final int userId;

  const TermsPrivacyPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Terms & Privacy'),
        previousPageTitle: 'Settings',
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'By using this app, you agree to the terms and conditions outlined below. '
                    'You must not misuse the services or attempt unauthorized access.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Your privacy is important to us. We only collect necessary information and '
                    'do not share your data with third parties without your consent. All data is encrypted.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),
              CupertinoButton.filled(
                child: Text('OK, Got it'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
