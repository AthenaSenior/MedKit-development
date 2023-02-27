import 'package:flutter/material.dart';
import 'FAQ.dart';
import 'Home.dart';
import 'Profile.dart';
import 'Scan.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedPage = 0;
  var noScanPage = true;

  final _pageOptions = [
    const HomePage(),
    const Profile(),
    const Scan(),
    const FAQ()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _pageOptions[selectedPage],
       bottomNavigationBar: Visibility(
         visible: noScanPage,
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
              noScanPage = false;
            }
            else{
              noScanPage = true;
            }
          });
        },
      ),
      ),
    );
  }
}