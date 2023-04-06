import 'package:flutter/material.dart';
import 'package:med_kit/Main.dart';
import 'package:med_kit/service/auth.dart';

class DrugDetail extends StatefulWidget {
  const DrugDetail(
      {super.key,
      required this.drugName,
      required this.drugPicture,
      required this.drugLongDesc});
  final String drugName, drugPicture, drugLongDesc;
  @override
  State<DrugDetail> createState() => DrugDetailState();
}

class DrugDetailState extends State<DrugDetail> {
  // Constructor takes the attributes of drugs from scanner modal or main screen.
  // So, we do not have to query for second time. This will improve the performance of our app.
  // @Egemen

  final AuthService _authService = AuthService();
  String backgroundImage = "", title = "";
  late Color backColor;
  //Variable initializations.

  void createUIWithHour() {
    var dt = DateTime.now().hour;
    if (dt >= 6 && dt < 12) {
      backgroundImage = "assets/images/morning.jpg";
      backColor = Colors.black;
    } else if (dt >= 12 && dt < 18) {
      backgroundImage = "assets/images/afternoon.jpg";
      backColor = Colors.black;
    } else if (dt >= 18 && dt < 21) {
      backgroundImage = "assets/images/evening.jpg";
      backColor = Colors.white70;
    } else if (dt >= 21 || dt < 6) {
      backgroundImage = "assets/images/night.jpg";
      backColor = Colors.white70;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Main widget
    createUIWithHour();
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * .03),
            Row(children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: backColor,
                  size: 26,
                ),
              ),
              Text("Back",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: backColor, fontSize: 26)),
            ]),
            SizedBox(height: size.height * .01),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: size.height * .80,
                  width: size.width * .95,
                  decoration: BoxDecoration(
                    color: Colors.white70.withOpacity(.75),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(children: [
                      Text(widget.drugName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 30, fontWeight: FontWeight.w400)),
                      SizedBox(height: size.height * .01),
                      Image.network(widget.drugPicture,
                          width: size.width * .55, height: size.height * .24),
                      const Divider(color: Colors.black),
                      SizedBox(
                        height: size.height * .444,
                        child: SingleChildScrollView(
                          child: Text(widget.drugLongDesc,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300)),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: 0,
        selectedItemColor: Colors.blueAccent,
        onTap: (i) {
          setState(() {
            if (i == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainPage(pageId: 1)));
            } else if (i == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainPage(pageId: 2)));
            } else if (i == 3) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainPage(pageId: 3)));
            } else if (i == 4) {
              _authService.signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainPage(pageId: 4)));
            }
          });
        },
      ),
    );
  }
}
