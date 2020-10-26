import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_second_brain/models/fcm_notification.model.dart';
import 'package:flutter_second_brain/screens/plain_account_linking.screen.dart';

int _notificationId = 1000;

int _notificationCount = 0;

int getBackgroundNotificationId() {
  _notificationCount += 1;
  FlutterAppBadger.updateBadgeCount(_notificationCount);
  return _notificationId++;
}

Future<dynamic> handleBackgroundNotification(Map<String, dynamic> message) {
  final localNotifications = FlutterLocalNotificationsPlugin();
  final androidInitializationSettings =
      AndroidInitializationSettings('@drawable/notification_icon');
  final iosInitializationSettings = IOSInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
    onDidReceiveLocalNotification: null,
  );
  final initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: iosInitializationSettings,
  );

  localNotifications.initialize(initializationSettings);

  final _notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails("", "", ""),
    iOS: IOSNotificationDetails(),
  );

  if (message.containsKey('aps')) {
    final p = json.decode(json.encode(message));
    localNotifications.show(
      getBackgroundNotificationId(),
      p.aps.alert.title,
      p.aps.alert.body,
      _notificationDetails,
    );
  } else if (message.containsKey("notification")) {
    final p = json.decode(json.encode(message));
    localNotifications.show(
      getBackgroundNotificationId(),
      p.notification.title,
      p.notification.body,
      _notificationDetails,
    );
  }
  return null;
}

Future main() async {
  await DotEnv().load('.env');
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
      home: PlaidAccountLinkingScreen(),
    );
  }
}

// TODO: Clean up directory
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseMessaging _firebaseMessaging;
  FlutterLocalNotificationsPlugin _localNotifications;
  AndroidInitializationSettings _androidInitializationSettings;
  IOSInitializationSettings _iosInitializationSettings;
  InitializationSettings _initializationSettings;
  NotificationDetails _notificationDetails;
  int _foregroundNotificationCount;
  int _foregroundNotificationId;

  @override
  void initState() {
    _foregroundNotificationCount = 0;
    _foregroundNotificationId = 0;
    _firebaseMessaging = FirebaseMessaging();
    _localNotifications = FlutterLocalNotificationsPlugin();
    _androidInitializationSettings =
        AndroidInitializationSettings('@drawable/notification_icon');
    _iosInitializationSettings = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: null,
    );
    _initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
      iOS: _iosInitializationSettings,
    );
    _localNotifications.initialize(_initializationSettings);
    _notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails("", "", ""),
      iOS: IOSNotificationDetails(),
    );

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
        _showNotifications(message);
      },
      onLaunch: (message) async {
        print("FCM message => $message");
        _showNotifications(message);
      },
      onResume: (message) async {
        print("FCM message => $message");
        _showNotifications(message);
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

  _showNotifications(message) {
    if (message.containsKey('aps')) {
      FlutterAppBadger.updateBadgeCount(_foregroundNotificationCount++);

      final p = FCMNotification.fromJson(json.decode(json.encode(message)));
      _localNotifications.show(
        _getNotificationId(),
        p.aps.alert.title,
        p.aps.alert.body,
        _notificationDetails,
      );
    }
    // TODO: Migrate to model
    else if (message.containsKey("notification")) {
      final p = json.decode(json.encode(message));
      _localNotifications.show(
        _getNotificationId(),
        p.notification.title,
        p.notification.body,
        _notificationDetails,
      );
    }
  }

  int _getNotificationId() {
    return _foregroundNotificationId++;
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
