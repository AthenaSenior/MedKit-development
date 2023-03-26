import 'package:flutter/material.dart';

class FAQ extends StatelessWidget {
  FAQ({super.key});

  String backgroundImage = "", title= "";
  // Variable initializations

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
  Widget build(BuildContext context) { // Main widget
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
            Image.asset('assets/images/faq.png', width: 170, height: 120),
            SizedBox(
                height: size.height * .05
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: size.height * .69,
                  width: size.width * .95,
                  decoration: BoxDecoration(
                    color: Colors.white70.withOpacity(.75),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child:
                      Column(
                          children: [
                            const Text(
                                "What is a MedKit application?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17)
                            ),
                            const Text(
                                "MedKit application allows users to take pictures of medication using their smartphone's camera, then recognize the medication and provide information about it. The application also saves the medicines that scanned by the users to the database for later viewing.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17)
                            ),
                            const Text(
                                "\n Can a MedKit application be used to identify all types of medication?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17)
                            ),
                            const Text(
                                "MedKit may not be able to identify all types of medication. Some medication may not be included in the app's database, and the app may not be able to identify medications with similar appearances. However, the application's database continues to be expanded by the developers.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17)
                            ),
                            const Text(
                                "\n What is Opposite Drag Warning?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17)
                            ),
                            const Text(
                                "Opposite Drag Warning gives a warning for medicines that should not be used together. In order to receive the Opposite Drug Warning, 2 drugs that should not be used together must be scanned by the user. This warning appears on users' own profiles.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17)
                            ),
                            const Text(
                                "\n Where can I find my scanned medicines?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17)
                            ),
                            const Text(
                                "The scanned medicines can be accessed from the home page.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17)
                            ),
                            const Text(
                                "\n Is a MedKit application a substitute for consulting a healthcare professional?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17)
                            ),
                            const Text(
                                "No, MedKit should not be used as a substitute for consulting a healthcare professional. It is always important to consult with a doctor or pharmacist before taking any new medication. MedKit gives only general information about medicines.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17)
                            ),
                            const Text(
                                "\n Are there any risks associated with using a MedKit?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17)
                            ),
                            const Text(
                                "There may be some risks associated with using a medicine recognition application, such as the app providing inaccurate information or identifying a medication incorrectly. It is important to verify any information provided by the app with a healthcare professional.",
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
            ),
          ],
          ),
        ),
      ),
    );
  }
}
