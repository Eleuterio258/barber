import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging firebaseMessaging;

  FirebaseMessagingService(this.firebaseMessaging);

  void setUpFirebaseMessaging(BuildContext context) {
    firebaseMessaging.getToken().then((token) {
      if (kDebugMode) {
        print("Firebase Token: $token");
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("onMessage: $message");
      }
      String routeName = message.data['route'];
      Navigator.of(context).pushNamed(routeName);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("onResume: $message");
      }
    });
  }
}
