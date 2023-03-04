import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(.75),
        body:Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/loading.gif",
            width: 60, height: 60),
            const Text("We're getting things ready..",
                style: TextStyle(fontSize: 18, color: Colors.white)
            ),
          ],
        ),
        ),
          );

  }
}