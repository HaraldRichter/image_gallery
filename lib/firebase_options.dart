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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAP67rJr431dj3_yryn2VUhks22aiqKLx0',
    appId: '1:431089727409:web:8ac7d6a4af0e21cdbaaf90',
    messagingSenderId: '431089727409',
    projectId: 'bloc-picture-app',
    authDomain: 'bloc-picture-app.firebaseapp.com',
    storageBucket: 'bloc-picture-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCofJUPx9fspuRnZA7JNDw9A0d2BVvGHrs',
    appId: '1:431089727409:android:a3db92d1a713fc43baaf90',
    messagingSenderId: '431089727409',
    projectId: 'bloc-picture-app',
    storageBucket: 'bloc-picture-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBo_vnf-nb-BYRrhuG5KJBgrL_Wm6ZSl1s',
    appId: '1:431089727409:ios:974e7ce93f2bdd1abaaf90',
    messagingSenderId: '431089727409',
    projectId: 'bloc-picture-app',
    storageBucket: 'bloc-picture-app.appspot.com',
    iosClientId: '431089727409-mukulo9mlr0t4edoj6hoqno4b4jf4gj7.apps.googleusercontent.com',
    iosBundleId: 'hyenabyte.de.blocTutorialFirebase',
  );
}