import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static String loggedInUserFullName = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome",
              style: TextStyle(
                color: Colors.black38,
                fontSize: 20,
              ),
            ),
            Text(
              loggedInUserFullName,
              style: const TextStyle(
                color: Colors.black38,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}