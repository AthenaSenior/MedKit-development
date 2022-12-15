// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBxYCP2_XGnIXzxxccpIlO9fjN49bUuUPU',
    appId: '1:375223889275:android:fe48283e6016ddbbd961de',
    messagingSenderId: '375223889275',
    projectId: 'med-kit-77705',
    databaseURL: 'https://med-kit-77705-default-rtdb.firebaseio.com',
    storageBucket: 'med-kit-77705.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBFgGWontHaQryZWZbaVjkpmpmOEXD8m1A',
    appId: '1:375223889275:ios:dd545b4943b3c176d961de',
    messagingSenderId: '375223889275',
    projectId: 'med-kit-77705',
    databaseURL: 'https://med-kit-77705-default-rtdb.firebaseio.com',
    storageBucket: 'med-kit-77705.appspot.com',
    iosClientId: '375223889275-u7hgd0d0f0i8ihdskt84lbnjphmpedi2.apps.googleusercontent.com',
    iosBundleId: 'com.example.medKit',
  );
}
