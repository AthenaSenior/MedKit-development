import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:med_kit/service/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool emailInvalid = false, emailValid = false, wait = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  String errorText = "";
  // Initialization of variables and instances

  Future<void> saveDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";
    await prefs.setString("lastDate", formattedDate);
  }

  Future<DateTime?> getDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedDate = prefs.getString("lastDate") ?? "";
    List<String> dateParts = savedDate.split("-");
    if (dateParts.length != 3) {
      return null;
    }
    int? year = int.tryParse(dateParts[2]);
    int? month = int.tryParse(dateParts[1]);
    int? day = int.tryParse(dateParts[0]);
    if (year == null || month == null || day == null) {
      return null;
    }
    return DateTime(year, month, day);
  }

  Future<void> setPasswordResetRequestLimit(bool limit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('wait', limit);
  }

  Future<bool?> getPasswordResetRequestLimit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('wait');
  }

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

  Future<DateTime> getTurkeyTime() async {
    final response = await http.get(Uri.parse('https://medkit-api.onrender.com/get_time'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final String dateTimeString = jsonResponse['turkey_time'];
      return DateTime.parse(dateTimeString).toLocal();
    } else {
      throw Exception('Failed to get Turkey time');
    }
  }


  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    getDate().then((date) {
      getTurkeyTime().then((value) {
        DateTime dt = value;
        int? res = date?.difference(dt).inDays;

        if (res! < 0) {
          setPasswordResetRequestLimit(false);
        }
      });
    });
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
                              "If you forgot your password, I can send a link for changing your password to your e-mail address. You can set a new password with that link. \n\n You can get only one e-mail per day.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300)
                          ),
                          SizedBox(
                            height: size.height * 0.035,
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
                              getPasswordResetRequestLimit().then((val)
                              {
                                if(val != null)
                                  {
                                    if(!val)
                                      {
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
                                                saveDate();
                                                setPasswordResetRequestLimit(true); // Every user can request password reset one time in a day
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
                                      }
                                    else{
                                      setState(() {
                                        emailInvalid = false;
                                        emailValid = false;
                                        wait = true;
                                      });
                                    }
                                  }
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
                          Visibility(
                            visible: wait,
                            child: const Text("Please wait before getting another reset password mail.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.lightBlueAccent,
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