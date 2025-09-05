import 'package:flutter/material.dart';
import 'package:kyc_mitra/widgets/llm_helper.dart';
import '../widgets/primary_button.dart';
import '../utils/tts_helper.dart';
import 'kyc_status_screen.dart';

class DigilockerScreen extends StatefulWidget {
  const DigilockerScreen({super.key});

  @override
  State<DigilockerScreen> createState() => _DigilockerScreenState();
}

class _DigilockerScreenState extends State<DigilockerScreen> {
  bool _loading = false;

  void _fetchDocuments() async {
    setState(() => _loading = true);

    // Simulate Digilocker fetch
    await Future.delayed(const Duration(seconds: 3));

    setState(() => _loading = false);

    // Navigate to KYCStatusScreen (success for now)
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const KYCStatusScreen(isSuccess: true)),
    );
  }

  @override
  void initState() {
    super.initState();
    TTSHelper.speak(
      "Digilocker integration placeholder. Press fetch to get documents.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Digilocker KYC")),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud, size: 100, color: Colors.blueAccent),
                  const SizedBox(height: 20),
                  const Text(
                    "🔹 Digilocker KYC Integration Placeholder",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: 160,
                    child: PrimaryButton(
                      label: "Need Help?",
                      onPressed: () {
                        final response = LLMHelper.getResponse("digilocker");
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Help"),
                            content: Text(response),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Close"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),
                  PrimaryButton(
                    label: "Fetch Documents",
                    onPressed: _fetchDocuments,
                  ),
                ],
              ),
      ),
    );
  }
}
