import 'dart:convert';

import 'package:flutter/material.dart';

import '../global_string.dart';
import 'endpoints.dart';
import 'requester.dart';
import 'service_protocols.dart';

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

Map<String, String> formRequisite() {
  Map<String, String> hsh = {
    "Essence": "access",
    "Designation": "content",
    "regId":
        "dySI7okZRX-4qGPfcyL72P:APA91bEr9xWX3dHLG78mdRckQ6soKdkeMhM9j1RWweb7ft_81wsiUiAp87OVPiiG0_QCCHkBaruykOPU9kqWXLcBdzuNlumkggBb3snA2sJP-6EHa6h-g7ikkydnoXBY4jzvKbUow6_z",
    "Full_Name": "Akeni Adeyinka",
    "Unique_ID": "334656#/topics/Ojo#New Class arm created#Talconer#Notify",
    "Password": "random",
  };
  return hsh;
}
