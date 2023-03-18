import 'package:flutter/material.dart';
import 'package:med_kit/service/auth.dart';
import 'Home.dart';
import 'LoginPage.dart';
import 'Main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController = TextEditingController();
  static bool registerInformationInvalid = false;
  static String errorMessage = "";
  bool _listTileCheckBox = false;
  final AuthService _authService = AuthService();
  // Variables for register
  List<String> list = <String>['Male', 'Female', 'Other'];

  String dropdownValue = 'Male'; // by Default

  IconData icon = Icons.male_rounded;

  @override
  Widget build(BuildContext context) { // Main widget
    var size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Row(
                              children:[
                                SizedBox(
                                 width: size.width * 0.03,
                                ),
                                Icon(
                                  icon,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: size.width * 0.038,
                                ),
                                const Text(
                                  "Select your gender: ",
                                  style: TextStyle(color: Colors.white, fontSize: 17),
                                ),
                                DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 14,
                                  style: const TextStyle(color: Colors.black),
                                  underline: Container(
                                    height: 3,
                                    width: 45,
                                    color: Colors.white60,
                                  ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      dropdownValue = value!;
                                      if(dropdownValue == 'Male') {
                                        icon = Icons.male_rounded;
                                      } else if(dropdownValue == 'Female'){
                                        icon = Icons.female_rounded;
                                      }
                                      else{
                                        icon = Icons.transgender_rounded;
                                      }
                                    });
                                  },
                                  items: list.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ]
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            const Divider(
                                color: Colors.white
                            ),
                            CheckboxListTile(
                              value: _listTileCheckBox,
                              // ignore: prefer_const_constructors
                              title: Text(
                                "I understand and agree that this application is only "
                                    "for suggestion and does not claiming any "
                                    "professional medical support.",
                                style: const TextStyle(color: Colors.white, fontSize: 10),
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              height: size.height * 0.04,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _authService
                                      .registerToSystem(
                                      _nameController.text,
                                      _emailController.text,
                                      _passwordController.text,
                                      _passwordAgainController.text,
                                      dropdownValue,
                                      _listTileCheckBox)
                                      .then((value) {
                                    LoginPageState.informationInvalid = false;
                                    RegisterPageState.registerInformationInvalid = false;
                                    MainPageState.loggedInUserKey = _emailController.text;
                                    HomePageState.registeredForFirstTime = true;
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
                        color: Colors.blueGrey.withOpacity(.35),
                        size: 26,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.075,
                    ),
                    Text(
                      "Join to the Med-Kit!",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.blueGrey.withOpacity(.65),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: size.width * 0.03,
                    ),
                    Image.asset("assets/images/medkit_logo.png",
                        width: 55, height: 55),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}