import 'dart:convert';

import 'package:flutter/material.dart';

import '../Repository/databaseHelper.dart';
import '../Screens/Login/login_screen.dart';
import '../global_handlers.dart';
import '../global_objects.dart';
import '../global_string.dart';
import '../sharedpref.dart';
import 'endpoints.dart';
import 'requester.dart';
import 'service_protocols.dart';

class Navigate {
  void transit(BuildContext context, var dest) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => dest));
  }

  Future<Map<String, dynamic>?>? tagPOST(
      String tbl,
      String func,
      String domain,
      String essence,
      String designation,
      Map<String, String> preMnfst,
      Map<String, String> mnfst,
      Object object,
      BuildContext context,
      bool show) async {
    Map<String, dynamic>? obj = {};

    Map<String, String> hsh = formRequisite();

    Map<String, String> jo = preMnfst;

    try {
      jo.addEntries({"Essence": tbl, "State": func}.entries);

      if (mnfst.isNotEmpty) {
        jo.addEntries({"Manifest": jsonEncode(mnfst)}.entries);
        //jo.addEntries({"Manifest": mnfst, , "State": func}.entries);
      }

      hsh.addEntries({"Tag": jsonEncode(jo)}.entries);

      Endpoint enp = Endpoint();

      String dmn = (domain == communal) ? communal : generic;
      obj = await postReq(enp.getEndpoint(dmn, desig, true), hsh, rqstElite,
          essence, designation, urlEnc, context, show);
    } on Exception catch (_) {}

    return obj;
  }

  Future<Map<String, dynamic>?> eliteRouter(
      String domain,
      String essence,
      String designation,
      bool show,
      BuildContext context,
      String table,
      String rep,
      String joint) async {
    Map<String, dynamic>? obj;
    Map<String, String> hsh = formRequisite();

    Map<String, String> prq = {
      "Essence": "access",
      "State": "specific_tsk",
      "Specific": "Router",
      "Table": table,
      "Rep": " $rep",
      "Joint": joint
    };

    hsh.addEntries({"Tag": jsonEncode(prq)}.entries);
    Endpoint enp = Endpoint();

    /*
    {
      "Essence":"access",
      "State":"specific_tsk",
      "Specific":"Router",
      "Table":"domains",
      "Rep":"d.id AS domain f.pay_with_bank AS bank, f.currency AS currency ",
      "Joint":" d INNER JOIN framework on d.id = f.tag WHERE d.Name = ElitePage"
    }
    */

    String dmn = (domain == communal) ? communal : generic;

    obj = await postReq(enp.getEndpoint(generic, dmn, true), hsh, rqstElite,
        essence, designation, urlEnc, context, show);

    if (obj != {}) {
      String dtt = jsonEncode(obj);
      try {
        if (dtt != "{}" || dtt != "null") {
          //  log("Hi***$dtt");
          return jsonDecode(dtt);
          // return ServerResponse.fromJson(jsonDecode(dtt));
        } else {
          return null;
        }
      } catch (e) {
        logger("Data error:${e.toString()}");
      }
    } else {
      return null;
    }

    return obj;
  }

  Map<String, String> formRequisite([String? essence]) {
    String rgg = "default";
    String unq_ = rgg;
    String nmm_ = rgg;
    try {
      rgg = userlog[rg];
      unq_ = userlog[unq];
      nmm_ = userlog[nmm];
    } catch (e) {}

    Map<String, String> hsh = {};

    if (essence != null) {
      switch (essence) {
        //case sp
      }
    } else {
      hsh = {
        "Essence": "access",
        "Designation": "content",
        "regId": rgg,
        "Full_Name": nmm_,
        "Unique_ID": unq_,
        "Password": "random",
      };
    }

    return hsh;
  }

  Future<Map<String, dynamic>?> readData(
      String table,
      Map<String, dynamic> manifest,
      String domain,
      String essence,
      String designation,
      bool show,
      String phase,
      [BuildContext? context]) async {
    Map<String, dynamic>? obj;

    Map<String, dynamic> tag = {};

    Map<String, String> hsh = formRequisite();

    switch (phase) {
      case rd_e:
        tag = {"Essence": table, "State": phase, "Manifest": manifest};
        break;
      case rd:
        tag = {"Essence": table, "State": phase};
        break;
    }

    hsh.addEntries({"Tag": jsonEncode(tag)}.entries);

    Endpoint enp = Endpoint();

    String dmn = (domain == communal) ? communal : generic;
    try {
      obj = await postReq(enp.getEndpoint(generic, dmn, true), hsh, rqstElite,
          essence, designation, urlEnc, context, show);
    } catch (e) {}
    return obj;
  }

  Future<Map<String, dynamic>?> entry(
      String table,
      Map<String, dynamic> manifest,
      Map<String, dynamic> entries,
      Map<String, dynamic> constraint,
      String domain,
      String essence,
      String designation,
      bool show,
      String phase,
      BuildContext? context) async {
    Map<String, dynamic>? obj;

    Map<String, String> hsh = formRequisite();

    switch (essence) {
      case chg:
        try {
          hsh = {
            "Essence": "Charge",
            "regId": ";lkmlkmflkmlfkmf",
            "Designation": "Charge",
            "sect": "lone"
          };
//"data":{↵   "email":"adeyinkaakeni@gmail.com",↵   "amount":"20000",↵   "metadata":{↵      "value":"Lagos",↵      "display_name":"Fund Wallet",↵      "variable_name":"Card Funding",↵      "sect":"wallet",↵      "time":"2023-10-20 15:34",↵      "amount":"20000",↵      "reg_Id":"954948848484848",↵      "domain":"107",↵      "name":"Akeni Adeyinka David",↵      "user_id":"909891",↵      "description":"Fund Wallet"↵   },↵   "card":{↵      "cvv":"408",↵      "number":"4084084084084081",↵      "expiry_month":"02",↵      "expiry_year":"26"↵   },↵   "pin":"1234"↵}

          Map<String, dynamic> dtt_ = {
            "email": "adeyinkaakeni@gmail.com",
            "amount": {currentOrder?.getTotalPrice() ?? amount}.toString(),
            "metadata": {
              "value": "Lagos",
              "display_name": "Fund Wallet",
              "variable_name": "Card Funding",
              "sect": "wallet",
              "time": "2023-10-20 15:34",
              "amount": {currentOrder?.getTotalPrice() ?? amount}.toString(),
              "reg_Id": "954948848484848",
              "domain": "107",
              "name": "Akeni Adeyinka David",
              "user_id": "909891",
              "description": "Fund Wallet"
            },
            /*
            "card": {
              "cvv": cvnum,
              "number": cdnum,
              "expiry_month": dynum,
              "expiry_year": yrnum
            },
            */
            "pin": pnum.toString()
          };

          hsh.addEntries({"data": jsonEncode(dtt_)}.entries);
        } catch (e) {
          logger("Transaction error: $e");
        }

        break;

      default:
        Map<String, dynamic> tag = {
          "Essence": table,
          "State": phase,
          "Manifest": manifest,
          "Entries": entries,
          "Constraint": constraint
        };

        hsh.addEntries({"Tag": jsonEncode(tag)}.entries);
        break;
    }

    Endpoint enp = Endpoint();

    String dmn = (domain == communal) ? communal : generic;
    try {
      String dmm = generic;
      switch (essence) {
        case chg:
          dmm = chg;
          break;
      }
      obj = await postReq(enp.getEndpoint(dmm, dmn, true), hsh, rqstElite,
          essence, designation, urlEnc, context, show);
    } catch (e) {
      logger(e.toString());
    }
    return obj;
  }

  Future<Map<String, dynamic>?> specificPOST(
      String tbl,
      String func,
      String domain,
      String essence,
      String designation,
      Map<String, String> preMnfst,
      Map<String, String> mnfst,
      String specific,
      Object object,
      bool show,
      BuildContext context) async {
    Map<String, dynamic>? obj = {};
    Map<String, String> hsh = formRequisite();

    Map<String, String> jo = preMnfst;
    try {
      jo.addEntries({"Essence": tbl, "State": func}.entries);

      if (mnfst.isNotEmpty) {
        jo.addEntries(
            {"Manifest": mnfst}.entries as Iterable<MapEntry<String, String>>);
      }

      jo.addEntries({
        'Specific': specific,
        'User': '7657633',
        'Name': 'Akeni Adeyinka',
        'domain': 'chkk'
      }.entries);

      hsh.addEntries({"Tag": jsonEncode(jo)}.entries);

      Endpoint enp = Endpoint();

      String dmn = (domain == communal) ? communal : generic;

      obj = await postReq(enp.getEndpoint(generic, dmn, true), hsh, rqstElite,
          essence, designation, urlEnc, context, show);
    } on Exception catch (_) {}

    return obj;
  }

  Future<void> LogOut(BuildContext context) async {
    DatabaseHelper dbh = DatabaseHelper(table: usrTbl);
    SharedPref pref = SharedPref();
    String? usr = await pref.getPrefString(fln);
    logger("Current User:$usr");
    try {
      if (usr!.isNotEmpty) {
        Map<String, dynamic> clause = {nmm: usr};
        await dbh.delete(clause);
      }
    } catch (e) {
      logger('logout error:${e.toString()}');
    }

    if (await dbh.queryRowCount() < 1) {
      Navigate().transit(context, const LoginScreen());
      SharedPref pref = SharedPref();
      pref.setPrefBool(lgn, false);
    }
  }
}
