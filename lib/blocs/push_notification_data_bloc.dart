import 'package:flutter/material.dart';
import 'package:pushnotificationclients/resources/repository/push_notification_repository.dart';
import 'package:pushnotificationclients/utils/string_constants.dart';
import 'package:rxdart/rxdart.dart';

class PushNotificationDataBloc {
  //initiate the object of PushNotificationRepository
  final _pushNotificationRepository = PushNotificationRepository();

  //Define Rxdart Stream Controller to sink data and provide the stream to the ui
  final _pushNotificationDataController =
      BehaviorSubject<Map<String, dynamic>>();
  final _titleFieldController = BehaviorSubject<dynamic>();
  final _detailMessageFieldController = BehaviorSubject<dynamic>();
  final _publishDateFieldController = BehaviorSubject<dynamic>();
  final _accessedDateFieldController = BehaviorSubject<dynamic>();
  final _imageController = BehaviorSubject<dynamic>();
  final _showDialogController = BehaviorSubject<bool>();

  String registeredToken;

  //define the stream to get related data for the ui to update
  //Observable is same as stream
  Observable<Map<String, dynamic>> get getPushNotificationData =>
      _pushNotificationDataController.stream;
  Observable<dynamic> get getTittle => _titleFieldController.stream;
  Observable<dynamic> get getDetailMessage =>
      _detailMessageFieldController.stream;
  Observable<dynamic> get getPublishDate => _publishDateFieldController.stream;
  Observable<dynamic> get getAccessedDate =>
      _accessedDateFieldController.stream;
  Observable<dynamic> get getImage => _imageController.stream;
  Observable<bool> get getCanShowDialog => _showDialogController.stream;

  //function to set or sink data in streamController
  Function(Map<String, dynamic>) get setPushNotificationData =>
      _pushNotificationDataController.sink.add;
  Function(dynamic) get setTitle => _titleFieldController.sink.add;
  Function(dynamic) get setDetailMessage =>
      _detailMessageFieldController.sink.add;
  Function(dynamic) get setPublishDate => _publishDateFieldController.sink.add;
  Function(dynamic) get setAccessedDate =>
      _accessedDateFieldController.sink.add;
  Function(dynamic) get setImage => _imageController.sink.add;
  Function(bool) get setCanShowDialog => _showDialogController.sink.add;

  //initial setup for the firebase cloud messaging push notification
  initPushNotification() async {
    //get token or register the device for firebase cloud messaging push notification
    _pushNotificationRepository.getTokenForPushNotification().then((value) {
      registeredToken = value;
    });

    //configuring the firebase messaging service for push notification to get data from function written for firebase cloud function
    _pushNotificationRepository.getFirebaseMessagingObject.configure(
      //get notification data when the app is running here in onMessage
      onMessage: (Map<String, dynamic> message) async {
        final title = message['data']['title'];
        final detailedMessage = message['data']['detailedMessage'];
        final publishDate = message['data']['publishDate'];
        final image = message['data']['image'];
        Object tObject = message['data']['accessedDate'];
        //accessed time
        final accessedDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(tObject.toString()),
          isUtc: false,
        );
        setCanShowDialog(true);
        setTitle(title);
        setDetailMessage(detailedMessage);
        setPublishDate(publishDate);
        setAccessedDate(accessedDate);
        setPushNotificationData(message);
        setImage(image);
        print('onMessage: ${message['data']}');
      },
      //get notification data when the app is totally closed or destroyed on background message
      onBackgroundMessage:
          TargetPlatform.iOS == 'ios' ? null : myBackgroundMessageHandler,
      //get notification data when app just lunch after notification arrives
      onLaunch: (Map<String, dynamic> message) async {
        final title = message['data']['title'];
        final detailedMessage = message['data']['detailedMessage'];
        final publishDate = message['data']['publishDate'];
        final image = message['data']['image'];
        Object tObject = message['data']['accessedDate'];
        //accessed time
        final accessedDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(tObject.toString()),
          isUtc: false,
        );
        setTitle(title);
        setDetailMessage(detailedMessage);
        setPublishDate(publishDate);
        setAccessedDate(accessedDate);
        setPushNotificationData(message);
        setImage(image);
        print("onLaunch: $message");
      },
      //get notification data when app is on resume state and when the notification clicked
      onResume: (Map<String, dynamic> message) async {
        final title = message['data']['title'];
        final detailedMessage = message['data']['detailedMessage'];
        final publishDate = message['data']['publishDate'];
        Object tObject = message['data']['accessedDate'];
        final image = message['data']['image'];
        //accessed time
        final accessedDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(tObject.toString()),
          isUtc: false,
        );
        setTitle(title);
        setDetailMessage(detailedMessage);
        setPublishDate(publishDate);
        setAccessedDate(accessedDate);
        print("onResume: ${message['data']} ");
        setPushNotificationData(message);
        setImage(image);
      },
    );

    //subscribe to push notification topic
    _pushNotificationRepository
        .subscribeToPushNotificationTopics(
            StringConstants.pushNotificationTopic)
        .then((value) {
      if (value) {
        print('Subscribed to topic ${StringConstants.pushNotificationTopic}');
      }
    });
  }

  //Static or Top-Level fucntion is need for the bacground message handler for push notification
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    final dynamic data = message['data'];
    return new Future(data);
  }

  //to close or drain all streamController when no needed or widget gets distoyed
  void dispose() async {
    await _pushNotificationDataController.drain();
    _pushNotificationDataController.close();
    await _titleFieldController.drain();
    _titleFieldController.close();
    await _detailMessageFieldController.drain();
    _detailMessageFieldController.close();
    await _publishDateFieldController.drain();
    _publishDateFieldController.close();
    await _accessedDateFieldController.drain();
    _accessedDateFieldController.close();
    await _showDialogController.drain();
    _showDialogController.close();
    await _imageController.drain();
    _imageController.close();
  }
}
