import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../Screens/Login/login_screen.dart';
import '../global_handlers.dart';
import '../global_string.dart';
import '../global_widgets.dart';
import 'endpoints.dart';
import 'requester.dart';
import 'server_response.dart';
import 'service_protocols.dart';

Future<Map<String, dynamic>>? FetchData(
    BuildContext context, Map<String, String> tag, String essence) async {
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
  String url = enp.getEndpoint(login, communal, true);

  Map<String, dynamic>? data_ = await postReq(
      enp.getEndpoint(login, communal, true),
      tag,
      rqstElite,
      login,
      urlEnc,
      "",
      context,
      true);

  if (data_ != null) {
    txt = data_;
    String dtt = jsonEncode(data_);
    ServerPrelim svp = ServerPrelim.fromJson(jsonDecode(dtt));
    Object obj = svp.msg;
    if (svp.status) {
      ServerResponse svr = ServerResponse.fromJson(jsonDecode(dtt));
      // Navigator.pop();
      try {
        LoginUser(context, obj, svr, essence);
      } catch (e) {
        logger("Login procession error: $e");
      }
    } else {
      customSnackBar(context, "***${obj.toString()}***");
    }
  }

  // signin = false;
  // otp = false;
  // logger("Done with sign in procession");
  // setState(() {});

  return txt;
}
