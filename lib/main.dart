import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(title: ''),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.title});

  final String title;



  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /* int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  */

  double turns = 0.0;

  void _changeRotation() {
    setState(() => turns += 1.0 / 8.0);
  }

  @override
  void initState() {
    super.initState();
    _changeRotation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedRotation(
              turns: turns,
              duration: const Duration(seconds: 15),
              child: Image.asset('assets/images/medkit_logo.jpg', width: 350, height: 300),
            ),
            // Image.asset('assets/images/medkit_logo.jpg', width: 350, height: 300),
            // Buraya daha çok widget ekleyebilirsiniz virgüllerle
            // @@ Author Egemen
          ],
        ),
      ),
    );
  }
}
