import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  static MessagingService instance = MessagingService();
  FirebaseMessaging _firebaseMessaging;

  MessagingService() {
    _firebaseMessaging = FirebaseMessaging();
  }

  Future<String> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  void sendNotification(){

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
    );

    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false),
      );
    }
  }

  /*void subscribeToThisTopic(String interest){
    _firebaseMessaging.subscribeToTopic(interest);
  }

  void unsubscribeFromThisTopic(String interest){
    _firebaseMessaging.unsubscribeFromTopic(interest);
  }*/

}