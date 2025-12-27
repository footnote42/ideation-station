// Basic Flutter widget test for Ideation Station

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ideation_station/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: IdeationStationApp()));

    // Verify that our app starts with HomeScreen.
    expect(find.text('Mind Maps'), findsOneWidget);

    // Verify empty state message appears when no mind maps exist.
    expect(find.text('No Mind Maps Yet'), findsOneWidget);
  });
}
