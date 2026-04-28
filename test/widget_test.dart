import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adopti_mobile/main.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: '.env');
  });

  testWidgets('App renders ProviderScope with AdoptiApp', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AdoptiApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
