import 'dart:async';
import 'package:kyc_mitra/utils/offline_retry_helper.dart';

import 'kyc_service.dart';

class RetryService {
  static Timer? _timer;

  // Start automatic retry every N seconds
  static void startRetryLoop({int intervalSeconds = 10}) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: intervalSeconds), (_) async {
      await _retryPendingRequests();
    });
  }

  // Stop the retry loop
  static void stopRetryLoop() {
    _timer?.cancel();
    _timer = null;
  }

  static Future<void> _retryPendingRequests() async {
    final pendingList = await OfflineRetryHelper.getPendingRequests();

    if (pendingList.isEmpty) return;

    for (var data in pendingList) {
      final success = await fakeSendToServer(data); // replace with real API later
      if (success) {
        await OfflineRetryHelper.removePendingRequest(data);
        print("✅ KYC retried successfully: $data");
      } else {
        print("⚠️ KYC retry failed: $data");
      }
    }
  }
}
