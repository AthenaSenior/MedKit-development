import 'dart:math';

import 'package:flutter/material.dart';
import 'package:med_kit/service/auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool emailInvalid = false;
  final AuthService _authService = AuthService();
  // Initialization of variables

  @override
  void initState() {
    super.initState();
  }

  String generatePassword() { // returns a random password.
    String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String lower = 'abcdefghijklmnopqrstuvwxyz';
    String numbers = '1234567890';
    String symbols = '!@#\$%^&*()<>,./';
    int passLength = 16;
    String seed = upper + lower + numbers + symbols;
    String password = '';
    List<String> list = seed.split('').toList();
    Random rand = Random();

    for (int i = 0; i < passLength; i++) {
      int index = rand.nextInt(list.length);
      password += list[index];
    }
    return password;
  }

  @override
  Widget build(BuildContext context) { // Main widget
    var size = MediaQuery.of(context).size;

    return Scaffold(
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
              height: 30,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: size.height * .54,
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
                          const Text(
                              "If you forgot your password, I can generate you a new password and send it to your e-mail. After login, you can change it via your profile.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300)
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          const Text(
                              "Please enter your e-mail.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300)
                          ),
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
                            height: size.height * 0.06,
                          ),
                          Visibility(
                            visible: emailInvalid,
                            child: const Text("I cannot recognize this email. Are you sure you have an account with this?",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                    print(_emailController.text);
                                    print(generatePassword());
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
                                      "Send new password",
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
          ]),
        ));
  }
}