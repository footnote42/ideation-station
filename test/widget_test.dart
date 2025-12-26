// Basic Flutter widget test for Ideation Station

import 'package:flutter_test/flutter_test.dart';

import 'package:ideation_station/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const IdeationStationApp());

    // Verify that our app title appears.
    expect(find.text('Ideation Station - Mind Mapping App'), findsOneWidget);
  });
}
