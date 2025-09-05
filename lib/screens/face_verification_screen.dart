import 'package:flutter/material.dart';
import 'package:kyc_mitra/widgets/llm_helper.dart';
import 'package:kyc_mitra/widgets/show_help_dialog.dart';
import '../widgets/primary_button.dart';
import '../utils/tts_helper.dart';
import 'kyc_status_screen.dart';

class FaceVerificationScreen extends StatefulWidget {
  const FaceVerificationScreen({super.key});

  @override
  State<FaceVerificationScreen> createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen> {
  bool _loading = false;
  final bool _isPending = false; // optional offline/pending

  void _verifyFace() async {
    setState(() => _loading = true);

    // Simulate liveness + face match processing
    await Future.delayed(const Duration(seconds: 3));

    setState(() => _loading = false);

    if (!mounted) return;

    // Navigate to KYC Status Screen (success for now)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const KYCStatusScreen(isSuccess: true),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    TTSHelper.speak(
      "Please align your face inside the frame and blink to verify liveness.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Face Verification")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: _loading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      "Verifying your face...",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    LinearProgressIndicator(),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Face frame with dotted circle
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blueAccent, width: 3),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blueAccent, style: BorderStyle.solid, width: 1.5),
                          ),
                        ),
                        const Icon(Icons.face, size: 60, color: Colors.blueAccent),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Align your face inside the frame and press Verify",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // Verify button
                    PrimaryButton(label: "Verify Face", onPressed: _verifyFace),
                    const SizedBox(height: 20),

                    // Pending indicator (optional)
                    if (_isPending)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.cloud_off, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            "Pending verification due to connectivity.",
                            style: TextStyle(color: Colors.orange),
                          ),
                        ],
                      ),

                    const SizedBox(height: 20),
                    // Need Help button
                    SizedBox(
                      width: 160,
                      child: PrimaryButton(
                        label: "Need Help?",
                        onPressed: () {
                          final response = LLMHelper.getResponse("face");
                          TTSHelper.speak(response); // add voice
                          showHelpDialog(context, response);
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
