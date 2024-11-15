import 'dart:convert';

// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'global_objects.dart';
// import 'models/global_objects.dart';

Future<http.Response> signIn(
    Map<String, String> body, Map<String, String> headers) async {
  deviceId?.id;
  body.addEntries({
    'Essence': 'Profile',
    'regId': 'kljnjknkjnkjnbjkkjhkhj',
    'deviceID': (deviceId?.id ?? "")
  }.entries);
// old request object
  // final response = await http.post(
  //   Uri.parse('https://www.elitepage.com.ng/yomcoin/user/entry'),
  //   headers: headers,
  //   body: body,
  // );
// ***********************
  headers["Content-Type"] = "application/json";

  String encodedBody = json.encode(body);
  final response = await http.post(
    Uri.parse('$baseURL/login'),
    headers: headers,
    body: encodedBody,
  );
  if (response.statusCode == 200) {
    // Successful response
    // custom_print(object);
    // custom_print(response.body, "sign in response");
    // return true;
  } else {
    // Error response
    // avoid_print('Error: ${response.statusCode}');
    // return false;
  }

  return response;
}

Future<http.Response> signOut(
    Map<String, String> body, Map<String, String> headers) async {
  deviceId?.id;
  body.addEntries({
    'Essence': 'Profile',
    'regId': 'kljnjknkjnkjnbjkkjhkhj',
    'deviceID': (deviceId?.id ?? "")
  }.entries);
// old request object
  // final response = await http.post(
  //   Uri.parse('https://www.elitepage.com.ng/yomcoin/user/entry'),
  //   headers: headers,
  //   body: body,
  // );
// ***********************
  headers["Content-Type"] = "application/json";
  String encodedBody = json.encode(body);
  final response = await http.post(
    Uri.parse('$baseURL/logout'),
    headers: headers,
    body: encodedBody,
  );
  if (response.statusCode == 200) {
    // Successful response
    // custom_print(object);
    // custom_print(response.body, "sign in response");
    // return true;
  } else {
    // Error response
    // avoid_print('Error: ${response.statusCode}');
    // return false;
  }

  return response;
}

Future<http.Response> requesterSignUp(
    Map<String, String?> body, Map<String, String> headers) async {
  // final response = await http.post(
  //   Uri.parse('https://www.elitepage.com.ng/yomcoin/class/prt'),
  //   body: body,
  //   headers: headers,
  // );
  String encodedBody = json.encode(body);
  headers["Content-Type"] = "application/json";
  print(body);
  final response = await http.post(
    Uri.parse('$baseURL/signup'),
    body: encodedBody,
    headers: headers,
  );

  // if (response.statusCode == 200) {
  //   // Successful response
  //   avoid_print('Response: ${response.body}');
  //   return true;
  // } else {
  //   // Error response
  //   avoid_print('Error: ${response.statusCode}');
  //   return false;
  // }

  return response;
}

Future<Map<String, dynamic>> requestResources(
    String url, Object? body, Map<String, String> headers, String requestType,
    {Function(dynamic)? loggerFunction}) async {
  // custom_print(url, 'url');
  Uri parsedUrl = Uri.parse(url);
  http.Response response;

  if (requestType == 'get') {
    try {
      response = await http
          .get(
        parsedUrl,
        headers: headers,
      )
          .timeout(
        const Duration(minutes: 1),
        onTimeout: () {
          return http.Response(
              json.encode(
                  {"status": false, "message": "timeout check your network"}),
              700);
        },
      );
    } catch (e) {
      response = http.Response(json.encode({"status": false}), 700);
    }
  } else {
    if (requestType == 'encoded_post') {
      String encodedBody = json.encode(body);
      headers["Content-Type"] = "application/json";
      // {"Content-Type": "application/json"}
      try {
        response = await http
            .post(parsedUrl, body: encodedBody, headers: headers)
            .timeout(
          const Duration(minutes: 1),
          onTimeout: () {
            return http.Response(
                json.encode(
                    {"status": false, "message": "timeout check your network"}),
                700);
          },
        );
      } catch (e) {
        response = http.Response(json.encode({"status": false}), 700);
      }
    } else {
      try {
        response = await http
            .post(
          parsedUrl,
          body: body,
          headers: headers,
        )
            .timeout(
          const Duration(minutes: 1),
          onTimeout: () {
            return http.Response(
                json.encode(
                    {"status": false, "message": "timeout check your network"}),
                700);
          },
        );
      } catch (e) {
        response = http.Response(json.encode({"status": false}), 700);
      }
    }
  }
  // custom_print(handleJsonResponse(response), 'request result is getting  ');
  // custom_print(
  //     handleJsonResponse(response).runtimeType, 'request result is getting  ');

  Map<String, dynamic>? result = (handleJsonResponse(response) is List)
      ? {"result": handleJsonResponse(response)}
      : handleJsonResponse(response);
  loggerFunction?.call(result);
  return result ?? {};
}

