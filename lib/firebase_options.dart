// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBU4CSRtu_dg-QU5yJfPFg_MqUKI4aBgmI',
    appId: '1:1043235069211:web:c3ca5c76a32522e4c847be',
    messagingSenderId: '1043235069211',
    projectId: 'clothing-store-managemen-7b030',
    authDomain: 'clothing-store-managemen-7b030.firebaseapp.com',
    storageBucket: 'clothing-store-managemen-7b030.appspot.com',
    measurementId: 'G-SN0MYZL06K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAWofnYwAm3AphSIIpDfDRgM4WtjeAqJYg',
    appId: '1:1043235069211:android:b82e0bf0f8304474c847be',
    messagingSenderId: '1043235069211',
    projectId: 'clothing-store-managemen-7b030',
    storageBucket: 'clothing-store-managemen-7b030.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyArS13ZM98XbUEB4Jfvngn-YRmS-VkNBnM',
    appId: '1:1043235069211:ios:30e77d819e5a5a05c847be',
    messagingSenderId: '1043235069211',
    projectId: 'clothing-store-managemen-7b030',
    storageBucket: 'clothing-store-managemen-7b030.appspot.com',
    iosBundleId: 'com.example.nepstyleManagementSystem',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyArS13ZM98XbUEB4Jfvngn-YRmS-VkNBnM',
    appId: '1:1043235069211:ios:30e77d819e5a5a05c847be',
    messagingSenderId: '1043235069211',
    projectId: 'clothing-store-managemen-7b030',
    storageBucket: 'clothing-store-managemen-7b030.appspot.com',
    iosBundleId: 'com.example.nepstyleManagementSystem',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBU4CSRtu_dg-QU5yJfPFg_MqUKI4aBgmI',
    appId: '1:1043235069211:web:da6661b89eb128e2c847be',
    messagingSenderId: '1043235069211',
    projectId: 'clothing-store-managemen-7b030',
    authDomain: 'clothing-store-managemen-7b030.firebaseapp.com',
    storageBucket: 'clothing-store-managemen-7b030.appspot.com',
    measurementId: 'G-B0P9DLLJKE',
  );
}
