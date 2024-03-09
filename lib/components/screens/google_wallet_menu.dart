import 'package:add_to_google_wallet/widgets/add_to_google_wallet_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

class GoogleWalletMenu extends StatefulWidget {
  const GoogleWalletMenu({super.key});

  @override
  State<GoogleWalletMenu> createState() => _GoogleWalletMenuState();
}

class _GoogleWalletMenuState extends State<GoogleWalletMenu> {
  final String _platformVersion = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Wallet Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Running on: $_platformVersion'),

            //bUTTON
            AddToGoogleWalletButton(
              pass: _examplePass,
              onError: (Object error) => _onError(context, error),
              onSuccess: () => _onSuccess(context),
              onCanceled: () => _onCanceled(context),
              locale: const Locale.fromSubtags(
                languageCode: 'en',
                countryCode: 'US',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _onError(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Text(error.toString()),
    ),
  );
}

void _onSuccess(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      backgroundColor: Colors.green,
      content: Text('Pass has been sccessfully added to the Google Wallet.'),
    ),
  );
}

_onCanceled(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      backgroundColor: Colors.yellow,
      content: Text('Adding a pass has been canceled.'),
    ),
  );
}

final String _passId = const Uuid().v4();
const String _passClass = 'recycleadventurebossbadge';
const String _issuerId = '3388000000022319389';
const String _issuerEmail = 'gaeunyoo3626@gmail.com';

final String _examplePass = """ 
    {
      "iss": "$_issuerEmail",
      "aud": "google",
      "typ": "savetowallet",
      "origins": [],
      "payload": {
        "genericObjects": [
          {
            "id": "$_issuerId.$_passId",
            "classId": "$_issuerId.$_passClass",
            "genericType": "GENERIC_TYPE_UNSPECIFIED",
            "hexBackgroundColor": "#4285f4",
            "logo": {
              "sourceUri": {
                "uri": "https://storage.googleapis.com/wallet-lab-tools-codelab-artifacts-public/pass_google_logo.jpg"
              }
            },
            "cardTitle": {
              "defaultValue": {
                "language": "en",
                "value": "The World Saver"
              }
            },
            "subheader": {
              "defaultValue": {
                "language": "en",
                "value": "Player"
              }
            },
            "header": {
              "defaultValue": {
                "language": "en",
                "value": "Sarah Yoo"
              }
            },
            "barcode": {
              "type": "QR_CODE",
              "value": "$_passId"
            },
            "heroImage": {
              "sourceUri": {
                "uri": "https://cdn-icons-png.flaticon.com/512/771/771222.png"
              }
            },
            "textModulesData": [
              {
                "header": "Cleared",
                "body": "5",
                "id": "cleared"
              }
            ]
          }
        ]
      }
    }
""";
