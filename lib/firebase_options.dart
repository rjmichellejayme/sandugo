// firebase project settings

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
    apiKey: 'AIzaSyCIB9Ss0U0B4HIILFvEUuBbHajWysog6FI',
    appId: '1:855746212080:web:3bc0560ed9dcb86e2f5235',
    messagingSenderId: '855746212080',
    projectId: 'sandugo-7d1ee',
    authDomain: 'sandugo-7d1ee.firebaseapp.com',
    storageBucket: 'sandugo-7d1ee.firebasestorage.app',
    measurementId: 'G-XTLXH614JY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAA1JizjQgyxnDWBqlW3L-WWPJ0bwwr8HQ',
    appId: '1:855746212080:android:7365888b053303192f5235',
    messagingSenderId: '855746212080',
    projectId: 'sandugo-7d1ee',
    storageBucket: 'sandugo-7d1ee.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBgiLPmZzQlr1EBVuIpWXWPfTpaoOerT8E',
    appId: '1:855746212080:ios:baa05a55426e085f2f5235',
    messagingSenderId: '855746212080',
    projectId: 'sandugo-7d1ee',
    storageBucket: 'sandugo-7d1ee.firebasestorage.app',
    iosBundleId: 'com.example.sandugo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBgiLPmZzQlr1EBVuIpWXWPfTpaoOerT8E',
    appId: '1:855746212080:ios:baa05a55426e085f2f5235',
    messagingSenderId: '855746212080',
    projectId: 'sandugo-7d1ee',
    storageBucket: 'sandugo-7d1ee.firebasestorage.app',
    iosBundleId: 'com.example.sandugo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCIB9Ss0U0B4HIILFvEUuBbHajWysog6FI',
    appId: '1:855746212080:web:66130ebdfa16ed4c2f5235',
    messagingSenderId: '855746212080',
    projectId: 'sandugo-7d1ee',
    authDomain: 'sandugo-7d1ee.firebaseapp.com',
    storageBucket: 'sandugo-7d1ee.firebasestorage.app',
    measurementId: 'G-TFLDJM2W4S',
  );
}
