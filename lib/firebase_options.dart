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
    apiKey: 'AIzaSyCpEBikiUguXSGcHi7qXIbg4yaIZpYi_KU',
    appId: '1:588412437604:web:84e5de343eb2aef746cb71',
    messagingSenderId: '588412437604',
    projectId: 'voting-app-32675',
    authDomain: 'voting-app-32675.firebaseapp.com',
    storageBucket: 'voting-app-32675.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDRzblRDDH-wXMD3VdSSzipivPSosk7Brk',
    appId: '1:588412437604:android:53c7b5a899341e2446cb71',
    messagingSenderId: '588412437604',
    projectId: 'voting-app-32675',
    storageBucket: 'voting-app-32675.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAlT4ruEv0zN6xwtVvdFZSO5uxSCLrwt-c',
    appId: '1:588412437604:ios:351d646b638ab6c746cb71',
    messagingSenderId: '588412437604',
    projectId: 'voting-app-32675',
    storageBucket: 'voting-app-32675.firebasestorage.app',
    iosBundleId: 'com.polls.votingApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAlT4ruEv0zN6xwtVvdFZSO5uxSCLrwt-c',
    appId: '1:588412437604:ios:351d646b638ab6c746cb71',
    messagingSenderId: '588412437604',
    projectId: 'voting-app-32675',
    storageBucket: 'voting-app-32675.firebasestorage.app',
    iosBundleId: 'com.polls.votingApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCpEBikiUguXSGcHi7qXIbg4yaIZpYi_KU',
    appId: '1:588412437604:web:9ea445527ed92aa646cb71',
    messagingSenderId: '588412437604',
    projectId: 'voting-app-32675',
    authDomain: 'voting-app-32675.firebaseapp.com',
    storageBucket: 'voting-app-32675.firebasestorage.app',
  );
}
