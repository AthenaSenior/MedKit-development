import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static String loggedInUserEmail = "";

  late String backgroundImage, title, name;

  @override
  void initState() {
    super.initState();
    var dt = DateTime.now().hour;

    /* QUERYING USER --- T.B.C.
 // Commented for now.
     name = "";

    FirebaseFirestore.instance
        .collection('Med-Kit User')
        .where('email', isEqualTo: loggedInUserEmail)
        .get().then(
            (data) => print("Successfully completed"),
      onError: (e) => print("Error completing: $e"),
    ); */

    name = "";
    if(dt >= 6 && dt < 12)
    {
      backgroundImage = "assets/images/morning.jpg";
      title = "Good morning, $name";
    }
    else if (dt >= 12 && dt < 18)
    {
      backgroundImage = "assets/images/afternoon.jpg";
      title = "Good afternoon, $name";
    }
    else if (dt >= 18 && dt < 21)
    {
      backgroundImage = "assets/images/evening.jpg";
      title = "Good evening, $name";
    }
    else if (dt >= 21 || dt < 6)
    {
      backgroundImage = "assets/images/night.jpg";
      title = "Good night, $name";
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              )),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            SizedBox(
              height: size.height * 0.06,
            ),
                Row(
                  children:[
                    SizedBox(
                      width: size.width * 0.04,
                    ),
                    Text(
                        title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18)
                    ),
                  ]
                ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: size.height * .75,
                  width: size.width * .95,
                  decoration: BoxDecoration(
                      color: Colors.white70.withOpacity(.75),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                     ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [

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