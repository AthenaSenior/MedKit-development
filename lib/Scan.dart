import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:med_kit/Home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_database/firebase_database.dart';
import 'DrugDetail.dart';
import 'Loader.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});
  @override
  State<Scan> createState() => _ScanState();

}

class _ScanState extends State<Scan> with WidgetsBindingObserver{
  bool _isPermissionGranted = false;
  late final Future<void> _future;
  CameraController? _cameraController;
  final _textRecognizer = TextRecognizer();
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref("Drugs");
  List<String> drugs = [], drugNames = [];
  bool isLoading = true, isScanning = false;

  Future<void> getAllDrugs()
  async {

    Query query = ref.orderByChild("Name");
    DataSnapshot event = await query.get();

    for (var child in event.children) {
      drugs.add(child.child("Name").value.toString());
      drugNames.add(child.child("ScanName").value.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _future = _requestCameraPermission();
    getAllDrugs();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive){
      _stopCamera();
    } else if (state == AppLifecycleState.resumed && _cameraController != null && _cameraController!.value.isInitialized){
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context){
    var size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          return isLoading ? const Scaffold(
            body: Loader(),
          ) :
          Stack(
              children: <Widget>[
              Positioned.fill(
              child: IgnorePointer(
              ignoring: isLoading,
              child: Opacity(
              opacity: isLoading ? 0.2 : 1.0,
              child: Builder(builder: (context) {
                return Container(
                  height: size.width * 2.2,
                  width: size.height * 2.2,
                  color: Colors.black,
                  child: Stack(
                    children: [
                      if (_isPermissionGranted)
                        FutureBuilder<List<CameraDescription>>(
                          future: availableCameras(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              _initCameraController(snapshot.data!);
                              return Column(
                                  children: [
                                    SizedBox(
                                        height: size.height * 0.035
                                    ),
                                    Row(
                                        children: [
                                          Image.asset(
                                              'assets/images/medicine.png',
                                              width: 50, height: 50),
                                          const SizedBox(
                                              width: 10
                                          ),
                                          const Text(
                                            "Make sure that the name of your \nmedicine is fully visible on the screen.",
                                            style: TextStyle(fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ]
                                    ),
                                    Center(child: CameraPreview(
                                        _cameraController!))
                                  ]
                              );
                            } else {
                              return const LinearProgressIndicator();
                            }
                          },
                        ),
                      Scaffold(
                        backgroundColor: _isPermissionGranted ? Colors
                            .transparent : null,
                        body: _isPermissionGranted
                            ? Column(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 70.0),
                              child: ElevatedButton(
                                onPressed: _scanImage,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    )
                                ),
                                child: Image.asset(
                                    'assets/images/medkit_logo.png',
                                    width: 100, height: 100),
                              ),
                            )
                          ],
                        )
                            : Center(
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 24.0, right: 24.0,),
                            child: const Text("Camera Permission Denied",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      isScanning
                          ? ModalBarrier(
                        color: Colors.black54.withOpacity(0.6),
                        dismissible: false,
                      )
                          : const SizedBox(),
                      // Yükleniyor göstergesi
                      isScanning
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : const SizedBox(),
                    ],
                  ),
                );
              }),
          ),
          ),
          ),
          ],
          );
        });

  }

  Future<void> _requestCameraPermission() async{
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;

  }

  void _startCamera() {
    if (_cameraController != null){
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if ( _cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras){
    if (_cameraController != null){
      return;
    }

    // Select the first camera
    CameraDescription? camera;
    for (var i=0; i< cameras.length; i++){
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back){
        camera=current;
        break;
      }
    }
    if (camera != null){
      _cameraSelected(camera);
    }

  }

  Future<void> _cameraSelected(CameraDescription camera) async{
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );
    await _cameraController?.initialize();

    if(!mounted){
      return;
    }
    setState(() {});

  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;

    try {
      setState(() {
        isScanning = true;
      });
      final pictureFile = await _cameraController!.takePicture();

      final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      _queryText(recognizedText.text);
    } catch (e) {
      print(e);
      print("Hata!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
      setState(() {
        isScanning = false;
      });
    }
  }

  Future<void> _queryText(String scannedText)
  async {
    String scannedDrugName = "", scannedDrugShortDesc = "", scannedDrugLongDesc = "", scannedDrugPictureUrl = "", scannedDrugId = "";

    final splittedScans = scannedText.split(' ');

    List<String> finalSplittedScans = [];

    for (String splittedScan in splittedScans) {
      List<String> parts = splittedScan.split('\n');
      finalSplittedScans.addAll(parts);
    }


    List<String> lowerCaseDrugNames = drugNames.map((word) => word.toLowerCase()).toList();

    for(var word in finalSplittedScans) // little bit complex nested for
    {
      for (var item in drugs) {
        if(item.toLowerCase().contains(word.toLowerCase()) && lowerCaseDrugNames.contains(word.toLowerCase())){
          scannedDrugName = item;
          break; //  Documentation: https://i.kym-cdn.com/entries/icons/mobile/000/032/031/man.jpg
        }
      }
    }

    if(scannedDrugName == "")
      {
        setState(() {
          isScanning = false;
        });
      }

    try{
      Query query = ref.orderByChild("Name").equalTo(scannedDrugName);
      DataSnapshot event = await query.get();

      if(event.exists)
      {
        setState(() {
          var data = Map<String, dynamic>.from(event.value as Map);
          scannedDrugId = data.keys.first;
          scannedDrugShortDesc = data.values.first["ShortDesc"];
          scannedDrugPictureUrl = data.values.first["PictureUrl"];
          scannedDrugLongDesc = data.values.first["LongDesc"];
          _getScannedDataAndAddNew(scannedDrugId, scannedDrugName, scannedDrugShortDesc, scannedDrugPictureUrl, scannedDrugLongDesc);
        });
      }
    }
    catch(error) {
      _showErrorModal();
      setState(() {
        isScanning = false;
      });
    }
  }

  Future<void> _getScannedDataAndAddNew(String key, String name, String short, String pic, String long) async
  {
    var warningMessage = "";  // This will be replaced via drug to drug alert if exists.
    int counter = 0;
    int drugToDrugCounter = 1;
    var drugs = [];
    try {
      ref = FirebaseDatabase.instance.ref("UserMedicine");
      Query query = ref.orderByChild("ScannedDrugId");
      DataSnapshot event = await query.get();

      for (var child in event.children) {
        counter++;
      }

      ref = FirebaseDatabase.instance.ref("UserDrugToDrug");
      query = ref.orderByChild("UserId");
      event = await query.get();

      for (var child in event.children) {
        drugToDrugCounter++;
      }

      ref = FirebaseDatabase.instance.ref("UserMedicine");
      query = ref.orderByChild("UserId").equalTo(HomePageState.userId);
      event = await query.get();

      for (var child in event.children) {
        drugs.add(child
            .child("ScannedDrugId")
            .value);
      }


      // If the scanned drug is in the last 5 scanned drugs' list, then
      // do not add the same drug to the list. (No duplicate)
      var lastFiveDrugs = drugs.reversed.take(5);

      if (lastFiveDrugs.contains(int.parse(key))) {
        warningMessage = "Warning: You have scanned this drug recently. This medicine will not added to your list again.";
        _showResultModal(name, short, pic, long, warningMessage);
        setState(() {
          isScanning = false;
        });
        return;
      }

      // If no duplicate,

      // Make medicine as last scan of the user
      ref = FirebaseDatabase.instance.ref("UserMedicine/$counter");

      await ref.set({
        "ScannedDrugId": int.parse(key),
        "UserId": HomePageState.userId
      });

      // Check if drug to drug exists in user's scanned medicines. If any drug to drug,
      // add UserDrugToDrug record to show it in profile.

      // First of all, go to drug to drug table
      ref = FirebaseDatabase.instance.ref("DrugToDrug");

      // Get the records that our scanned drug is "FirstMedicineId"
      Query queryFirstMedicine = ref.orderByChild("FirstMedicineId").equalTo(
          int.parse(key));

      // Our scanned drug Id can possibly be targetId. So search by targetId too
      Query queryTargetMedicine = ref.orderByChild("TargetId").equalTo(
          int.parse(key));

      // We have 2 checks so we do the similar operations twice.
      // Firstly, get results of the first query.
      event = await queryFirstMedicine.get();

      if (event.exists) // If our scanned drug is in DrugToDrug table (as firstMedicineId),
          {
        for (var child in event.children) {
          if (drugs.contains(child
              .child("TargetId")
              .value))
            // Then search in all records to find targetId of it has scanned by user.
            // If targetId has scanned by user before, then we can create a UserDrugToDrug record.
            // UserDrugToDrug records shown to user in their profile.
              {
            warningMessage =
            "Warning: The drug you just scanned has an opposite affect with another drug you scanned. Check your profile to see details.";
            ref = FirebaseDatabase.instance.ref(
                "UserDrugToDrug/$drugToDrugCounter");
            for (var child in event.children) {
              Query sameDrugToDrugExist = ref.orderByChild("DrugToDrugId")
                  .equalTo(int.parse(child.key.toString()));
              // In further scans, the drug to drug record can be created again and shown twice in profile.
              // We should avoid it.
              event = await sameDrugToDrugExist.get();
              if (!event.exists) {
                await ref.set({
                  "DrugToDrugId": int.parse(child.key.toString()),
                  "UserId": HomePageState.userId
                });
              }
            }
          }
        }
          }

      // Finally, get results of the second query.
      event = await queryTargetMedicine.get();

      if (event.exists) // If our scanned drug is in DrugToDrug table (as targetId),
          {
        for (var child in event.children) {
          if (drugs.contains(child
              .child("FirstMedicineId")
              .value))
            // Then search in all records to find firstMedicineId of it has scanned by user.
            // If firstMedicineId has scanned by user before, then we can create a UserDrugToDrug record.
            // UserDrugToDrug records shown to user in their profile.
              {
            warningMessage =
            "Warning: The drug you just scanned has an opposite affect with another drug you scanned. Check your profile to see details.";
            ref = FirebaseDatabase.instance.ref(
                "UserDrugToDrug/$drugToDrugCounter");
            for (var child in event.children) {
              Query sameDrugToDrugExist = ref.orderByChild("DrugToDrugId")
                  .equalTo(child.key.toString());
              // In further scans, the drug to drug record can be created again and shown twice in profile.
              // We should avoid it.
              event = await sameDrugToDrugExist.get();
              if (!event.exists) {
                await ref.set({
                  "DrugToDrugId": int.parse(child.key.toString()),
                  "UserId": HomePageState.userId
                });
              }
              else
                {
                  warningMessage = "";
                }
            }
          }
        }
      }
    }
    catch(e)
    {
      setState(() {
        isScanning = false;
      });
    }
    _showResultModal(name, short, pic, long, warningMessage);
    setState(() {
      isScanning = false;
    });
  }

  Future<void> _showResultModal(String name, String short, String pic, String long, String warningMessage) async {
    var size = MediaQuery.of(context).size;
    double? height = 300;
    if(warningMessage.isNotEmpty) {
      height = 400;
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name),
          content: Container(
            color: Colors.white, // Dialog background
            width: size.width, // Dialog width
            height: height, // Dialog height
            child: SingleChildScrollView(
              child: Column(
                  children: [
                        Text(
                            short.replaceAll("<", "\n\n"),
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14)
                        ),
                    Image.network(pic,
                        width: 200, height: 200),
                    const SizedBox(
                      height: 15
                    ),
                    Text(
                        warningMessage,
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14, fontWeight: FontWeight.w400)
                    ),
                  ]
              ),
            ),
        ),
          actions: <Widget>[
            TextButton(
              child: const Text('Detail >>'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DrugDetail(drugName: name, drugPicture: pic, drugLongDesc: long)));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showErrorModal() async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sorry!"),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("I cannot handle your request. \nOne of these may happened: \n\n - I do not have this medicine on my database \n\n - Unexpected exception occured (Try to go home page and come back to scan again) \n\n - Internet connection lost \n\n - I know this medicine but I cannot read it, show me more clearly."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay!'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


}
