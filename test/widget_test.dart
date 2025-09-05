// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kyc_mitra/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify welcome screen loads
    expect(find.text('👋 Welcome'), findsOneWidget);
  });
}
