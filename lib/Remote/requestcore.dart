import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../Screens/Login/login_screen.dart';
import '../global_handlers.dart';
import '../global_string.dart';
import '../global_widgets.dart';
import '../sharedpref.dart';
import 'endpoints.dart';
import 'requester.dart';
import 'server_response.dart';
import 'service_protocols.dart';

Future<void> logout(BuildContext context) async {
  SharedPref pref = SharedPref();
  pref.setPrefBool(login, false);
  pref = SharedPref();
  pref.setPrefString(usrTbl, "");
  context.go("/");
}

Future<Map<String, dynamic>>? tagPost(Map<String, dynamic> tag, String essence,
    [BuildContext? context]) async {
  /*
      Essence:access
Designation:content
regId:dySI7okZRX-4qGPfcyL72P:APA91bEr9xWX3dHLG78mdRckQ6soKdkeMhM9j1RWweb7ft_81wsiUiAp87OVPiiG0_QCCHkBaruykOPU9kqWXLcBdzuNlumkggBb3snA2sJP-6EHa6h-g7ikkydnoXBY4jzvKbUow6_z
Full_Name:Akeni Adeyinka
Unique_ID:334656#/topics/Ojo#New Class arm created#Talconer#Notify
Password:random
      */
  Map<String, dynamic> txt = {};
  SharedPref pref = SharedPref();
  String? tkn = await pref.getPrefString(tk_id);
  Map<String, dynamic> dtt = {
    "Essence": "access",
    "Designation": "content",
    "regId": tkn,
    "Tag": tag
  };
  FetchData(tag, essence, context);
  return txt;
}

Future<Map<String, dynamic>>? FetchData(
    Map<String, dynamic> tag, String essence,
    [BuildContext? context]) async {
  SharedPref pref = SharedPref();
  Map<String, dynamic> txt = {}; // Text("Sign in");
  // Map<String, String> tag = {};

  // switch (essence) {
  //   case login:
  //     tag.addEntries({
  //       "regId": "prelim",
  //       "Phone": phoneNumberRetriever.text,
  //       "Essence": "Phone_No_Login",
  //       "Password": passwordRetriever.text
  //     }.entries);
  //     break;
  //   case pswOTP:
  //     tag.addEntries({
  //       "regId": "prelim",
  //       "Full_Name": emailRetreiver.text,
  //       "Essence": "Profile",
  //       "domain": "PasswordOTP"
  //     }.entries);
  //     break;
  // }

  Endpoint enp = Endpoint();
  String url = enp.getEndpoint(generic, communal, true);
  logger("Requestz: $essence");
  switch (essence) {
    case login:
      url = enp.getEndpoint(login, communal, true);
      break;
  }
  // String url = enp.getEndpoint(login, communal, true);

  Map<String, dynamic>? data_ =
      await postReq(url, tag, rqstElite, login, urlEnc, "", context, true);

  logger("Data: ${jsonEncode(data_)}");

  if (data_ != null) {
    txt = data_;
    String dtt = jsonEncode(data_);
    ServerPrelim svp = ServerPrelim.fromJson(jsonDecode(dtt));
    Object obj = svp.msg;
    if (svp.status) {
      ServerResponse svr = ServerResponse.fromJson(jsonDecode(dtt));
      // Navigator.pop();
      try {
        switch (essence) {
          case login:
            LoginUser(context!, obj, svr, essence);
            break;
          case prelim:
            pref.setPrefString(appState, prvsnd);
            break;
          case prvsnd:
            logger("Hello: $data_");

            break;
        }
      } catch (e) {
        logger("Login procession error: $e");
      }
    } else {
      customSnackBar(context!, "***${obj.toString()}***");
    }
  }

  // signin = false;
  // otp = false;
  // logger("Done with sign in procession");
  // setState(() {});

  return txt;
}
