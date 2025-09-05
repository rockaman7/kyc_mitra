import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../utils/tts_helper.dart';
import 'kyc_method_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? _selectedLang;

  @override
  void initState() {
    super.initState();
    // Voice guidance when screen opens
    TTSHelper.speak(
      "Welcome to KYC for Bharat. Please select your language and continue.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "👋 Welcome",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Choose your preferred language",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Language Dropdown with icon
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text("Select Language"),
                value: _selectedLang,
                items: ["English", "हिन्दी", "தமிழ்", "తెలుగు"]
                    .map(
                      (lang) => DropdownMenuItem(
                        value: lang,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.language,
                              size: 20,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Text(lang),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  setState(() => _selectedLang = val);
                  TTSHelper.speak("You selected $_selectedLang");
                },
                underline: const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Do you agree to share your documents for KYC?",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Continue button disabled until language selected
            PrimaryButton(
              label: "I Agree & Continue",
              onPressed: _selectedLang == null
                  ? null
                  : () {
                      TTSHelper.speak(
                        "Thank you. Let’s start your KYC process.",
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KYCMethodScreen(),
                        ),
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}
