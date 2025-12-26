import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideation_station/ui/screens/canvas_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: IdeationStationApp(),
    ),
  );
}

class IdeationStationApp extends StatelessWidget {
  const IdeationStationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ideation Station',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CanvasScreen(),
    );
  }
}
