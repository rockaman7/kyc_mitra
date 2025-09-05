import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineRetryHelper {
  static const _pendingKey = "pending_kyc";

  static final List<Map<String, dynamic>> _pending = [];

  static Future<void> removePendingRequest(Map<String, dynamic> data) async {
    _pending.remove(data);
  }

  static Future<List<Map<String, dynamic>>> getPendingRequests() async {
    return List.from(_pending);
  }
  /// Save KYC data locally if network is unavailable
  static Future<void> savePendingRequest(Map<String, dynamic> data) async {

    final prefs = await SharedPreferences.getInstance();
    List<String> pending =
        prefs.getStringList(_pendingKey) ?? <String>[];

    pending.add(jsonEncode(data));
    await prefs.setStringList(_pendingKey, pending);
  }

  /// Try sending pending requests once online
  static Future<void> retryPendingRequests(
      Future<bool> Function(Map<String, dynamic>) sendFunction) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> pending = prefs.getStringList(_pendingKey) ?? <String>[];

    List<String> stillPending = [];

    for (String item in pending) {
      Map<String, dynamic> data = jsonDecode(item);
      bool success = await sendFunction(data);

      if (!success) {
        stillPending.add(item); // keep if failed again
      }
    }

    await prefs.setStringList(_pendingKey, stillPending);
  }

  /// Check network availability
  static Future<bool> isOnline() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
