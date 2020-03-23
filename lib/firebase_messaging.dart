import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  var Token = "";

  FirebaseNotifications();

  void iniciarFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('mensagem recebida $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) {
      print("Firebase token: " + token);
      Token = token.toString();
      print("TOKEN: " + Token);
    });
  }

  Future<String> pegaToken() async {
    final token = await _firebaseMessaging.getToken();
    print("pegaToken: " + token);
    return token.toString();
  }

  String PegaToken(){
    print("PEGA TOKEN: " + Token);
    return Token;
  }

  /*String PegaToken() {
    final token = _firebaseMessaging.getToken();
    print("PegaToken: " + token);
    return token.toString();
  }*/
}