// dncdbch
Future<String> requesterGetToken(
    {required String url,
    Map<String, String> body = const {},
    Map<String, String> headers = const {}}) async {
  String result = '';

  Uri parsedUrl = Uri.parse(url);
  final response = await http.post(
    parsedUrl,
    body: body,
    headers: headers,
  );
  try {
    result = await handleJsonResponse(response)!['access_token'];
  } catch (e) {
    for (int i in [1, 1, 1, 1, 1, 1, 1]) {
      // avoid_print('getTokenError');
    }
  }

  return result;
}

Future<Map<String, dynamic>?> fetchData() async {
  final response = await http
      .get(Uri.parse('https://www.elitepage.com.ng/yomcoin/user/entry'));

  return handleJsonResponse(response);
}

Future<Map<String, dynamic>?> getToken(String service) async {
  final response = await http.post(
      Uri.parse('https://www.elitepage.com.ng/yomcoin/user/entry'),
      body: {'service': service});

  return handleJsonResponse(response);
}

dynamic handleJsonResponse(http.Response response,
    {Function(dynamic)? loggerFunction}) {
  dynamic jsonResponse;
  // avoid_print('response.body yen is ' * 40);

  // custom_print(response.body, 'to inspect');
  // custom_print(response., 'to inspect');

  // custom_print(response.statusCode, 'Status code');?

  jsonResponse = json.decode(response.body);
  if (response.statusCode == 200) {
    jsonResponse = json.decode(response.body);
  } else {
    // avoid_print('Error: ${response.statusCode}');
  }

  try {
    jsonResponse = json.decode(jsonResponse);
  } catch (e) {}

  // custom_print(jsonResponse.runtimeType, 'runtimeType');
  // custom_print(jsonResponse, 'runtimeType');

  return jsonResponse;
}

class GbeseSignal {
  final String? userID;
  GbeseSignal({this.userID});
  Future<Map<String, dynamic>> sendGbeseSignal(
      String amount, String description) async {
    // String description = "Airtime recharge";

    Map<String, dynamic> result = {};

    Map<String, dynamic> body = {"userID": userID, "amount": amount};
    // {
    //   "Essence": "Charge",
    //   "regId": ";lkmlkmflkmlfkmf",
    //   "data": {
    //     "user": userID,
    //     "amount": amount,
    //     "sect": "wallet",
    //     "description": description
    //   },
    //   "Designation": "debit"
    // };

    Map<String, dynamic> rawResult = await requestResources("$baseURL/debit",
        body, {"Content-Type": "application/json"}, 'encoded_post');
    if (rawResult['status'] == true) {
      result = rawResult;
    } else {
      // custom_print('Error re oooooo yeyeyeye $rawResult', 'airtime Error');
    }

    return result;
  }

  Future<Map<String, dynamic>> sendAirtimeSignal(String amount) async {
    String description = "Airtime recharge";

    return sendGbeseSignal(amount, description);
  }

  Future<Map<String, dynamic>> sendDataSignal(String amount) async {
    String description = "Data recharge";
    return sendGbeseSignal(amount, description);
  }

  Future<Map<String, dynamic>> sendCableSignal(String amount) async {
    String description = "Cable recharge";

    return sendGbeseSignal(amount, description);
  }

  Future<Map<String, dynamic>> sendElectricitySignal(String amount) async {
    String description = "Electricity recharge";

    return sendGbeseSignal(amount, description);
  }

  Future<Map<String, dynamic>> sendGiftCardSignal(String amount) async {
    String description = "giftcard Purchase";
    return sendGbeseSignal(amount, description);
  }
}
