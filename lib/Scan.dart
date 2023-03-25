import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

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

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _future = _requestCameraPermission();
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
          return Container(
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

    final navigator = Navigator.of(context);

    try {
      final pictureFile = await _cameraController!.takePicture();

      final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      _showResultModal(recognizedText.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
    }
  }

  Future<void> _showResultModal(String scannedText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your Scan Result'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(scannedText),
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


}
