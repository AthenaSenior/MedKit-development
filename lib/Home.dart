import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' as fbDb;
import 'package:med_kit/Scan.dart';
import 'DrugDetail.dart';
import 'Loader.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.loggedInUserKey});

  final String loggedInUserKey;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final fbDb.FirebaseDatabase database = fbDb.FirebaseDatabase.instance;
  fbDb.DatabaseReference ref = fbDb.FirebaseDatabase.instance.ref("UserMedicine");
  // Firebase variables

  static bool registeredForFirstTime = false;

  String backgroundImage = "", title = "", userId = "", name = "", initialTextOne = "", initialTextTwo = "";
  // String variables for UI

  var userMedicines = [], drugNames = [], drugShortDescriptions = [],
      drugPictures = [], drugLongDescriptions = [], drugVisibilities = [false, false, false, false, false, false];
  // Data storages

  bool isScannedBefore = false, isLoading = true, lastFiveDrugsSectionActive = true;
  // State manager flag(s)

  Future<void> getLoggedInUserInfo()
  async {

    // Query user by his/her e-mail
    // E-mail is can be considered as unique key
    // Primary key is ID @Egemen
    var snapshot;

    while (true){
      try{
        snapshot = await firestore.collection("Med-Kit User").
        where('email', isEqualTo: widget.loggedInUserKey).get();
        setState(() {
          name = snapshot.docs[0].get('userName');
        });
        break;
      }
      catch(error) // If user query fail @Egemen
          {
        continue;
      }
    }
    try {

        // If queried user has scanned drugs, we execute queries and
        // show them in UI @Egemen

        fbDb.Query query = ref.orderByChild("UserId").equalTo(
            snapshot.docs[0].get("ID"));
        fbDb.DataSnapshot event = await query.get();
        for (var child in event.children) {
          userMedicines.add(child.value);
        }

        // If user scanned at least one drug @Egemen

        if(userMedicines.isNotEmpty) {
          setState(() {
            isScannedBefore = true;
          });
          for (int i = 1; i < 7; i++) {
            try{
              var medicineId = userMedicines[userMedicines.length -
                  i]["ScannedDrugId"];
              ref = fbDb.FirebaseDatabase.instance.ref("Drugs").child(
                  medicineId.toString());
              event = await ref.get();
              if (event.exists) { // Add each drug belongs to user to list
                setState(() {
                  var data = Map<String, dynamic>.from(event.value as Map);
                  drugNames.add(data["Name"]);
                  drugShortDescriptions.add(data["ShortDesc"]);
                  drugPictures.add(data["PictureUrl"]);
                  drugLongDescriptions.add(data ["LongDesc"]);
                  drugVisibilities[i - 1] = true;
                });
              }
            }
          catch(error) {// If user scanned less than 6 drugs,
              // Add empty data to list to block NullPointerException
              // (This means user see nothing in
              // corresponding rows if they scanned less than five drugs) @Egemen
              setState(() {
                if(i == 2) {
                  lastFiveDrugsSectionActive = false;
                }
              drugNames.add(' ');
              drugShortDescriptions.add(' ');
              drugPictures.add(' ');
              drugLongDescriptions.add(' ');
              drugVisibilities[i - 1] = false;
              });
            }
          }
          print(drugNames);
        }

        else{ // If user scanned no drugs, then no drugs will be queried. @Egemen
          // Change the state.
          isScannedBefore = false;
        }

        setState(() { // In both cases, finally close the loader. @Egemen
          isLoading = false;
        });

        }
      catch(error) // If user query fail @Egemen
      {
        isLoading = false;
        print("User query failed.");
      }
  }

  @override
  void initState() {
    super.initState();
    getLoggedInUserInfo(); // Execute the function as initial state @Egemen
  }

  void createUIWithHour() // UI Operations @Egemen
  {
    var dt = DateTime.now().hour;
    if(dt >= 6 && dt < 12)
    {
      backgroundImage = "assets/images/morning.jpg";
      title = "☀ Good morning, $name!";
    }
    else if (dt >= 12 && dt < 18)
    {
      backgroundImage = "assets/images/afternoon.jpg";
      title = "☀ Good afternoon, $name!";
    }
    else if (dt >= 18 && dt < 21)
    {
      backgroundImage = "assets/images/evening.jpg";
      title = "🌙 Good evening, $name!";
    }
    else if (dt >= 21 || dt < 6)
    {
      backgroundImage = "assets/images/night.jpg";
      title = "🌙 Good night, $name!";
    }

    if(registeredForFirstTime)
      {
        initialTextOne = "Welcome, $name! \n\nI've been prepared perfectly to help you!";
        initialTextTwo = "You can navigate other pages to explore me.";
      }
    else{
      initialTextOne = "Looks like you have not scanned\nany medicine yet, $name 🤭";
      initialTextTwo = "Luckily, you have me!";
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
                      Container(
                          color: Colors.black.withOpacity(0.25),
                          width: size.width * .95,
                          child:
                          Align(
                            alignment: Alignment.centerLeft,
                            child:
                            Text(
                            "$title\nHow can I help you today?",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 21)
                      ),
                      ),
                      ),
                      ],
                    ),
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
                             height: size.height * .01
                          ),
                          Visibility(
                            visible: drugVisibilities[1],
                            child:
                            const Divider(
                                color: Colors.black
                            ),
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
                                                          drugNames.isNotEmpty ? drugNames[0] : 'No Medicine',
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
                                                        drugShortDescriptions.isNotEmpty ? drugShortDescriptions[0].replaceAll("<", "\n\n") : 'No Medicine',
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
                                            Image.network(drugPictures.isNotEmpty ? drugPictures[0] : 'No Medicine',
                                                width: 130, height: 120),
                                            ],
                                ),
                                SizedBox(
                                    height: size.height * .0050
                                ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child:
                                    TextButton(
                                      onPressed: () => {
                                          Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                          builder: (context) =>
                                          DrugDetail(drugName: drugNames[0], drugPicture: drugPictures[0], drugLongDesc: drugLongDescriptions[0]))),
                                      },
                                      child: const Text('DETAIL >>',
                                        style: TextStyle(
                                            fontSize: 21,
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                ),
                                SizedBox(
                                    height: size.height * .001
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
            visible: isScannedBefore && lastFiveDrugsSectionActive,
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
                                                    drugNames.isNotEmpty ? drugNames[1] : 'No Medicine',
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
                                                    drugShortDescriptions.isNotEmpty ? drugShortDescriptions[1].replaceAll("<", "\n") : 'No Medicine Description',
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
                                  visible: drugVisibilities[1],
                                child:
                                Image.network(drugPictures.isNotEmpty ? drugPictures[1] : '',
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
                                visible: drugVisibilities[1],
                                child:
                                TextButton(
                                  onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DrugDetail(drugName: drugNames[1], drugPicture: drugPictures[1], drugLongDesc: drugLongDescriptions[1]))),
                                  },
                                  child: const Text('DETAIL >>',
                                    style: TextStyle(
                                        fontSize: 21,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: drugVisibilities[1],
                                  child:
                                  const Divider(
                                      color: Colors.black
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
                                                    drugNames.isNotEmpty ? drugNames[2] : 'No Medicine',
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
                                                    drugShortDescriptions.isNotEmpty ? drugShortDescriptions[2].replaceAll("<", "\n") : '',
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
                                  visible: drugVisibilities[2],
                                  child:
                                  Image.network(drugPictures.isNotEmpty ? drugPictures[2] : '',
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
                                visible: drugVisibilities[2],
                                child:
                                TextButton(
                                  onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DrugDetail(drugName: drugNames[2], drugPicture: drugPictures[2], drugLongDesc: drugLongDescriptions[2]))),
                                  },
                                  child: const Text('DETAIL >>',
                                    style: TextStyle(
                                        fontSize: 21,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: drugVisibilities[2],
                              child:
                              const Divider(
                                  color: Colors.black
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
                                                    drugNames.isNotEmpty ? drugNames[3] : 'No Medicine',
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
                                                    drugShortDescriptions.isNotEmpty ? drugShortDescriptions[3].replaceAll("<", "\n") : '',
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
                                  visible: drugVisibilities[3],
                                  child:
                                  Image.network(drugPictures.isNotEmpty ? drugPictures[3] : '',
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
                                visible: drugVisibilities[3],
                                child:
                                TextButton(
                                  onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DrugDetail(drugName: drugNames[3], drugPicture: drugPictures[3], drugLongDesc: drugLongDescriptions[3]))),
                                  },
                                  child: const Text('DETAIL >>',
                                    style: TextStyle(
                                        fontSize: 21,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: drugVisibilities[3],
                              child:
                              const Divider(
                                  color: Colors.black
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
                                                    drugNames.isNotEmpty ? drugNames[4] : 'No Medicine',
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
                                                    drugShortDescriptions.isNotEmpty ? drugShortDescriptions[4].replaceAll("<", "\n") : '',
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
                                  visible: drugVisibilities[4],
                                  child:
                                  Image.network(drugPictures.isNotEmpty ? drugPictures[4] : '',
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
                                visible: drugVisibilities[4],
                                child:
                                TextButton(
                                  onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DrugDetail(drugName: drugNames[4], drugPicture: drugPictures[4], drugLongDesc: drugLongDescriptions[4]))),
                                  },
                                  child: const Text('DETAIL >>',
                                    style: TextStyle(
                                        fontSize: 21,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: drugVisibilities[4],
                              child:
                              const Divider(
                                  color: Colors.black
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
                                                    drugNames.isNotEmpty ? drugNames[5] : 'No Medicine',
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
                                                    drugShortDescriptions.isNotEmpty ? drugShortDescriptions[5].replaceAll("<", "\n") : '',
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
                                  visible: drugVisibilities[5],
                                  child:
                                  Image.network(drugPictures.isNotEmpty ? drugPictures[5] : '',
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
                                visible: drugVisibilities[5],
                                child:
                                TextButton(
                                  onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DrugDetail(drugName: drugNames[5], drugPicture: drugPictures[5], drugLongDesc: drugLongDescriptions[5]))),
                                  },
                                  child: const Text('DETAIL >>',
                                    style: TextStyle(
                                        fontSize: 21,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: drugVisibilities[5],
                              child:
                              const Divider(
                                  color: Colors.black
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
                                  height: size.height * .035
                              ),
                              Text(
                                  initialTextOne,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17)
                              ),
                              SizedBox(
                                  height: size.height * .05
                              ),
                              Text(
                                  initialTextTwo,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17)
                              ),
                              SizedBox(
                                  height: size.height * .07
                              ),
                              Image.asset("assets/images/medkit_logo.png",
                               width: 90, height: 90),
                              SizedBox(
                                  height: size.height * .07
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