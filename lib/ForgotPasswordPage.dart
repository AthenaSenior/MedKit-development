import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_kit/service/auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool emailInvalid = false, emailValid = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  String errorText = "";
  // Initialization of variables and instances

  Future<bool> searchEmailInDb(String email)
  async {
    var snapshot = await firestore.collection("Med-Kit User").
    where('email', isEqualTo: email).get();
    if(snapshot.size == 0)
      {
        errorText = "I cannot recognize this email. Make sure this is a valid e-mail or an account exists with it.";
        return false;
      }
    return true;
  }


  @override
  void initState() {
    super.initState();
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
                              "If you forgot your password, I can send a link for changing your password to your e-mail address. You can set a new password with that link.",
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
                            height: size.height * 0.03,
                          ),
                          Visibility(
                            visible: emailInvalid,
                            child: Text(errorText,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400)),
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          InkWell(
                            onTap: () {
                              if(_emailController.text.isEmpty)
                                {
                                  setState(() {
                                  errorText = "Please enter an e-mail.";
                                  emailInvalid = true;
                                  emailValid = false;
                                  });
                                }
                              else{
                                searchEmailInDb(_emailController.text).then((value)
                                {
                                  if(value)
                                  {
                                    setState(() { // If e-mail is valid and exists in system
                                      emailInvalid = false;
                                      emailValid = true;
                                      _authService.resetPassword(_emailController.text);
                                    });
                                  }
                                  else{
                                    setState(() {
                                      emailInvalid = true;
                                      emailValid = false;
                                      errorText = "I cannot recognize this email. Make sure this is a valid e-mail or an account exists with it.";
                                    });
                                  }});
                              }
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
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Visibility(
                            visible: emailValid,
                            child: const Text("I sent an e-mail that including your new password!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400)),
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