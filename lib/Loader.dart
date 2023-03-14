import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  // This screen will be shown until the data will be loaded by app.
  // Feel free to edit the design of here @Egemen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
        constraints: const BoxConstraints.expand(),
    decoration: const BoxDecoration(
    image: DecorationImage(
    image: AssetImage("assets/images/background2.jpg"),
    fit: BoxFit.cover,
    )), child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/medkit_logo.png",
                width: 150, height: 160),
            const SizedBox(
              height: 25,
            ),
            const Text("We're getting things ready..",
                style: TextStyle(fontSize: 24, color: Colors.black)
            ),
            const SizedBox(
              height: 25,
            ),
            LoadingAnimationWidget.fourRotatingDots(
            size: 70, color: Colors.blueGrey)
          ],
        ),
        ),
        ),
          );

  }
}