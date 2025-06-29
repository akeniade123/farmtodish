import 'dart:convert';

import 'package:farm_to_dish/Repository/databaseHelper.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../Screens/Login/login_screen.dart';
import '../global_handlers.dart';
import '../global_objects.dart';
import '../global_string.dart';
import '../global_widgets.dart';
import '../sharedpref.dart';
import 'endpoints.dart';
import 'requester.dart';
import 'requestmodel.dart';
import 'server_response.dart';
import 'service_protocols.dart';

Future<void> logout(BuildContext context) async {
  DatabaseHelper dbm = DatabaseHelper(table: mnf);
  List<Map<String, dynamic>> ddf = await dbm.queryAllRows();

  for (Map<String, dynamic> dd in ddf) {
    dbm.delete(dd);
  }
  userlog = {};

  SharedPref pref = SharedPref();
  await pref.setPrefBool(login, false);

  context.go("/");
}

Future<Map<String, dynamic>>? svrRqst(String table, String essence,
    [BuildContext? context]) async {
  Map<String, dynamic>? txt = {};
  Navigate nvg = Navigate();
  pref = SharedPref();
  Map<String, dynamic>? obj = {};

  switch (essence) {
    case prelim:
      Map<String, dynamic> mnf = {unq: userlog[unq]};
      Map<String, dynamic> ent = {"Fb_UID": userlog[rg]};

      obj = await nvg.entry(table, mnf, ent, mnf, global, "access", "content",
          false, upd_, context);
      // logger("Response: $obj");
      // await pref.setPrefString(appState, prvsnd);
      // pref = SharedPref();
      // await pref.setPrefBool(indexed, true);

      break;
    case intrmd:
      Map<String, dynamic> mnf = {unq: userlog[unq]};
      obj = await nvg.readData(
          table, mnf, global, "access", "content", false, rd);
      logger("Response: $obj");

      break;

    case prvsnd:
      break;
  }

  ServerPrelim? svp = ServerPrelim.fromJson(obj!); // as ServerPrelim?;
  if (svp.status) {
    // ServerResponse svr = ServerResponse.fromJson(jsonDecode(obj));
    // Navigator.pop();
    try {
      switch (essence) {
        case prelim:
          String? mssg = svp.msg as String?;
          logger("The Response: $mssg");
          Map<String, dynamic> appSet = cppt;
          appSet[appState] = prvsnd;
          appSet[indexed] = true;
          logger("Refactored: $appSet");
          if (mssg!.contains("successfully implemented")) {
            appSet[appState] = prvsnd;
          } else {
            appSet[appState] = intrmd;
          }

          DatabaseHelper dbm = DatabaseHelper(table: mnf);
          List<Map<String, dynamic>> ddf = await dbm.queryAllRows();

          for (Map<String, dynamic> dd in ddf) {
            dbm.delete(dd);
          }

          await dbm.insertData({cpt: jsonEncode(appSet)});

        case intrmd:
          ServerResponse svr = ServerResponse.fromJson(obj);

          break;

        case prvsnd:
          //  logger("Hello: $data_");

          break;
      }
    } catch (e) {
      logger("Login procession error: $e");
    }
  }

  //logger(jsonEncode(dtt));
  // FetchData(tag, essence, context);
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
            await pref.setPrefString(appState, prvsnd);
            pref = SharedPref();
            await pref.setPrefBool(indexed, true);
            break;
          case prvsnd:
            logger("Hello: $data_");

            break;
        }
      } catch (e) {
        logger("Login procession error: $e");
      }
    } else {
      switch (essence) {
        case prvsnd:
        case prelim:
          break;
        default:
          customSnackBar(context!, "***${obj.toString()}***");
          break;
      }
    }
  }

  // signin = false;
  // otp = false;
  // logger("Done with sign in procession");
  // setState(() {});

  return txt;
}
