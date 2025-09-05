import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../utils/tts_helper.dart';
import '../services/kyc_service.dart';
import '../widgets/llm_helper.dart';
import '../widgets/show_help_dialog.dart';
import 'face_verification_screen.dart';
import '../utils/offline_retry_helper.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  bool _loading = false;
  double _progress = 0;
  String? _selectedFile;
  bool _isPending = false;

  @override
  void initState() {
    super.initState();
    _checkPendingRequests();
  }

  Future<void> _checkPendingRequests() async {
    final pending = await OfflineRetryHelper.getPendingRequests();
    if (pending.isNotEmpty) setState(() => _isPending = true);
  }

  Future<void> _submit() async {
    if (_selectedFile == null) {
      TTSHelper.speak("Please select a document before submitting.");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a document")));
      return;
    }

    setState(() {
      _loading = true;
      _progress = 0;
    });

    TTSHelper.speak("Submitting your document, please wait.");

    Map<String, dynamic> kycData = {"document": _selectedFile};

    // Simulate progress bar animation
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() => _progress = i / 10);
    }

    await submitKYC(kycData); // offline/retry logic

    setState(() {
      _loading = false;
      _isPending = true; // show pending until retried
    });

    TTSHelper.speak("Document submitted successfully.");

    // Show confirmation briefly
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Document submitted successfully!")),
    );

    await submitKYC(kycData); // offline/retry logic

    if (!mounted) return;

    // Small delay to let user see completed progress
    await Future.delayed(const Duration(milliseconds: 200));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FaceVerificationScreen()),
    );
  }

  void _selectDocument(String docType) {
    setState(() {
      _selectedFile = docType;
    });
    TTSHelper.speak("$docType selected");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Documents")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: _loading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LinearProgressIndicator(value: _progress),
                    const SizedBox(height: 20),
                    Text(
                      "Submitting ${_selectedFile ?? 'document'}...",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "📄 Upload Aadhaar, PAN or Passport",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Document selection buttons
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _docButton("Aadhaar"),
                        _docButton("PAN"),
                        _docButton("Passport"),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Selected document
                    if (_selectedFile != null)
                      Text(
                        "Selected: $_selectedFile",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const SizedBox(height: 25),

                    PrimaryButton(
                      label: "Submit Documents",
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 15),

                    if (_isPending)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.cloud_off, color: Colors.orange),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "Submission pending. Will retry automatically.",
                              style: TextStyle(color: Colors.orange),
                            ),
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
                          final response = LLMHelper.getResponse("document");
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

  Widget _docButton(String docType) {
    bool isSelected = _selectedFile == docType;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey.shade200,
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      onPressed: () => _selectDocument(docType),
      child: Text(docType),
    );
  }
}
