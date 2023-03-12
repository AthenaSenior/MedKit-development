import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'LoginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  bool loading = false;
  late Animation<double> animation;
  late AnimationController animationController;
  int _start = 10;
  late Timer splashTimer;
  // Initialization of variables @Egemen

  // Animation - Rotation Function @Egemen
  void setRotation(int degrees) {
    final angle = degrees * pi / 180;
    animation =
        Tween<double>(begin: 0, end: angle).animate(animationController);
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    splashTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const LoginPage())); // We will redirect them to login page by here. @Egemen
          });
          timer.cancel();
        } else if (_start == 6) {
          setState(() {
            loading = true;
            _start--;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  late String splashScreenSentence;
  List<String> splashScreenSentences = [ // Random sentence from here will be shown @Egemen
    "Interesting fact : \nI am better than google search ;)",
    "Waiting you for scan..",
    "Are you ill again ? :/",
    "Bring me some medicine!",
    "+Knock Knock! \n-Who is there? \n+ Your friendly Pharmacist Med-Kit!",
    "No pharmacist near to you ? I have an idea!",
    "Hey siri! Thank you for opening me!",
    "I am ready to inform you about the medicines!"
  ];

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    setRotation(360);
    animationController.forward(from: 0);
    startTimer();
    var intValue = Random().nextInt(8); // Value is >= 0 and < 8.
    splashScreenSentence = splashScreenSentences[intValue];
    // Executions as initial state @Egemen
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose(); // Dispose for animation @Egemen
  }

  @override
  Widget build(BuildContext context) { // Main widget
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/background2.jpg"),
          fit: BoxFit.cover,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) => Transform.rotate(
                angle: animation.value,
                child: child,
              ),
              child: Image.asset('assets/images/medkit_logo.png',
                  width: 250, height: 200),
            ),
            const SizedBox(height: 20),
            Visibility(
                visible: loading,
                child: Image.asset('assets/images/loading.gif',
                    width: 30, height: 30)),
            const SizedBox(height: 20),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(splashScreenSentence,
                      style: const TextStyle(fontSize: 18)),
                ]),
          ],
        ),
      ),
    );
  }
}



