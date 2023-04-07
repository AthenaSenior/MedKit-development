import 'package:flutter/material.dart';
import 'package:med_kit/service/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ForgotPasswordPage.dart';
import 'Home.dart';
import 'Main.dart';
import 'RegisterPage.dart';

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
  bool _rememberMe = false;
  // Initialization of variables

  Future<void> setRememberMe(String email, String pass, bool rememberMe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('rememberedUserEmail', _emailController.text);
    prefs.setString('rememberedUserPass', _passwordController.text);
    prefs.setBool('rememberMe', rememberMe);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) { // Main widget
    var size = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: () async => false,
    child: Scaffold(
      resizeToAvoidBottomInset: false,
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
            height: 10,
          ),
          const Text(
            "Welcome back!",
            style: TextStyle(
              color: Colors.green,
              fontSize: 18,
              fontWeight: FontWeight.w400)
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: size.height * .58,
                width: size.width * .85,
                decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(.35),
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
                                fontWeight: FontWeight.w600,
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
                              fontWeight: FontWeight.w600,
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
                                  fontSize: 15,
                                fontWeight: FontWeight.w400,)),
                        ),
                        CheckboxListTile(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                          title: const Text('Remember me for further logins', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300,),)
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _authService
                                  .logInToSystem(_emailController.text,
                                  _passwordController.text)
                                  .then((value) {
                                    if(_rememberMe)
                                      {
                                        setRememberMe(_emailController.text, _passwordController.text, _rememberMe);
                                      }
                                LoginPageState.informationInvalid = false;
                                HomePageState.registeredForFirstTime = false;
                                RegisterPageState.registerInformationInvalid = false;
                                return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainPage(pageId: 0)));
                              });
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
                    InkWell(
                      onTap: () {
                        LoginPageState.informationInvalid = false;
                        RegisterPageState.registerInformationInvalid = false;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const ForgotPasswordPage()));
                      },
                      child:
                          Column(
                            children:[SizedBox(
                              height: size.height * 0.02,
                            ),Container(
                              height: 1,
                              width: size.width * .95,
                              color: Colors.white,
                            ),SizedBox(
                              height: size.height * 0.02,
                            ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              const Icon(
                              Icons.lock,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              const Text('I forget my password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 15)),
                              ]),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Container(
                                height: 1,
                                width: size.width * .95,
                                color: Colors.white,
                              ),
                            ]
                          )
                    ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        InkWell(
                          onTap: () {
                            LoginPageState.informationInvalid = false;
                            RegisterPageState.registerInformationInvalid = false;
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
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 16),
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
                                  const Icon(
                                    Icons.person,
                                    color: Colors.white
                                  ),
                                  const Text(
                                    "Register",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 15),
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
    ),
    );
  }
}