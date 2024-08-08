import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBw4QtPAOeUfF309HaLRoGqw_7YL0vvZ9o',
    appId: '1:448101294701:web:653cc36638506c27911564',
    messagingSenderId: '448101294701',
    projectId: 'sext-app',
    authDomain: 'sext-app.firebaseapp.com',
    storageBucket: 'sext-app.appspot.com',
    measurementId: 'G-SJDSCDNPQW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBwxXoxhF_ANwuop9hYnb3LiLispJdyAyc',
    appId: '1:448101294701:android:5d2329eea01fcc76911564',
    messagingSenderId: '448101294701',
    projectId: 'sext-app',
    storageBucket: 'sext-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5wcgf3lZTzGSec0Mhb7Q5cMCaooNZWFs',
    appId: '1:448101294701:ios:67272e077a5b8e08911564',
    messagingSenderId: '448101294701',
    projectId: 'sext-app',
    storageBucket: 'sext-app.appspot.com',
    iosBundleId: 'com.example.decimapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC5wcgf3lZTzGSec0Mhb7Q5cMCaooNZWFs',
    appId: '1:448101294701:ios:67272e077a5b8e08911564',
    messagingSenderId: '448101294701',
    projectId: 'sext-app',
    storageBucket: 'sext-app.appspot.com',
    iosBundleId: 'com.example.decimapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBw4QtPAOeUfF309HaLRoGqw_7YL0vvZ9o',
    appId: '1:448101294701:web:7b6b1d061cbabd23911564',
    messagingSenderId: '448101294701',
    projectId: 'sext-app',
    authDomain: 'sext-app.firebaseapp.com',
    storageBucket: 'sext-app.appspot.com',
    measurementId: 'G-0JFLRDXX8E',
  );

}