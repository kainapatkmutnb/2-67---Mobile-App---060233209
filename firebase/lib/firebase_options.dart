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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDWj-aS1KpX5TgqJy4BNzjVoeiNxkm45SU',
    appId: '1:809262138786:web:ca7eef60fe73c6e1e75efb',
    messagingSenderId: '809262138786',
    projectId: 'flutterapp2025',
    authDomain: 'flutterapp2025.firebaseapp.com',
    storageBucket: 'flutterapp2025.firebasestorage.app',
    measurementId: 'G-Y5L2HZ9N4B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwhd85UxsZnGmJ12vuPuQh_dEJFUw3wro',
    appId: '1:809262138786:android:3bb654fad455e935e75efb',
    messagingSenderId: '809262138786',
    projectId: 'flutterapp2025',
    storageBucket: 'flutterapp2025.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDWj-aS1KpX5TgqJy4BNzjVoeiNxkm45SU',
    appId: '1:809262138786:web:44d7bf220cdf3af1e75efb',
    messagingSenderId: '809262138786',
    projectId: 'flutterapp2025',
    authDomain: 'flutterapp2025.firebaseapp.com',
    storageBucket: 'flutterapp2025.firebasestorage.app',
    measurementId: 'G-Z409FB1VFX',
  );

}