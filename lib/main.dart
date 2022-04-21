import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gyalcuser_project/constants/colors.dart';
import 'package:gyalcuser_project/providers/multi_provider.dart';
import 'package:gyalcuser_project/screens/splashscreen.dart';
import 'package:gyalcuser_project/services/fcm_services.dart';
import 'package:gyalcuser_project/services/local_notification.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalNotificationsService.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  FCMServices.fcmGetTokenandSubscribe('user');
  fcmListen();
  //For ios
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  // // Awesome notification initialize method
  // AwesomeNotifications().initialize('resource://drawable/uts_icon_color', [
  //   NotificationChannel(
  //     channelKey: 'Gylac',
  //     importance: NotificationImportance.High,
  //     channelName: 'Gylac',
  //     channelDescription: 'Gylac',
  //     channelShowBadge: true,
  //     defaultColor: const Color(0xFF9D50DD),
  //     playSound: true,
  //     // soundSource: 'resource://raw/car_lock',
  //     ledColor: Colors.white,
  //   ),
  // ]);
  // // For ios notification permission
  // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
  //   if (!isAllowed) {
  //     AwesomeNotifications().requestPermissionToSendNotifications();
  //   }
  // });
  // FirebaseMessaging.onBackgroundMessage((backgroundHandler));

  runApp(const MyApp());
}

Future<void> _messageHandler(RemoteMessage event) async {
  await Firebase.initializeApp();

  if (event.data['id'] == FirebaseAuth.instance.currentUser?.uid) {
    LocalNotificationsService.instance.showNotification(
        title: '${event.notification?.title}',
        body: '${event.notification?.body}');

    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  }

  print("Handling a background message: ${event.messageId}");
}

fcmListen() async {
  // var sfID = await AuthServices.getTraderID();
  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    log('event: $event');
    if (event.data['id'] == FirebaseAuth.instance.currentUser?.uid ||
        event.data['id'].toString() == "all") {
      LocalNotificationsService.instance.showNotification(
          title: '${event.notification?.title}',
          body: '${event.notification?.body}');

      FirebaseMessaging.onMessageOpenedApp.listen((message) {});
    } else {}
  });
}

// Future<void> backgroundHandler(RemoteMessage message) async {
//   print('message: $message');

//   AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       channelKey: 'Gylac',
//       wakeUpScreen: true,
//       title: "asdfa",
//       body: "sdf",
//       // largeIcon: "asset://assets/images/door.png",

//       notificationLayout: NotificationLayout.BigText,

//       // customSound:  'resource://raw/car_lock',
//     ),
//   );
// }

// fcmListen() async {
//   log("FCM Listen....");
//   FirebaseMessaging.onMessage.listen((RemoteMessage event) {
//     print('event: $event');
//     // if (event.data['id'] == FirebaseAuth.instance.currentUser?.uid ||
//     //     event.data['id'].toString() == "all") {
//     //   LocalNotificationsService.instance.showChatNotification(
//     //       title: '${event.notification?.title}',
//     //       body: '${event.notification?.body}');

//     //   FirebaseMessaging.onMessageOpenedApp.listen((message) {});
//     // } else {}
//   });
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: orange));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
        designSize: const Size(1080, 2280),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: () {
          return MultiProvider(
              providers: multiProvider,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'gyalcproject',
                theme: ThemeData(
                  primarySwatch: Colors.yellow,
                ),
                home: const Splash(),
              ));
        });
  }
}
