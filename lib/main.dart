import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ideation_station/ui/screens/home_screen.dart';
import 'package:ideation_station/ui/widgets/error_boundary.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Configure global error handling (T105)
  configureErrorHandling();

  // Allow all device orientations (portrait and landscape)
  // Handles edge case 3: graceful rotation handling
  // FR-032a: Landscape preference for tablets is handled by allowing all orientations
  // The Buzan methodology benefits from landscape's radial space on larger devices
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft, // Prefer landscape first (T096)
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
      home: const HomeScreen(),
    );
  }
}
