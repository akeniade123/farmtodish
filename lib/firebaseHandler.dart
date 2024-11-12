import 'dart:convert';

import 'global_handlers.dart';
import 'notificationcontroller.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
    logger(dtt["Essence"]);
    Map<String, dynamic> rsp = {ess: dtt};
    response = jsonEncode(rsp);
  } catch (e) {
    logger("Error***$e");
  }

  */

  return response;
}
