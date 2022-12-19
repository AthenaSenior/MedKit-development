import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:med_kit/service/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Animation - Rotation Function Author Egemen
  bool loading = false;
  late Animation<double> animation;
  late AnimationController animationController;

  void setRotation(int degrees) {
    final angle = degrees * pi / 180;
    animation =
        Tween<double>(begin: 0, end: angle).animate(animationController);
  }

  int _start = 10;
  late Timer splashTimer;

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
                        const LoginPage())); // Buradan yeni sayfaya yönlendireceğiz. Author Egemen
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
  List<String> splashScreenSentences = [
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
    var intValue = Random().nextInt(7); // Value is >= 0 and < 10.
    splashScreenSentence = splashScreenSentences[intValue];
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: Image.asset('assets/images/loading-gif.gif',
                    width: 30, height: 30)),
            const SizedBox(height: 20),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(splashScreenSentence,
                      style: const TextStyle(fontSize: 18)),
                ]),
            // Buraya daha çok widget ekleyebilirsiniz virgüllerle
            // @@ Author Egemen
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  static bool informationInvalid = false;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/background2.jpg"),
          fit: BoxFit.cover,
        )),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Image.asset('assets/images/medkit_logo.png', width: 150, height: 100),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: size.height * .5,
                width: size.width * .85,
                decoration: BoxDecoration(
                    color: Colors.green.withOpacity(.75),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.75),
                          blurRadius: 10,
                          spreadRadius: 2)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                            controller: _emailController,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Colors.white,
                              ),
                              hintText: 'E-Mail',
                              prefixText: ' ',
                              hintStyle: TextStyle(color: Colors.white),
                              focusColor: Colors.white,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              )),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              )),
                            )),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        TextField(
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            cursorColor: Colors.white,
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.vpn_key,
                                color: Colors.white,
                              ),
                              hintText: 'Password',
                              prefixText: ' ',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              focusColor: Colors.white,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              )),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              )),
                            )),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Visibility(
                          visible: informationInvalid,
                          child: const Text("Username or password is invalid.",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                        InkWell(
                          onTap: () {
                            _authService
                                .logInToSystem(_emailController.text,
                                    _passwordController.text)
                                .then((value) {
                              return Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()));
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                //color: colorPrimaryShade,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30))),
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Center(
                                  child: Text(
                                "Login to Med-Kit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterPage()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(children: <Widget>[
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "No account yet?",
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(children: <Widget>[
                                  Container(
                                    height: 1,
                                    width: 75,
                                    color: Colors.white,
                                  ),
                                  const Text(
                                    "Register",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Container(
                                    height: 1,
                                    width: 75,
                                    color: Colors.white,
                                  ),
                                ])
                              ]),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static String loggedInUserFullName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();
  static bool registerInformationInvalid = false;
  bool _listTileCheckBox = false;
  static String errorMessage = "";
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/background2.jpg"),
            fit: BoxFit.cover,
          )),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: size.height * .7,
                width: size.width * .85,
                decoration: BoxDecoration(
                    color: Colors.green.withOpacity(.75),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.75),
                          blurRadius: 10,
                          spreadRadius: 2)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                            controller: _nameController,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              hintText: 'Your Full Name',
                              prefixText: ' ',
                              hintStyle: TextStyle(color: Colors.white),
                              focusColor: Colors.white,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              )),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              )),
                            )),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        TextField(
                            controller: _emailController,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Colors.white,
                              ),
                              hintText: 'E-Mail',
                              prefixText: ' ',
                              hintStyle: TextStyle(color: Colors.white),
                              focusColor: Colors.white,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              )),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              )),
                            )),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        TextField(
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            cursorColor: Colors.white,
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.vpn_key,
                                color: Colors.white,
                              ),
                              hintText: 'Password',
                              prefixText: ' ',
                              hintStyle: TextStyle(color: Colors.white),
                              focusColor: Colors.white,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              )),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              )),
                            )),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        TextField(
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            cursorColor: Colors.white,
                            controller: _passwordAgainController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.vpn_key,
                                color: Colors.white,
                              ),
                              hintText: 'Password Repeat',
                              prefixText: ' ',
                              hintStyle: TextStyle(color: Colors.white),
                              focusColor: Colors.white,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              )),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              )),
                            )),
                        CheckboxListTile(
                          value: _listTileCheckBox,
                          // ignore: prefer_const_constructors
                          title: Text(
                            "I understand and agree that this application is only for suggestion and does not claiming any professional medical support",
                            style: const TextStyle(color: Colors.white),
                          ),
                          onChanged: (val) {
                            setState(() {
                              _listTileCheckBox = val!;
                            });
                          },

                          activeColor: Colors.green,
                          checkColor: Colors.black,
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Visibility(
                          visible: registerInformationInvalid,
                          child: Text(errorMessage,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                        InkWell(
                          onTap: () {
                            _authService
                                .registerToSystem(
                                    _nameController.text,
                                    _emailController.text,
                                    _passwordController.text,
                                    _listTileCheckBox)
                                .then((value) {
                              return Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                //color: colorPrimaryShade,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30))),
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Center(
                                  child: Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(top: size.height * .06, left: size.width * .02),
          child: Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.green.withOpacity(.75),
                    size: 26,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.3,
                ),
                Text(
                  "Register",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.green.withOpacity(.75),
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}
