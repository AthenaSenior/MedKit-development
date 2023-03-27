import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' as fbDb;
import 'package:med_kit/Main.dart';
import 'package:med_kit/service/auth.dart';
import 'Loader.dart';
import 'LoginPage.dart';

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
  CollectionReference users = FirebaseFirestore.instance.collection('Med-Kit User');
  final AuthService _authService = AuthService();
  // Firebase variables

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final notesController = TextEditingController();
  // Text Controllers for edit profile section to save data

  List<String> list = <String>['Male', 'Female', 'Other'];
  String dropdownValue = '';
  late IconData icon;
  int userMedicines = 0;
  bool isLoading = true, isView = true, isEdit = false;
  static bool error = false;
  static String errorMessage = "";
  String backgroundImage = "";
  String userDocumentUID = "", gender = "", userName = "", userNote = "", totalScannedDrugs = "0", registerDate = "null";
  String userPicture = "";
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
      userDocumentUID = snapshot.docs[0].reference.id; // We will use this document id to update profile
      userName = snapshot.docs[0].get('userName');
      userNote = snapshot.docs[0].get('note');
      registerDate = snapshot.docs[0].get('date');
      gender = snapshot.docs[0].get('gender');
      totalScannedDrugs = userMedicines.toString();
      nameController.text = userName;
      emailController.text =  snapshot.docs[0].get('email');
      dropdownValue = gender;
      notesController.text = userNote;

      // Set values

      if(userNote == '') // Set default user note if no note
        {
          userNote = "\n\nYou have no notes yet. Add some to remind yourself daily!";
        }
      switch(gender) // Set user pic
      {
        case "Male":
          {
            userPicture = "assets/images/maleUser.png";
            icon = Icons.male_rounded;
            break;
          }
        case "Female":
          {
            userPicture = "assets/images/femaleUser.png";
            icon = Icons.female_rounded;
            break;
          }
        default:
          {
            userPicture = "assets/images/otherGenderUser.png";
            icon = Icons.transgender_rounded;
            break;
          }
      }
      isLoading = false;
    });
    }

  @override
  void initState() {
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

  Future<void> _showUserDataUpdateSuccessfulDialog(bool isAuthChange) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Operation Successful'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Your information has successfully updated.\n'),
                Text(isAuthChange ? 'E-mail or password changes requires re-login. You will be redirected to the login page.' : ''),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                if(!isAuthChange) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => MainPage(pageId: 1)));
                }
                else{
                  _authService.signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showUserDataUpdateFailureDialog(String errorMessage) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Operation Failed'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Your request could not be processed due below error.\n'),
                Text(errorMessage),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
            Visibility(
              visible: isView,
            child:
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
                    SizedBox(
                      height: size.height * .444,
                      child:
                      SingleChildScrollView(
                        child:
                    Column(
                        children: [
                          SizedBox(
                            width: size.width * 90,
                          child:
                          Row(
                            children:[
                              Image.asset(userPicture,
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
                                  width: size.width * .45
                              ),
                              ElevatedButton.icon(
                                onPressed: () => {
                                  setState(() {
                                    isView = false;
                                    isEdit = true;
                                  })
                                },
                                icon: const Icon( // <-- Icon
                                  Icons.settings,
                                  size: 24.0,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black, // Background color
                                ),
                                label: const Text('SETTINGS',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ), // <-- Text
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
            ),
    )
    ),
            Visibility(
              visible: isEdit,
              child:
              Center(
                child: Column(
                  children: [
                    Row(
                        children:[
                          IconButton(
                            onPressed: () => {
                              setState(() {
                                isView = true;
                                isEdit = false;
                              })
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_outlined,
                              color: Colors.black,
                              size: 25,
                            ),
                          ),
                          const Text(
                              "Back to profile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25)
                          ),
                        ]
                    ),
                    SizedBox(
                        height: size.height * .02
                    ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: size.height * .78,
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
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                              children:[
                                Image.asset("assets/images/settings2.png",
                                    width: 25, height: 25),
                                SizedBox(
                                    width: size.width * .025
                                ),
                                const Text(
                                    "Set Your Profile",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold)
                                ),
                              ]
                            ),
                            SizedBox(
                                height: size.height * .025
                            ),
                            const Divider(
                                color: Colors.black
                            ),
                            SizedBox(
                                height: size.height * .015
                            ),
                          SizedBox(
                          height: size.height * .64,
                          child:
                          SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child:
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                    "Your full name",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20)
                                ),
                                const Text(
                                    "Change your full name any time you wish.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)
                                ),
                                SizedBox(
                                    height: size.height * .03,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                  children:[
                                    SizedBox(
                                        width: size.width * .40,
                                        height: size.height * .06,
                                        child:
                                        TextField(
                                          controller: nameController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Full Name',
                                          ),
                                        )
                                    ),
                                    SizedBox(
                                        width: size.width * .07,
                                    ),
                                    SizedBox(
                                      width: size.width * .28,
                                      height: size.height * .05,
                                    child:
                                    ElevatedButton.icon(
                                      onPressed: () => {
                                        setState(() {
                                          if(nameController.text.isEmpty)
                                            {
                                              _showUserDataUpdateFailureDialog("Name should not be empty.");
                                            }
                                          else if(nameController.text.length < 7)
                                            {
                                              _showUserDataUpdateFailureDialog("Name length should be more than 6 characters.");
                                            }
                                          else{
                                          users.doc(userDocumentUID)
                                              .update({'userName': nameController.text})
                                              .then((value) =>
                                              _showUserDataUpdateSuccessfulDialog(false));
                                            }
                                          })
                                        },
                                      icon: const Icon( // <-- Icon
                                        Icons.save,
                                        size: 24.0,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black, // Background color
                                      ),
                                      label: const Text('Save',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ), // <-- Text
                                    ),
                                    )
                                  ]
                                ),
                            const Divider(
                              color: Colors.black
                            ),
                            SizedBox(
                                height: size.height * .025
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                      "Your e-mail address",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20)
                                  ),
                                  const Text(
                                      "Change your e-mail instantly.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)
                                  ),
                                  SizedBox(
                                    height: size.height * .025,
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children:[
                                        SizedBox(
                                            width: size.width * .40,
                                            height: size.height * .075,
                                            child:
                                            TextField(
                                              controller: emailController,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'E-mail Address',
                                              ),
                                            )
                                        ),
                                        SizedBox(
                                          width: size.width * .07,
                                        ),
                                        SizedBox(
                                          width: size.width * .28,
                                          height: size.height * .05,
                                          child:
                                          ElevatedButton.icon(
                                            onPressed: () => {
                                              setState(() {
                                                _authService
                                                    .updateUserAuthInformationEmail(
                                                    emailController.text).then((value) {
                                                  if(!error)
                                                  {
                                                    users.doc(userDocumentUID)
                                                        .update({'email': emailController.text})
                                                        .then((value) =>
                                                        _showUserDataUpdateSuccessfulDialog(true));
                                                  }
                                                  else{
                                                    return _showUserDataUpdateFailureDialog(errorMessage);
                                                  }
                                                });
                                              }),
                                            },
                                            icon: const Icon( // <-- Icon
                                              Icons.save,
                                              size: 24.0,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black, // Background color
                                            ),
                                            label: const Text('Save',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ), // <-- Text
                                          ),
                                        )
                                      ]
                                  )

                                ]
                            ),
                            SizedBox(
                              height: size.height * .01,
                            ),
                            const Divider(
                                color: Colors.black
                            ),
                            SizedBox(
                                height: size.height * .01
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                      "Password",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20)
                                  ),
                                  const Text(
                                      "Change your password in any time.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)
                                  ),
                                  SizedBox(
                                    height: size.height * .02,
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children:[
                                        SizedBox(
                                            width: size.width * .40,
                                            height: size.height * .06,
                                            child:
                                            TextField(
                                              controller: oldPasswordController,
                                              obscureText: true,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Old Password',
                                              ),
                                            )
                                        ),
                                        SizedBox(
                                          width: size.width * .1,
                                        ),
                                        SizedBox(
                                          width: size.width * .25,
                                          height: size.height * .05,
                                        )
                                      ]
                                  ),
                                  SizedBox(
                                    height: size.height * .02,
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children:[
                                        SizedBox(
                                            width: size.width * .40,
                                            height: size.height * .06,
                                            child:
                                            TextField(
                                              controller: newPasswordController,
                                              obscureText: true,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'New Password',
                                              ),
                                            )
                                        ),
                                        SizedBox(
                                          width: size.width * .07,
                                        ),
                                        SizedBox(
                                          width: size.width * .28,
                                          height: size.height * .05,
                                          child:
                                          ElevatedButton.icon(
                                            onPressed: () => {
                                              setState(() {
                                                _authService
                                                    .changePassword(
                                                    oldPasswordController.text, newPasswordController.text).then((value) {
                                                      if(!error)
                                                        {
                                                          return _showUserDataUpdateSuccessfulDialog(true);
                                                        }
                                                      else{
                                                        return _showUserDataUpdateFailureDialog(errorMessage);
                                                      }
                                                });
                                              }),
                                            },
                                            icon: const Icon( // <-- Icon
                                              Icons.save,
                                              size: 24.0,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black, // Background color
                                            ),
                                            label: const Text('Save',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ), // <-- Text
                                          ),
                                        )
                                      ]
                                  ),
                                  SizedBox(
                                    height: size.height * .01,
                                  ),
                                  const Divider(
                                      color: Colors.black,
                                  ),
                                  SizedBox(
                                      height: size.height * .01
                                  ),
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                            "Your gender",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20)
                                        ),
                                        const Text(
                                            "You can change your gender selection by this section.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)
                                        ),
                                        SizedBox(
                                          height: size.height * .025,
                                        ),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children:[
                                              SizedBox(
                                                  width: size.width * .2,
                                                  height: size.height * .06,
                                                  child:
                                                  DropdownButton<String>(
                                                    value: dropdownValue,
                                                    icon: const Icon(Icons.arrow_downward),
                                                    elevation: 14,
                                                    style: const TextStyle(color: Colors.black),
                                                    underline: Container(
                                                      height: 3,
                                                      width: 45,
                                                      color: Colors.white60,
                                                    ),
                                                    onChanged: (String? value) {
                                                      // This is called when the user selects an item.
                                                      setState(() {
                                                        dropdownValue = value!;
                                                        if(dropdownValue == 'Male') {
                                                          icon = Icons.male_rounded;
                                                        } else if(dropdownValue == 'Female'){
                                                          icon = Icons.female_rounded;
                                                        }
                                                        else{
                                                          icon = Icons.transgender_rounded;
                                                        }
                                                      });
                                                    },
                                                    items: list.map<DropdownMenuItem<String>>((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                              ),
                                              SizedBox(
                                                width: size.width * .07,
                                              ),
                                              Icon(
                                                icon,
                                                color: Colors.black,
                                              ),
                                              SizedBox(
                                                width: size.width * .07,
                                              ),
                                              SizedBox(
                                                width: size.width * .28,
                                                height: size.height * .05,
                                                child:
                                                ElevatedButton.icon(
                                                  onPressed: () => {
                                                    setState(() {
                                                      users.doc(userDocumentUID)
                                                          .update({'gender': dropdownValue})
                                                          .then((value) => _showUserDataUpdateSuccessfulDialog(false))
                                                          .catchError((error) => _showUserDataUpdateFailureDialog(error));
                                                    })
                                                  },
                                                  icon: const Icon( // <-- Icon
                                                    Icons.save,
                                                    size: 24.0,
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.black, // Background color
                                                  ),
                                                  label: const Text('Save',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold),
                                                  ), // <-- Text
                                                ),
                                              )
                                            ]
                                        )

                                      ]
                                  ),
                                  SizedBox(
                                    height: size.height * .02,
                                  ),
                                ]
                            ),
                            const Divider(
                                color: Colors.black
                            ),
                                SizedBox(
                                    height: size.height * .01
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                          "Your notes",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20)
                                      ),
                                      const Text(
                                          "Update your daily notes by this section.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)
                                      ),
                                      SizedBox(
                                        height: size.height * .02,
                                      ),
                                      Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children:[
                                            SizedBox(
                                                width: size.width * .70,
                                                height: size.height * .15,
                                                child:
                                                TextField(
                                                  controller: notesController,
                                                  keyboardType: TextInputType.multiline,
                                                  maxLines: 4,
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Notes',
                                                  ),
                                                )
                                            ),
                                            SizedBox(
                                              height: size.height * .02,
                                            ),
                                            SizedBox(
                                              width: size.width * .28,
                                              height: size.height * .05,
                                              child:
                                              ElevatedButton.icon(
                                                onPressed: () => {
                                                  setState(() {
                                                    users.doc(userDocumentUID)
                                                        .update({'note': notesController.text})
                                                        .then((value) => _showUserDataUpdateSuccessfulDialog(false))
                                                        .catchError((error) => _showUserDataUpdateFailureDialog(error));
                                                  })
                                                },
                                                icon: const Icon( // <-- Icon
                                                  Icons.save,
                                                  size: 24.0,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.black, // Background color
                                                ),
                                                label: const Text('Save',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold),
                                                ), // <-- Text
                                              ),
                                            )
                                          ]
                                      )

                                    ]
                                ),
                            ]
                          ),
                          ),
                          )
                          )
                            ],
                  ),
                 ),
                  ),
                ),
              ],
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
