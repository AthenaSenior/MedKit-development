import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' as fbDb;
import 'Loader.dart';

class Profile extends StatefulWidget {
  Profile({super.key, required this.loggedInUserKey});
    final String loggedInUserKey;
  @override
  State<Profile> createState() => ProfileState();
}

// DRUG TO DRUG WILL NOT IMPLEMENT YET. IT WILL BE IN THE 3RD ITERATION

class ProfileState extends State<Profile> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final fbDb.FirebaseDatabase database = fbDb.FirebaseDatabase.instance;
  fbDb.DatabaseReference ref = fbDb.FirebaseDatabase.instance.ref("UserMedicine");
  // Firebase variables

  int userMedicines = 0;
  bool isLoading = true;
  String backgroundImage = "";
  String gender = "", userName = "", userNote = "", totalScannedDrugs = "0", registerDate = "null";
  // Variable initializations

  Future<void> getLoggedInUserProfileInfo()
  async {

    // Query user by his/her e-mail
    // E-mail is can be considered as unique key
    // Primary key is ID @Egemen

    var snapshot = await firestore.collection("Med-Kit User").
    where('email', isEqualTo: widget.loggedInUserKey).get();

    fbDb.Query query = ref.orderByChild("UserId").equalTo(
        snapshot.docs[0].get("ID"));
    fbDb.DataSnapshot event = await query.get();
    for (var child in event.children) {
      userMedicines++;
    }
    setState(() {
      userName = snapshot.docs[0].get('userName');
      userNote = snapshot.docs[0].get('note');
      registerDate = snapshot.docs[0].get('date');
      gender = snapshot.docs[0].get('gender');
      totalScannedDrugs = userMedicines.toString();
      if(userNote == '')
        {
          userNote = "\n\nYou have no notes yet. Add some to remind yourself daily!";
        }
      isLoading = false;
    });
    }

  @override
  void initState() {
    super.initState();
    getLoggedInUserProfileInfo();
    // Execute the function as initial state @Egemen
  }

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
      child: isLoading? const Scaffold(
        body: Loader(),
      )
          : Scaffold(
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
                height: size.height * .05
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: size.height * .87,
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
                          SizedBox(
                            width: size.width * 90,
                          child:
                          Row(
                            children:[
                              Image.asset(gender == "Male" ? "assets/images/maleUser.png" : "assets/images/femaleUser.png",
                                  width: 120, height: 120),
                              SizedBox(
                                  width: size.width * .08
                              ),
                              Column(
                                children:[
                                  Text(
                                      userName,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 25)
                                  ),
                                  SizedBox(
                                      height: size.height * .02
                                  ),
                                  Text(
                                      widget.loggedInUserKey,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black45,
                                          fontSize: 15)
                                  ),
                                ]
                              )
                            ]
                          ),
                          ),
                          Row(
                            children:[
                              SizedBox(
                                  width: size.width * .57
                              ),
                                        Image.asset("assets/images/edit.png",
                                            width: 25, height: 25),
                                        TextButton(
                                          onPressed: () => {
                                          },
                                          child: const Text('EDIT USER',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ]
                                    ),
                          SizedBox(
                              height: size.height * .02
                          ),
                          const Divider(
                              color: Colors.black
                          ),
                          SizedBox(
                              height: size.height * .02
                          ),
                          Column(
                              children:[
                                Row(
                                    children:[
                                      const Text(
                                          "You have registered on ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17)
                                      ),
                                      Text(
                                          registerDate,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)
                                      ),
                                    ]
                                ),
                                SizedBox(
                                    height: size.height * .03
                                ),
                                Row(
                                    children:[
                                      const Text(
                                          "You have scanned ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,)
                                      ),
                                      Text(
                                          totalScannedDrugs,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)
                                      ),
                                      Text(
                                        totalScannedDrugs == "1" || totalScannedDrugs == "0" ? " medicine." : " medicines.",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 17)
                                      ),
                                    ]
                                ),
                                SizedBox(
                                    height: size.height * .03
                                ),
                                const Divider(
                                    color: Colors.black
                                ),
                                Row(
                                  children:[
                                    Image.asset("assets/images/redalert.png",
                                        width: 30, height: 30),
                                    const Text(
                                        " Your Opposite Drug Warnings",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)
                                    ),
                                  ]
                                ),
                                SizedBox(
                                    height: size.height * .20
                                ),
                                const Text(
                                    "Be careful for those listed above. It is not recommended to use them together.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)
                                ),
                                SizedBox(
                                    height: size.height * .02
                                ),
                                const Divider(
                                    color: Colors.black
                                ),
                                Row(
                                    children:[
                                      Image.asset("assets/images/notes.png",
                                          width: 30, height: 30),
                                      const Text(
                                          " Notes",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)
                                      ),
                                    ]
                                ),
                                SizedBox(
                                    height: size.height * .002
                                ),
                                SizedBox(
                                  height: size.height * .0978,
                                  child:
                                  SingleChildScrollView(
                                    child:
                                    Text(
                                        userNote,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15)
                                    ),
                                  ),
                                ),
                              ]
                          )
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
