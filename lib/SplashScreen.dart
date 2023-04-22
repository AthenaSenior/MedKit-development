import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:med_kit/service/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'LoginPage.dart';
import 'Main.dart';
import 'RegisterPage.dart';

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
  final AuthService _authService = AuthService();
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
            getRememberMeToAutoLoginOrNot().then((value) {
              if(value) {
                print("Auto-login has succeed.");
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const LoginPage()));
              }
            });
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose(); // Dispose for animation @Egemen
  }

  Future<bool> getRememberMeToAutoLoginOrNot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('rememberMe') == true)
    {
      String user = prefs.getString('rememberedUserEmail') ?? "";
      String pass = prefs.getString('rememberedUserPass')  ?? "";
      _authService
          .logInToSystem(user, pass)
          .then((value) {
        LoginPageState.informationInvalid = false;
        HomePageState.registeredForFirstTime = false;
        RegisterPageState.registerInformationInvalid = false;
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainPage(pageId: 0)));
      });
      return true;
    }
    return false;
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
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                ]),
          ],
        ),
      ),
    );
  }
}



