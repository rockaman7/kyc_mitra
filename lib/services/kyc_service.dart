import '../utils/offline_retry_helper.dart';

Future<void> submitKYC(Map<String, dynamic> kycData) async {
  bool online = await OfflineRetryHelper.isOnline();

  if (online) {
    bool success = await fakeSendToServer(kycData);
    if (!success) {
      await OfflineRetryHelper.savePendingRequest(kycData);
    }
  } else {
    await OfflineRetryHelper.savePendingRequest(kycData);
  }
}

/// Mock server call (replace with real API later)
Future<bool> fakeSendToServer(Map<String, dynamic> data) async {
  print("📡 Sending to server: $data");
  await Future.delayed(const Duration(seconds: 2));
  return false; // simulate failure for testing
}
