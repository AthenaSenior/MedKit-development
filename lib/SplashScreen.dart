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

  late AnimationController _controller;
  bool _isShowingFront = true;
  int _start = 8;
  late Timer splashTimer;
  final AuthService _authService = AuthService();
  // Initialization of variables @Egemen

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
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
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
    _controller.dispose();
    super.dispose(); // Dispose for animation @Egemen
  }

  void _toggleShowingSide() {
    setState(() {
      _isShowingFront = !_isShowingFront;
    });
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
            GestureDetector(
              onTap: _toggleShowingSide,
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _isShowingFront
                      ? Image.asset('assets/images/medkit_logo.png', width: 250, height: 200, key: UniqueKey())
                      : Image.asset('assets/images/medkit_logo.png', width: 250, height: 200, key: UniqueKey()),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(splashScreenSentence,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                  const SizedBox(height: 20),
                  const Text("I'm getting ready for you.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
                ]),
          ],
        ),
      ),
    );
  }
}



