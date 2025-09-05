import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'services/retry_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Start retry service in background
  RetryService.startRetryLoop(intervalSeconds: 10);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KYC Mitra',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WelcomeScreen(),
    );
  }
}
