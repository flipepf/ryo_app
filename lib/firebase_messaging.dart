import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  FirebaseNotifications();

  /*void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();
    this.iniciarFirebaseListeners();
  }*/

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
    _firebaseMessaging
        .requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) {
      print("Firebase token: " + token);
    });
  }

  Future<String> pegaToken() async => _firebaseMessaging.getToken().then((token) {
      print("pegaToken: " + token);
      return token;
    });

  String PegaToken(){
    final token = _firebaseMessaging.getToken().toString();
    print("PegaToken: " + token);
    return token;
  }
}