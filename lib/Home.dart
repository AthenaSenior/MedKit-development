import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' as fbDb;
import 'package:med_kit/Scan.dart';
import 'Loader.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static String loggedInUserEmail = "";

  String backgroundImage = "", title= "", userId= "", name = "",
  lastScannedDrugName = "", lastScannedDrugShortDesc = "", lastScannedDrugPic = "",
      secondToLastDrugName = "", secondToLastDrugDesc = "", secondToLastDrugUrl = "",
      thirdToLastDrugName = "", thirdToLastDrugDesc = "", thirdToLastDrugUrl = "",
      fourthToLastDrugName = "", fourthToLastDrugDesc = "", fourthToLastDrugUrl = "",
      fifthToLastDrugName = "", fifthToLastDrugDesc = "", fifthToLastDrugUrl = "",
      sixthToLastDrugName = "",  sixthToLastDrugDesc = "", sixthToLastDrugUrl = "";

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final fbDb.FirebaseDatabase database = fbDb.FirebaseDatabase.instance;

  late Color color;

  fbDb.DatabaseReference ref = fbDb.FirebaseDatabase.instance.ref("UserMedicine");

  var userMedicines = [];

  bool isScannedBefore = false, isLoading = true, lastTwo = false, lastThree = false, lastFour = false, lastFive = false, lastSix = false;


  Future<void> getLoggedInUserInfo()
  async {
    var snapshot = await firestore.collection("Med-Kit User").
    where('email', isEqualTo: loggedInUserEmail).get();
    setState(() {
      name = snapshot.docs[0].get('userName');
    });
    try { // If user has scanned drugs, we execute queries and
      // show them in UI
      fbDb.Query query = ref.orderByChild("UserId").equalTo(
          snapshot.docs[0].get("ID"));
      fbDb.DataSnapshot event = await query.get();
      for (var child in event.children) {
        userMedicines.add(child.value);
      }
      //
      try {
            var medicineId = userMedicines[userMedicines.length - 2]["ScannedDrugId"];
            ref = fbDb.FirebaseDatabase.instance.ref("Drugs").child(
                medicineId.toString());
            event = await ref.get();
            if (event.exists) {
              setState(() {
                var data = Map<String, dynamic>.from(event.value as Map);
                secondToLastDrugName = data["Name"];
                secondToLastDrugDesc = data["ShortDesc"];
                secondToLastDrugUrl = data["PictureUrl"];
                lastTwo = true;
              });
            }

            medicineId = userMedicines[userMedicines.length - 3]["ScannedDrugId"];
            ref = fbDb.FirebaseDatabase.instance.ref("Drugs").child(
                medicineId.toString());
            event = await ref.get();
            if (event.exists) {
              setState(() {
                var data = Map<String, dynamic>.from(event.value as Map);
                thirdToLastDrugName = data["Name"];
                thirdToLastDrugDesc = data["ShortDesc"];
                thirdToLastDrugUrl = data["PictureUrl"];
                lastThree = true;
              });
            }

            medicineId = userMedicines[userMedicines.length - 4]["ScannedDrugId"];
            ref = fbDb.FirebaseDatabase.instance.ref("Drugs").child(
                medicineId.toString());
            event = await ref.get();
            if (event.exists) {
              setState(() {
                var data = Map<String, dynamic>.from(event.value as Map);
                fourthToLastDrugName = data["Name"];
                fourthToLastDrugDesc = data["ShortDesc"];
                fourthToLastDrugUrl = data["PictureUrl"];
                lastFour = true;
              });
            }

            medicineId = userMedicines[userMedicines.length - 5]["ScannedDrugId"];
            ref = fbDb.FirebaseDatabase.instance.ref("Drugs").child(
                medicineId.toString());
            event = await ref.get();
            if (event.exists) {
              setState(() {
                var data = Map<String, dynamic>.from(event.value as Map);
                fifthToLastDrugName = data["Name"];
                fifthToLastDrugDesc = data["ShortDesc"];
                fifthToLastDrugUrl = data["PictureUrl"];
                lastFive = true;
              });
            }

            medicineId = userMedicines[userMedicines.length - 6]["ScannedDrugId"];
            ref = fbDb.FirebaseDatabase.instance.ref("Drugs").child(
                medicineId.toString());
            event = await ref.get();
            if (event.exists) {
              setState(() {
                var data = Map<String, dynamic>.from(event.value as Map);
                sixthToLastDrugName = data["Name"];
                sixthToLastDrugDesc = data["ShortDesc"];
                sixthToLastDrugUrl = data["PictureUrl"];
                lastSix = true;
              });
            }
      }
      catch(error) {
        print("No such element");
      }
      //

      int lastDrug = userMedicines.last["ScannedDrugId"];
      ref = fbDb.FirebaseDatabase.instance.ref("Drugs").child(
          lastDrug.toString());
      event = await ref.get();
      if (event.exists) {
        setState(() {
          isScannedBefore = true;
          var data = Map<String, dynamic>.from(event.value as Map);
          lastScannedDrugPic = data["PictureUrl"];
          lastScannedDrugShortDesc = data["ShortDesc"];
          lastScannedDrugName = data["Name"];
          isLoading = false;
        });
      }
    }
      catch(error) // If user has no drugs, this block executes,
      // we only show the page with no data
      {
        setState(() {
          isLoading = false;
        });
      }
  }

  @override
  void initState() {
    super.initState();
    getLoggedInUserInfo();
  }

  void createUIWithHour()
  {
    var dt = DateTime.now().hour;
    if(dt >= 6 && dt < 12)
    {
      backgroundImage = "assets/images/morning.jpg";
      title = "☀ Good morning, $name!";
      color = Colors.black;
    }
    else if (dt >= 12 && dt < 18)
    {
      backgroundImage = "assets/images/afternoon.jpg";
      title = "☀ Good afternoon, $name!";
      color = Colors.black;
    }
    else if (dt >= 18 && dt < 21)
    {
      backgroundImage = "assets/images/evening.jpg";
      title = "🌙 Good evening, $name!";
      color = Colors.white;
    }
    else if (dt >= 21 || dt < 6)
    {
      backgroundImage = "assets/images/night.jpg";
      title = "🌙 Good night, $name!";
      color = Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          Container(
          height: size.height * .1,
              width: size.width * .95,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            child:
            Visibility(
              visible: isScannedBefore,
                child:
                Row(
                  children:[
                    Column(
                    children:[
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                              Text(
                                  "$title\nHow can I help you today?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: color,
                                      fontSize: 21)
                              ),
                      ],
                    ),
                   /* SizedBox(
                        width: size.height * .05
                    ),
                    Image.asset("assets/images/medkit_logo.png",
                        width: 60, height: 60)*/
                    ],
                    ),
            ),
          ),
            Visibility(
              visible: isScannedBefore,
              child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: size.height * .295,
                  width: size.width * .95,
                  decoration: BoxDecoration(
                      color: Colors.white70.withOpacity(.75),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                     ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                               width: size.width * .01
                              ),
                          const Text(
                              "My Last Scan",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26)
                          )
                              ],
                          ),
                          SizedBox(
                             height: size.height * .02
                          ),
                        Column(
                              children: [
                                  Row(
                                    children:[
                                      Column(
                                        children: [
                                          Container(
                                              constraints: BoxConstraints(minWidth: size.width * .20, maxWidth: size.height * .2684),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: Column(
                                                children: [
                                                  Align(
                                                      alignment: Alignment.centerLeft,
                                                      child:
                                                      Text(
                                                          lastScannedDrugName,
                                                          style: const TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.bold)
                                                      )
                                                  ),
                                                  SizedBox(
                                                      height: size.height * .02
                                                  ),
                                                Align(
                                                    alignment: Alignment.centerLeft,
                                                    child:
                                                    Text(
                                                        lastScannedDrugShortDesc.replaceAll("<", "\n\n"),
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12)
                                                    )
                                                ),
                                                ]
                                              ),
                                          ),
                                            ],
                                            ),
                                            Image.network(lastScannedDrugPic,
                                                width: 130, height: 120),
                                            ],
                                ),
                                SizedBox(
                                    height: size.height * .003
                                ),
                                const Align(
                                    alignment: Alignment.centerRight,
                                    child:
                                    Text(
                                        "DETAIL >>",
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold)
                                    )
                                ),
                                SizedBox(
                                    height: size.height * .009
                                ),
                                ],
                              )
                        ],
                    ),
                  ),
                ),
              ),
            ),
            ),
            SizedBox(
                height: size.height * .01
            ),
          Visibility(
            visible: isScannedBefore,
                child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: size.height * .495,
                  width: size.width * .95,
                  decoration: BoxDecoration(
                    color: Colors.white70.withOpacity(.85),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                                width: size.width * .01
                            ),
                            const Text(
                                "Last Five Medicines",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 26)
                            )
                          ],
                        ),
                        SizedBox(
                            height: size.height * .02
                        ),
                  SizedBox(
                     height: size.height * .408,
                    child:
                  SingleChildScrollView(
                    child:
                        Column(
                          children: [
                            Row(
                              children:[
                                Column(
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(minWidth: size.width * .20, maxWidth: size.height * .2684),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Column(
                                          children: [
                                             Align(
                                                alignment: Alignment.centerLeft,
                                                child:
                                                Text(
                                                    secondToLastDrugName,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold)
                                                )
                                            ),
                                            SizedBox(
                                                height: size.height * .02
                                            ),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child:
                                                Text(
                                                    secondToLastDrugDesc.replaceAll("<", "\n"),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10)
                                                )
                                            ),
                                          ]
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: lastTwo,
                                child:
                                Image.network(secondToLastDrugUrl,
                                    width: 90, height: 90),),
                              ],
                            ),
                            SizedBox(
                                height: size.height * .003
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child:
                                    Visibility(
                                      visible: lastTwo,
                                child:
                                const Text(
                                    "DETAIL >>",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)
                                )
                                    ),
                            ),
                            SizedBox(
                                height: size.height * .009
                            ),

                            Row(
                              children:[
                                Column(
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(minWidth: size.width * .20, maxWidth: size.height * .2684),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Column(
                                          children: [
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child:
                                                Text(
                                                   thirdToLastDrugName,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold)
                                                )
                                            ),
                                            SizedBox(
                                                height: size.height * .02
                                            ),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child:
                                                Text(
                                                    thirdToLastDrugDesc.replaceAll("<", "\n"),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10)
                                                )
                                            ),
                                          ]
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: lastThree,
                                  child:
                                  Image.network(thirdToLastDrugUrl,
                                      width: 90, height: 90),),
                              ],
                            ),
                            SizedBox(
                                height: size.height * .003
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child:
                              Visibility(
                                  visible: lastThree,
                                  child:
                                  const Text(
                                      "DETAIL >>",
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)
                                  )
                              ),
                            ),
                            SizedBox(
                                height: size.height * .009
                            ),

                            Row(
                              children:[
                                Column(
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(minWidth: size.width * .20, maxWidth: size.height * .2684),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Column(
                                          children: [
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child:
                                                Text(
                                                    fourthToLastDrugName,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold)
                                                )
                                            ),
                                            SizedBox(
                                                height: size.height * .02
                                            ),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child:
                                                Text(
                                                    fourthToLastDrugDesc.replaceAll("<", "\n"),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10)
                                                )
                                            ),
                                          ]
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: lastFour,
                                  child:
                                  Image.network(fourthToLastDrugUrl,
                                      width: 90, height: 90),),
                              ],
                            ),
                            SizedBox(
                                height: size.height * .003
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child:
                              Visibility(
                                  visible: lastFour,
                                  child:
                                  const Text(
                                      "DETAIL >>",
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)
                                  )
                              ),
                            ),
                            SizedBox(
                                height: size.height * .009
                            ),

                            Row(
                              children:[
                                Column(
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(minWidth: size.width * .20, maxWidth: size.height * .2684),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Column(
                                          children: [
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child:
                                                Text(
                                                    fifthToLastDrugName,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold)
                                                )
                                            ),
                                            SizedBox(
                                                height: size.height * .02
                                            ),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child:
                                                Text(
                                                    fifthToLastDrugDesc.replaceAll("<", "\n"),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10)
                                                )
                                            ),
                                          ]
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: lastFive,
                                  child:
                                  Image.network(fifthToLastDrugUrl,
                                      width: 90, height: 90),),
                              ],
                            ),
                            SizedBox(
                                height: size.height * .003
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child:
                              Visibility(
                                  visible: lastFive,
                                  child:
                                  const Text(
                                      "DETAIL >>",
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)
                                  )
                              ),
                            ),
                            SizedBox(
                                height: size.height * .009
                            ),

                            Row(
                              children:[
                                Column(
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(minWidth: size.width * .20, maxWidth: size.height * .2684),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Column(
                                          children: [
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child:
                                                Text(
                                                    sixthToLastDrugName,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold)
                                                )
                                            ),
                                            SizedBox(
                                                height: size.height * .02
                                            ),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child:
                                                Text(
                                                    sixthToLastDrugDesc.replaceAll("<", "\n"),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10)
                                                )
                                            ),
                                          ]
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: lastSix,
                                  child:
                                  Image.network(sixthToLastDrugUrl,
                                      width: 90, height: 90),),
                              ],
                            ),
                            SizedBox(
                                height: size.height * .003
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child:
                              Visibility(
                                  visible: lastSix,
                                  child:
                                  const Text(
                                      "DETAIL >>",
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)
                                  )
                              ),
                            ),
                            SizedBox(
                                height: size.height * .009
                            ),
                          ],
                        )
                  ),
                  ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
            SizedBox(
              height: size.height * 0.005
            ),
            Visibility(
              visible: !isScannedBefore,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: size.height * .55,
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
                                  height: size.height * .125
                              ),
                              Text(
                                  "Looks like you have not scanned\nany medicine yet, $name 🤭",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17)
                              ),
                              SizedBox(
                                  height: size.height * .02
                              ),
                              const Text(
                                  "Luckily, you have me!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17)
                              ),
                              SizedBox(
                                  height: size.height * .02
                              ),
                              Image.asset("assets/images/medkit_logo.png",
                               width: 90, height: 90),
                              SizedBox(
                                  height: size.height * .04
                              ),
                              ElevatedButton(
                                onPressed: () {Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const Scan()));},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  minimumSize: const Size(170, 70),
                                ),
                                child: const Text("📸 Let's scan!", style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17)),
                              ),
                            ]
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