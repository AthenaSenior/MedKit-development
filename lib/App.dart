import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'SplashScreen.dart';
import 'firebase_options.dart';

// Root Dart File with Root widget
// Do not touch here. @Egemen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MedKit());
}

class MedKit extends StatelessWidget {
  const MedKit({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}