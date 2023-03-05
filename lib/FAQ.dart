import 'package:flutter/material.dart';

class FAQ extends StatelessWidget {
  FAQ({super.key});

  String backgroundImage = "", title= "";

  void createUIWithHour()
  {
    var dt = DateTime.now().hour;
    if(dt >= 6 && dt < 12)
    {
      backgroundImage = "assets/images/morning.jpg";
    }
    else if (dt >= 12 && dt < 18)
    {
      backgroundImage = "assets/images/afternoon.jpg";
    }
    else if (dt >= 18 && dt < 21)
    {
      backgroundImage = "assets/images/evening.jpg";
    }
    else if (dt >= 21 || dt < 6)
    {
      backgroundImage = "assets/images/night.jpg";
    }
  }

  @override
  Widget build(BuildContext context) {
    createUIWithHour();
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
            Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: size.height * .85,
                    width: size.width * .95,
                    decoration: BoxDecoration(
                      color: Colors.white70.withOpacity(.75),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child:
                      Column(
                          children: [
                            const Text(
                                "FAQ", // Aleyna will fill here with FAQ text prepared by her.
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17)
                            ),
                            SizedBox(
                                height: size.height * .02
                            ),
                            /* Image.asset("assets/images/medkit_logo.png",
                                width: 90, height: 90), */
                          ]
                      ),
                    ),
                  ),
                ),
              ),
                        ],
                      ),
                    ),
                  ),
                );
  }
}
