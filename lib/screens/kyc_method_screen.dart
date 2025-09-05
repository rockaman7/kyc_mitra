import 'package:flutter/material.dart';
import 'package:kyc_mitra/widgets/llm_helper.dart';
import 'package:kyc_mitra/widgets/show_help_dialog.dart';
import '../widgets/primary_button.dart';
import '../utils/tts_helper.dart';
import 'document_upload_screen.dart';
import 'digilocker_screen.dart'; // placeholder for Digilocker flow

class KYCMethodScreen extends StatefulWidget {
  const KYCMethodScreen({super.key});

  @override
  State<KYCMethodScreen> createState() => _KYCMethodScreenState();
}

class _KYCMethodScreenState extends State<KYCMethodScreen> {
  @override
  void initState() {
    super.initState();
    TTSHelper.speak(
      "Choose your preferred KYC method: Digilocker or manual document upload.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select KYC Method")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "🔹 Choose KYC Method",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Need Help button aligned to center with smaller width
            SizedBox(
              width: 160,
              child: PrimaryButton(
                label: "Need Help?",
                onPressed: () {
                  final response = LLMHelper.getResponse("digilocker");
                  showHelpDialog(context, response);
                },
              ),
            ),

            const SizedBox(height: 40),

            // Use Digilocker button
            PrimaryButton(
              label: "Use Digilocker",
              onPressed: () {
                TTSHelper.speak("You selected Digilocker. Redirecting...");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DigilockerScreen()),
                );
              },
            ),
            const SizedBox(height: 20),

            // Upload Documents manually
            PrimaryButton(
              label: "Upload Documents Manually",
              onPressed: () {
                TTSHelper.speak("You selected manual upload.");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DocumentUploadScreen(),
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
