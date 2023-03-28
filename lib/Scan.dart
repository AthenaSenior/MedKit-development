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
  List<String> drugs = [];
  bool isLoading = true;

  Future<void> getAllDrugs()
  async {

    Query query = ref.orderByChild("Name");
    DataSnapshot event = await query.get();

    for (var child in event.children) {
      drugs.add(child.child("Name").value.toString());
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
          )
              :
          Container(
            height: size.width * 2.2,
            width: size.height * 2.2,
            color: Colors.black,
              child: Stack(
            children: [
              if (_isPermissionGranted)
                FutureBuilder<List<CameraDescription>>(
                  future: availableCameras(),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      _initCameraController(snapshot.data!);
                          return Column(
                            children:[
                              SizedBox(
                                  height: size.height * 0.035
                              ),
                              Row(
                                  children:[
                                    Image.asset('assets/images/medicine.png',
                                        width: 50, height: 50),
                                    const SizedBox(
                                        width: 10
                                    ),
                                    const Text("Make sure that the name of your medicine is \nfully visible on the screen.",
                                      style: TextStyle(fontSize: 15, color: Colors.white),
                                    ),
                                  ]
                              ),
                              Center(child: CameraPreview(_cameraController!))
                            ]
                          );
                    } else {
                      return const LinearProgressIndicator();
                    }
                  } ,
                ),
              Scaffold(
                backgroundColor: _isPermissionGranted ? Colors.transparent : null,
                body: _isPermissionGranted
                    ? Column(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 70.0),
                        child:ElevatedButton(
                          onPressed: _scanImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              )
                          ),
                          child: Image.asset('assets/images/medkit_logo.png',
                              width: 100, height: 100),
                        ) ,
                    )
                  ],
                )
                    : Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0,),
                    child: const Text("Camera Permission Denied",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ));
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
      final pictureFile = await _cameraController!.takePicture();

      final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      _queryText(recognizedText.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
    }
  }

  Future<void> _queryText(String scannedText)
  async {
    String scannedDrugName = "", scannedDrugShortDesc = "", scannedDrugLongDesc = "", scannedDrugPictureUrl = "", scannedDrugId = "";

    final splittedScans = scannedText.split(' ');

    for(var word in splittedScans) // little bit complex nested for
    {
      for (var item in drugs) {
        if(item.contains(word)){
          scannedDrugName = item;
          break; // Documentation: https://i.kym-cdn.com/entries/icons/mobile/000/032/031/man.jpg
        }
      }
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
          _getScannedDataAndAddNew(scannedDrugId);
          _showResultModal(scannedDrugName, scannedDrugShortDesc, scannedDrugPictureUrl, scannedDrugLongDesc);
        });
      }
    }
    catch(error) {
      _showErrorModal();
    }

  }

  Future<void> _getScannedDataAndAddNew(String key) async
  {
    int counter = 0;
    var drugs = [];
    ref = FirebaseDatabase.instance.ref("UserMedicine");
    Query query = ref.orderByChild("ScannedDrugId");
    DataSnapshot event = await query.get();

    for (var child in event.children) {
      counter++;
    }

    query = ref.orderByChild("UserId").equalTo(HomePageState.userId);
    event = await query.get();

    for (var child in event.children) {
      drugs.add(child.child("ScannedDrugId").value);
    }

    var lastFiveDrugs = drugs.reversed.take(5);

    if(lastFiveDrugs.contains(int.parse(key)))
    {
      return;
    }

    ref = FirebaseDatabase.instance.ref("UserMedicine/$counter");

    await ref.set({
      "ScannedDrugId": int.parse(key),
      "UserId": HomePageState.userId
    });

  }

  Future<void> _showResultModal(String name, String short, String pic, String long) async {
    var size = MediaQuery.of(context).size;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name),
          content: Container(
            color: Colors.white, // Dialog background
            width: size.width, // Dialog width
            height: 250, // Dialog height
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
