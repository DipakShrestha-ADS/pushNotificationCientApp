import 'package:flutter/material.dart';

import 'push_notification_data_bloc.dart';

class PushNotificationDataBlocProvider extends InheritedWidget {
  //initiate bloc object
  final pushNotificationDataBloc = PushNotificationDataBloc();

  //constructor for this bloc provider
  PushNotificationDataBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  //ignores the parameter in update should notify instead return true
  //to always notify update
  @override
  bool updateShouldNotify(_) {
    return true;
  }

  //static method to give access to the bloc object
  static PushNotificationDataBloc of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<PushNotificationDataBlocProvider>()
        .pushNotificationDataBloc);
  }
}
