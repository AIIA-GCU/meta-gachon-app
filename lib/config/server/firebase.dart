import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    apiKey: 'AIzaSyCzp90IpwNLe-Gtdf7K7G6peJTWKAJ8BWs',
    appId: '1:832071493502:android:80242cc6e15306113a752f',
    messagingSenderId: '832071493502',
    projectId: 'meta-gachon-fcm-8056',
    storageBucket: 'meta-gachon-fcm-8056.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJhFbRUhAvroec7Ldc7E5xPl49tmgd1IQ',
    appId: '1:832071493502:ios:a8f929d05fc671cc3a752f',
    messagingSenderId: '832071493502',
    projectId: 'meta-gachon-fcm-8056',
    storageBucket: 'meta-gachon-fcm-8056.appspot.com',
    iosBundleId: 'com.aiia.matagachon.mataGachon',
  );
}

class FCM {
  /// 토큰 얻기
  static Future<String> getToken() async {
    /// shared preference에서 불러오기
    final preference = await SharedPreferences.getInstance();
    String? token = preference.getString('fcm');

    /// 아직 없다면, Firebase에 접근해서 얻고 저장하기
    if (token == null) {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      token = await FirebaseMessaging.instance.getToken();
      await preference.setString('fcm', token!);
    }

    debugPrint('Firebase FCM token: $token');
    return token;
  }

  /// fcm이 동작할 수 있게 초기화
  static Future<bool> initialize() async {
    /// declaration
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    final fireMsg = FirebaseMessaging.instance;

    /// 권한 설정
    final notifiPermission = await fireMsg.requestPermission(badge: true, alert: true, sound: true);

    /// 권한이 허락된 경우에만 메시지 수신하기
    if (notifiPermission.authorizationStatus == AuthorizationStatus.authorized) {
      /// Forground
      FirebaseMessaging.onMessage.listen((msg) { });

      /// Background
      FirebaseMessaging.onMessageOpenedApp.listen((mgs) { });

      /// Terminate
      fireMsg.getInitialMessage().then((msg) { });

      return true;
    }
    else {
      return false;
    }
  }
}