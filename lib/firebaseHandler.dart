import 'dart:convert';
import 'dart:isolate';

import 'firebase_options.dart';
import 'global_handlers.dart';
import 'global_string.dart';
import 'notificationcontroller.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'sharedpref.dart';

Future<String> handleUpdates(
    RemoteMessage remoteMessage, bool foreground) async {
  String response = "";
  if (remoteMessage.notification != null) {
    try {
      String msg = jsonEncode(remoteMessage.notification!.body);
      logger("Notification:$msg");

      Map<String, dynamic> json = jsonDecode(jsonDecode(msg));
      logger("The Title${json['title']}");

      if (json['notify']) {
        NotificationController.createNewNotification(
            json['title'], json['content']);
      }

      Map<String, dynamic> dtt = remoteMessage.data;
      String parse = jsonEncode(dtt);
      logger("The Data: $parse");

      // _run(json['content'], json[unq], parse, dtt);
    } catch (e) {
      logger("handler error: $e");
    }
  }

  /*
  try {
    late DatabaseHelper dbh;
    SharedPref pref = SharedPref();
    Map<String, dynamic> dtt = remoteMessage.data;
    loggerger(dtt["Essence"]);
    Map<String, dynamic> rsp = {ess: dtt};
    response = jsonEncode(rsp);
  } catch (e) {
    loggerger("Error***$e");
  }

  */

  return response;
}

late SharedPref pref;

void _backgroundTask(SendPort sendPort) {
  // Perform time-consuming operation here
  // ...

  // Send result back to the main UI isolate
  sendPort.send('Task completed successfully!');
}

final ReceivePort _port = ReceivePort();

void _startBackgroundTask() async {
  try {
    await Isolate.spawn(_backgroundTask, _port.sendPort);
    _port.listen((message) async {
      logger("got a notification**");

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });
  } catch (e) {
    logger("check error: $e");
  }

  try {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    fbId = fcmToken!;
    logger("UserToken:$fbId");
    pref.setPrefString(tk_id, fcmToken);
    pref.setPrefBool(token, true);
  } catch (e) {}

  //  await FirebaseMessaging.instance.getToken();

  //  await Firebase.initializeApp();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // ignore: avoid_print
    print('Got a message whilst in the foreground!');
    if (message.notification != null) {
      // print('Notification Title: ${message.notification.title}');
      // print('Notification Body: ${message.notification.body}');
    }
  });

  Future<void> _messageHandler(RemoteMessage message) async {
    String msg = jsonEncode(message.data);
    logger("Background Message Received:$msg");
    logger("Msg rcpt");
  }

  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  FirebaseMessaging.onMessage.listen((event) {
    logger("Fore");
    // do something
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    logger("Fore OPen");
    // do something
  });

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   /*
  //   setState(() {
  //     _messages = [..._messages, message];
  //   });

  //   */
  //   logger("CheckMsg***$message");
  // });
}
