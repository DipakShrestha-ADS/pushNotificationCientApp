import 'package:flutter/material.dart';
import 'package:pushnotificationclients/blocs/push_notification_data_boc_provider.dart';

import 'viewData/fetch_data_from_firebase_screen.dart';

class PushNotificationClientApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Wrapped with bloc provider to provide access to the bloc object
    //throughout the entire widget subtree
    return PushNotificationDataBlocProvider(
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
          accentColor: Colors.purpleAccent,
        ),
        debugShowCheckedModeBanner: false,
        home: FetchDataFromFireBaseScreen(),
      ),
    );
  }
}
