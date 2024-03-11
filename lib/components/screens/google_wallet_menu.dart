import 'package:add_to_google_wallet/widgets/add_to_google_wallet_button.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:recycle_adventure/components/screens/main_menu.dart';
import 'package:recycle_adventure/main.dart';
import 'package:uuid/uuid.dart';

//This is a game ending where you can add the clear badge to the google wallet.
class GoogleWalletMenu extends StatefulWidget {
  const GoogleWalletMenu({super.key});

  @override
  State<GoogleWalletMenu> createState() => _GoogleWalletMenuState();
}

class _GoogleWalletMenuState extends State<GoogleWalletMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Menu/ending.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game Cleard: You saved the world!',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Click button to get a badge.',
                style: TextStyle(color: Colors.white),
              ),

              const SizedBox(height: 50),

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

              const SizedBox(height: 10),

              const Text(
                'or',
                style: TextStyle(color: Colors.white),
              ),

              const SizedBox(height: 10),

              //Exit Button
              SizedBox(
                width: MediaQuery.of(context).size.width / 5,
                child: ElevatedButton(
                  onPressed: () {
                    gameRef.reset(); //TODO:

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MainMenu(),
                      ),
                    );
                    if (gameRef.isMusicOn) {
                      FlameAudio.bgm.play('main-menu-music.mp3',
                          volume: gameRef.musicVolume);
                    }
                  },
                  child: const Text('Exit'),
                ),
              ),
            ],
          ),
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
const String _issuerName = '(Player Name)';

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
            "hexBackgroundColor": "#97D60E",
            "logo": {
              "sourceUri": {
                "uri": "https://i.postimg.cc/zD0nVMTx/f5796f52-30c6-4eed-865e-0f58c6e11e56.png"
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
                "value": "$_issuerName"
              }
            },
            "barcode": {
              "type": "QR_CODE",
              "value": "$_passId"
            },
            "heroImage": {
              "sourceUri": {
                "uri": "https://i.postimg.cc/zD0nVMTx/f5796f52-30c6-4eed-865e-0f58c6e11e56.png"
              }
            },
            "textModulesData": [
              {
                "header": "Cleared",
                "body": "${gameRef.numberCleared}",
                "id": "cleared"
              }
            ]
          }
        ]
      }
    }
""";
