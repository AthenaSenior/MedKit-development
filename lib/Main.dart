import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:med_kit/service/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FAQ.dart';
import 'Home.dart';
import 'LoginPage.dart';
import 'Profile.dart';
import 'Scan.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key, required this.pageId});

  int pageId;

  @override
  MainPageState createState() => MainPageState();
}

// This is controller page of our app. Other pages are showing as body of this page. @Egemen

class MainPageState extends State<MainPage> {

  static String loggedInUserKey = "";
  bool canGoBack = false;
  var hideBar = false;
  final AuthService _authService = AuthService();

  final _pageOptions = [
    HomePage(loggedInUserKey: loggedInUserKey),
    Profile(loggedInUserKey: loggedInUserKey),
    const Scan(),
    FAQ(),
  ];

  Future<void> _showUsersAreTheySureToExit() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit from Med-Kit'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure to exit from Med-Kit?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Exit'),
              onPressed: () {
                _authService.signOut();
                resetRememberMeAfterLogOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const LoginPage()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> resetRememberMeAfterLogOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('rememberedUserEmail', "");
    prefs.setString('rememberedUserPass', "");
    prefs.setBool('rememberMe', false);
  }

  @override
  void initState()
  {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) { // Main widget
    return WillPopScope(
      onWillPop: () async {
      setState(() {
        widget.pageId = 0;
        hideBar = false;
      });
      return false;
      },
    child: Scaffold(
      resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: _pageOptions[widget.pageId],
       bottomNavigationBar: Visibility(
         visible: !hideBar,
         child:
         BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner, color: Colors.grey),
            label: 'Scan Drugs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer, color: Colors.grey),
            label: 'FAQ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout, color: Colors.grey),
            label: 'Log Out',
          ),
        ],
        currentIndex: widget.pageId,
        selectedItemColor: Colors.green,
        onTap: (i){
          setState(() {//
            if(i != 4) {
              widget.pageId = i; // index
            }
            else{
              _showUsersAreTheySureToExit();
            }
            if(widget.pageId == 2) {
              hideBar = true;
              canGoBack = true;
            }
            else{
              canGoBack = false;
              hideBar = false;
            }
          });
        },
      ),
      ),
    ),
    );
  }
}