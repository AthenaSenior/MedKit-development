import 'dart:async';
import 'dart:math';

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

class _SplashScreenState extends State<SplashScreen> with
SingleTickerProviderStateMixin{

  // Animation - Rotation Function Author Egemen
  bool loading = false;
  late Animation<double> animation;
  late AnimationController animationController;

  void setRotation(int degrees) {
    final angle = degrees * pi / 180;
    animation = Tween<double>(begin: 0, end: angle).animate(animationController);
  }


  late Timer _timer;
  int _start = 10;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()));// Buradan yeni sayfaya yönlendireceğiz. Author Egemen
          });
          timer.cancel();
        }
        else if (_start == 6) {
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
  List<String> initialScreenSentences =
  ["Med-Kit is with you with its expanding medicine list.",
    "Scan your drug today and see its content fastly.",
    "Do you know ",
    "Japan",
    "China",
    "UK",
    "Uganda",
    "Uruguay"];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3)
    );
    setRotation(360);
    animationController.forward(from:0);
    startTimer();
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
            )
        ),
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
                  width: 250,
                  height: 200),

            ),
            Visibility(
              visible: loading,
              child: Image.asset('assets/images/loading-gif.gif',
                  width: 30,
                  height: 30)
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/medkit_logo.png',
                width: 200,
                height: 150),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                    Text("Username:", style: TextStyle(fontSize: 25)
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                      width:150,
                      height:50,
                      child: TextField(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Colors.white38),
                            ),
                        ),
                      ),
                    )
                    ],
            ),
            const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text("Password:", style: TextStyle(fontSize: 25)
            ),
            SizedBox(width: 23),
            SizedBox(
              width:150,
              height:50,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Colors.white38),
                    ),

                ),
              ),
            )
          ],
        ),
            const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(top:0, left:70, right:0),
            alignment: Alignment.center,
            child:
              CheckboxListTile(
                title: const Text("Remember me", style: TextStyle(fontSize: 17)),
                value: checkedValue,
                onChanged: (newValue) {
                  setState(() { //// KULLANICIYI HATIRLAMA İŞLEMİ @@ Author Egemen
                    checkedValue = newValue!;
                    if (checkedValue) {
                      // TODO: Here goes your functionality that remembers the user.
                    } else {
                      // TODO: Forget the user
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Login", style: TextStyle(color: Colors.white),),
              onPressed: (){
                // TODO: Login Function.
              },
            ),
            // Daha çok widget ekleyebilirsiniz burdan @@ Author Egemen
          ],

        ),
      ),
    );
  }
}