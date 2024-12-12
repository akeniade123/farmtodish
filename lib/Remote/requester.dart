// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import '../global_string.dart';
import '../global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../sharedpref.dart';
import 'service_protocols.dart';

Future<http.Response> signIn(Map<String, String> body, headers) async {
  body.addEntries(
      {'Essence': 'Phone_No_Login', 'regId': 'kljnjknkjnkjnbjkkjhkhj'}.entries);
  final response = await http.post(
    Uri.parse('https://www.elitepage.com.ng/base/user/entry'),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    // Successful response
    log('Response: ${response.body}');
    // return true;
  } else {
    // Error response
    log('Error: ${response.statusCode}');
    // return false;
  }
  // log('this is the header of the response ${response.headers}');
  return response;
}

Future<bool> internetAvailable(BuildContext? context, bool display) async {
  bool result = await InternetConnectionChecker().hasConnection;
  if (result == true) {
    log('YAY! Free cute dog pics!');
    log("Internet Access is available");
  } else {
    result = false;
    log('No internet :( Reason:');

    log("Internet Access is unavailable");
    if (display) {
      customSnackBar(context!, "Internet Access is unavailable");
    }
    // log(InternetConnectionChecker().lastTryResults);
  }
  return result;
}

Future<http.Response> requesterSignUp(Map<String, String> body, headers) async {
  final response = await http.post(
    Uri.parse('https://www.elitepage.com.ng/yomcoin/class/prt'),
    body: body,
    headers: headers,
  );

  // if (response.statusCode == 200) {
  //   // Successful response
  //   log('Response: ${response.body}');
  //   return true;
  // } else {
  //   // Error response
  //   log('Error: ${response.statusCode}');
  //   return false;
  // }

  return response;
}

// Future<Map<String, dynamic>?> fetchData() async {
//   final response = await http
//       .get(Uri.parse('https://www.elitepage.com.ng/yomcoin/user/entry'));

//   return handleJsonResponse(response, "");
// }

Map<String, String>? getHeader(String request) {
  Map<String, String>? headers_;
  switch (request) {
    case rqstAlbum:
      // 'Content-Type': 'application/json; charset=UTF-8',

      headers_ = {'Content-Type': 'application/json; charset=UTF-8'};
      break;
    case rqstElite:
      headers_ = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'authentication': '937a4a8c13e317dfd28effdd479cad2f'
      };
      break;
  }
  return headers_;
}

Future<Map<String, dynamic>?> getReq(String url, String request, String essence,
    BuildContext context, bool display) async {
  if (await internetAvailable(context, display)) {
    final response = await http
        .get(Uri.parse(url), headers: getHeader(request))
        .timeout(const Duration(seconds: 5), onTimeout: () {
      return http.Response('Error', 408);
    });
    return handleJsonResponse(response, essence, context, display);
  } else {
    return {};
  }
}

Future<String> getReqString(String url, String request, BuildContext context,
    bool display, int timeout) async {
  if (await internetAvailable(context, display)) {
    final response = await http
        .get(Uri.parse(url), headers: getHeader(request))
        .timeout(Duration(seconds: timeout), onTimeout: () {
      return http.Response('Error', 408);
    });
    return response.body;
    // handleJsonResponse(response, essence, context, display);
  } else {
    return "";
  }
}

Future<Map<String, dynamic>?> postReq(
    String url,
    Map<String, String> data,
    String request,
    String essence,
    String designation,
    String contentType,
    BuildContext? context,
    bool display) async {
  Map<String, dynamic> resp = {};
  SharedPref pref = SharedPref();

  switch (designation) {
    case sct:
    /*
      String? vl = await pref.getPrefString("i$designation");
      try {
        if (vl!.isNotEmpty) {
          return jsonDecode(vl);
        }
      } catch (e) {}
    */
    case dmn:
    default:
      try {
        if (await internetAvailable(context, display)) {
          Object data_ = data;
          switch (contentType) {
            case jsonCt:
              data_ = jsonEncode(data);
              break;
          }

          try {} catch (e) {}

          final response = await http
              .post(
            Uri.parse(url),
            headers: getHeader(request),
            body: data_,
          )
              .timeout(const Duration(seconds: 20), onTimeout: () {
            resp.addEntries(
                {"status": false, "message": "timeout error"}.entries);

            log("RequestExec:$essence");

            return http.Response('Error', 408);
          });

          /*
    Work on this error as well...
    _ClientSocketException (ClientException with SocketException: Connection reset by peer (OS Error: Connection reset by peer, errno = 104), address = www.elitepage.com.ng, port = 33306, uri=https://www.elitepage.com.ng/base/class/prt)
    */

          Response obj = response;
          if (response.statusCode == 200 || response.statusCode == 201) {
            //  String rsp = json.decode(response.body);

            try {
              Map<String, dynamic>? jsonResponse = json.decode(response.body);
              return handleJsonResponse(obj, designation, context, display);
            } catch (e) {
              resp = {};
              resp.addEntries({
                "status": false,
                "message": "Server Admin restraint, try again after some time"
              }.entries);
            }
          } else {
            log('Error: ${response.statusCode}');
            resp = {};
            resp.addEntries(
                {"status": false, "message": "${response.statusCode}"}.entries);

            return resp;
          }
        } else {
          resp.addEntries({
            "status": false,
            "message": "internet access is unavailable"
          }.entries);
        }
      } catch (e) {
        resp = {};
        resp.addEntries(
            {"status": false, "message": "server restraint"}.entries);
        return resp;
      }

      break;
  }

  return resp;
}

Map<String, dynamic>? handleJsonResponse(http.Response response,
    String designation, BuildContext? context, bool display) {
  Map<String, dynamic>? jsonResponse;
  int code = response.statusCode;
  final cache = DefaultCacheManager();
  SharedPref pref = SharedPref();

  if (code == 200) {
    jsonResponse = json.decode(response.body);

    //vdd   dmn   vdr  sct
    switch (designation) {
      case sct:
        pref.setPrefString("i$sct", jsonEncode(jsonResponse));
        // cache.putFile(designation, jsonResponse as Uint8List);
        break;
    }
    log('Parsed JSON: $jsonResponse');
  } else if (code == 408) {
    if (display == true) {
      customSnackBar(context!, "message");
    }
  } else {
    log('Error: ${response.statusCode}');
  }
  return jsonResponse;
}
