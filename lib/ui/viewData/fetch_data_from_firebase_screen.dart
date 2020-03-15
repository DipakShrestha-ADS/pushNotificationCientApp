import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pushnotificationclients/blocs/push_notification_data_bloc.dart';
import 'package:pushnotificationclients/blocs/push_notification_data_boc_provider.dart';

class FetchDataFromFireBaseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FetchDataFromFireBaseScreenState();
  }
}

class FetchDataFromFireBaseScreenState
    extends State<FetchDataFromFireBaseScreen> {
  //creating bloc object
  PushNotificationDataBloc _pushNotificationDataBloc;

  @override
  void didChangeDependencies() {
    //get the bloc using bloc provider
    _pushNotificationDataBloc = PushNotificationDataBlocProvider.of(context);

    //initial setup for push notification usig firebase cloud messaging
    _pushNotificationDataBloc.initPushNotification();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //drain & close all the stream used to update UI when the widget get disposed
    _pushNotificationDataBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Push Notification Client',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          //get image from the push notification clicked and display as actions in appbar
          StreamBuilder<dynamic>(
              stream: _pushNotificationDataBloc.getImage,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    child: CachedNetworkImage(
                      width: 40.0,
                      height: 40.0,
                      imageUrl: "${snapshot.data}",
                      placeholder: (context, url) => SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: new CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                  ),
                );
              }),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          //stream builder used to stream should show dialog or not in
          //show dialog if notification appears & app is in active state or running
          child: StreamBuilder<bool>(
              initialData: false,
              stream: _pushNotificationDataBloc.getCanShowDialog,
              builder: (context, snapshot) {
                //shows the dialog if snapshot.data is true and hasdata
                if (snapshot.hasData && snapshot.data) {
                  //need to show ui after the build function executes, this WidgetBinding gives us that.
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        //stream builder to stream data from push notification clicked to show in dialog
                        return StreamBuilder<Map<String, dynamic>>(
                            stream: _pushNotificationDataBloc
                                .getPushNotificationData,
                            builder: (context1, snapshot1) {
                              return AlertDialog(
                                title: new Text('Push Notification Arrived.'),
                                content: SingleChildScrollView(
                                  child: new Text(
                                    'Title: ${snapshot1 != null ? snapshot1.data['data']['title'] : 'title here'} \n'
                                    'Abstract Message: ${snapshot1 != null ? snapshot1.data['data']['abstractMessage'] : 'abstract here'} \n'
                                    'Date Published: ${snapshot1 != null ? snapshot1.data['data']['publishDate'] : 'publish date here'} \n',
                                  ),
                                ),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: new Text("Close"),
                                    onPressed: () {
                                      _pushNotificationDataBloc
                                          .setCanShowDialog(false);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    );
                  });
                }
                return Column(
                  children: <Widget>[
                    titleWidget(),
                    Container(
                      height: 10.0,
                    ),
                    detailedMessageWidget(),
                    Container(
                      height: 10.0,
                    ),
                    datePublishedWidget(),
                    dateAccessedWidget(),
                  ],
                );
              }),
        ),
      ),
    );
  }

  final textStyleAllHeading = TextStyle(
    color: Colors.deepOrange,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );

  final textStyleAllBody = TextStyle(
    color: Colors.blueGrey,
    fontWeight: FontWeight.normal,
    fontSize: 18.0,
  );

  //title widget ot show the title from notification
  Widget titleWidget() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: <Widget>[
          Text(
            'Title: ',
            style: textStyleAllHeading,
          ),
          //stream the title and update here if has data
          StreamBuilder<dynamic>(
              initialData: 'title appears here...',
              stream: _pushNotificationDataBloc.getTittle,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data}',
                  style: textStyleAllBody,
                );
              }),
        ],
      ),
    );
  }

  //widget to show detailed message from notification
  Widget detailedMessageWidget() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Text(
            'Detail Message:',
            style: textStyleAllHeading,
          ),
          Container(
            height: 5.0,
          ),
          Card(
            elevation: 10.0,
            color: Colors.blueGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              width: double.infinity,
              height: 350,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  //stream the detailed message to update here if hasdata
                  child: StreamBuilder<dynamic>(
                      initialData: 'detailed message appear here...',
                      stream: _pushNotificationDataBloc.getDetailMessage,
                      builder: (context, snapshot) {
                        return Text(
                          '${snapshot.data}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        );
                      }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //widget to display data published date
  Widget datePublishedWidget() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: <Widget>[
          Text(
            'Published Date: ',
            style: textStyleAllHeading,
          ),
          //stream the datePublished to update here if has data
          StreamBuilder<dynamic>(
              initialData: 'published date appears here...',
              stream: _pushNotificationDataBloc.getPublishDate,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data}',
                  style: textStyleAllBody,
                );
              }),
        ],
      ),
    );
  }

  //widget to display date Accessed from notification
  Widget dateAccessedWidget() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: <Widget>[
          Text(
            'Accessed Date: ',
            style: textStyleAllHeading,
          ),
          //stream dateAccessed to update here after notification is clicked or update directly if app is running
          StreamBuilder<dynamic>(
              initialData: 'accessed date appears here...',
              stream: _pushNotificationDataBloc.getAccessedDate,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data}',
                  style: textStyleAllBody,
                );
              }),
        ],
      ),
    );
  }
}
