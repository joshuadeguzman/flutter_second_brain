import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> handleBackgroundNotification(Map<String, dynamic> message) {
  print("FCM background message => $message");
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    _firebaseMessaging = FirebaseMessaging();

    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(
          sound: true,
          badge: true,
          alert: true,
          provisional: true,
        ),
      );
      _firebaseMessaging.onIosSettingsRegistered.listen(
        (IosNotificationSettings settings) {
          print('FCM => iOS settings registered');
        },
      );
    }

    _firebaseMessaging.configure(
      onMessage: (message) async {
        print("FCM message => $message");
      },
      onLaunch: (message) async {
        print("FCM message => $message");
      },
      onResume: (message) async {
        print("FCM message => $message");
      },
      onBackgroundMessage: handleBackgroundNotification,
    );

    _firebaseMessaging.getToken().then(
          (token) => print(
            "FCM token => $token",
          ),
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
