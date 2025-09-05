import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../utils/tts_helper.dart';

class KYCStatusScreen extends StatefulWidget {
  final bool isSuccess;

  const KYCStatusScreen({super.key, required this.isSuccess});

  @override
  State<KYCStatusScreen> createState() => _KYCStatusScreenState();
}

class _KYCStatusScreenState extends State<KYCStatusScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isSuccess) {
      TTSHelper.speak("Your KYC documents have been submitted successfully.");
    } else {
      TTSHelper.speak(
        "There was a problem submitting your KYC. It will be retried automatically when internet is available.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (canPop, result) {
        if (!widget.isSuccess) {
          Navigator.pop(context); // allow back only on failure
        }
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Status Icon with soft shadow
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isSuccess
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    boxShadow: [
                      BoxShadow(
                        color: widget.isSuccess
                            ? Colors.green.shade200
                            : Colors.orange.shade200,
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Icon(
                    widget.isSuccess ? Icons.check_circle : Icons.cloud_off,
                    color: widget.isSuccess ? Colors.green : Colors.orange,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 20),

                // Status Title
                Text(
                  widget.isSuccess
                      ? "✅ KYC Submitted Successfully"
                      : "⚠️ KYC Submission Pending",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),

                // Status description
                Column(
                  children: [
                    Text(
                      widget.isSuccess
                          ? "We will verify your documents and update you shortly."
                          : "Your submission will be retried automatically once internet is back.",
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    if (!widget.isSuccess)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.cloud_upload,
                              color: Colors.orange,
                              size: 18,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Retrying when online...",
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 40),

                // Finish / Back button
                PrimaryButton(
                  label: widget.isSuccess ? "Finish" : "Back",
                  onPressed: () {
                    if (widget.isSuccess) {
                      TTSHelper.speak("Thank you. KYC process completed.");
                      Navigator.popUntil(context, (route) => route.isFirst);
                    } else {
                      TTSHelper.speak("Returning to previous screen.");
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
