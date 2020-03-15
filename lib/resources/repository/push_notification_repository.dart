import 'package:firebase_messaging/firebase_messaging.dart';

import '../firebase_messaging_provider.dart';

class PushNotificationRepository {
  //initiate FirebaseMessgingProvider object
  final _firebaseMessagingProvider = FirebaseMessagingProvider();

  Future<String> getTokenForPushNotification() {
    return _firebaseMessagingProvider.getTokenForPushNotification();
  }

  FirebaseMessaging get getFirebaseMessagingObject =>
      _firebaseMessagingProvider.firebaseMessaging;

  Future<bool> subscribeToPushNotificationTopics(String topic) {
    return _firebaseMessagingProvider.subscribeToPushNotificationTopics(topic);
  }
}
