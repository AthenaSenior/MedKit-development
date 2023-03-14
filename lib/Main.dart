import 'package:flutter/material.dart';
import 'package:med_kit/service/auth.dart';
import 'FAQ.dart';
import 'Home.dart';
import 'LoginPage.dart';
import 'Profile.dart';
import 'Scan.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

// This is controller page of our app. Other pages are showing as body of this page. @Egemen

class MainPageState extends State<MainPage> {

  static String loggedInUserKey = "";
  int selectedPage = 0;
  bool canGoBack = false;
  var hideBar = false;
  final AuthService _authService = AuthService();

  final _pageOptions = [
    HomePage(loggedInUserKey: loggedInUserKey),
    Profile(loggedInUserKey: loggedInUserKey),
    const Scan(),
    FAQ(),
    const LoginPage()
  ];

  @override
  Widget build(BuildContext context) { // Main widget
    return WillPopScope(
      onWillPop: () async {
      setState(() {
        selectedPage = 0;
        hideBar = false;
      });
      return false;
      },
    child: Scaffold(
        backgroundColor: Colors.white,
        body: _pageOptions[selectedPage],
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
        currentIndex: selectedPage,
        selectedItemColor: Colors.blueAccent,
        onTap: (i){
          setState(() {
            selectedPage = i; // index
            if(selectedPage == 2) {
              hideBar = true;
              canGoBack = true;
            }
            else if(selectedPage == 4){
              _authService.signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const LoginPage()));
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