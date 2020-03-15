import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingProvider {
  //initiate the firebase cloud messaging service
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  //resigter the device to firebase messaging and provide the token
  Future<String> getTokenForPushNotification() async {
    return await _firebaseMessaging.getToken().then((value) {
      print('Token Messaging: $value');
      return value;
    });
  }

  //function to get FirbaseMessaging Object
  FirebaseMessaging get firebaseMessaging => _firebaseMessaging;

  //subscribe to push notification topics to get notification pushed based on topics
  Future<bool> subscribeToPushNotificationTopics(String topic) async {
    return await _firebaseMessaging.subscribeToTopic(topic).then((value) {
      return true;
    });
  }
}
