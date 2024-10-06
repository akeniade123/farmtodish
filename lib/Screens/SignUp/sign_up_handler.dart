// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

// import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../global_handlers.dart';
import '../../global_objects.dart';
import '../../global_widgets.dart';
import '../../memory_analyst.dart';
import '../../requester.dart';

// import "package:dio/dio.dart" as dio;

class SignUpHandler {
  Map<String, dynamic> storedBody = {};

  late DatabaseHelper userCryptoDetails;
  DatabaseHelper signUpDetailsRecorder = DatabaseHelper(
      dbName: 'userDetails.db',
      tableName: 'signUpTable',
      fieldString:
          'Full_Name TEXT, gender TEXT, birthday TEXT, email TEXT, PhoneNumber TEXT, password TEXT,pin TEXT,Unique_ID TEXT');

  SignUpHandler() {
    signUpDetailsRecorder.createTable(
        ' CREATE TABLE IF NOT EXISTS signUpTable (   id INTEGER PRIMARY KEY AUTOINCREMENT, Full_Name TEXT, gender TEXT, birthday TEXT, email TEXT, PhoneNumber TEXT, password TEXT )');
  }
  void deleteDB() async {
    Database db = signUpDetailsRecorder.database!;
    await databaseFactory.deleteDatabase(db.path);
    Database db2 = userCryptoDetails.database!;
    await databaseFactory.deleteDatabase(db2.path);
  }

  Future<void> signUp(BuildContext context, Map<String, String?> body) async {
    Map<String, dynamic> storedBody = {};
    // 937a4a8c13e317dfd28effdd479cad2f

    final headers = {
      'authentication': '937a4a8c13e317dfd28effdd479cad2f',
    };
    avoid_print('body check ' * 20);
    avoid_print(body);
    avoid_print('body check ' * 20);

    (!body.containsKey('Essence')) ? storedBody = body : 1;
    avoid_print('storedBody ' * 20);
    avoid_print(storedBody);
    avoid_print('storedBody ' * 20);

    body.addEntries({
      // 'Essence': 'Register',
      // 'regId': const Uuid().v1(),
      'deviceID': deviceIdInString.toString(),
      // 'Designation': 'NA',
      // 'Manifest': 'Community',
    }.entries);
// email:str
//     password:str
//     firstName: Optional[str] = None
//     lastName: Optional[str] = None
//     PhoneNumber: Optional[str] = None
//     birthday: Optional[str] = None
//     gender: Optional[str] = None
//     deviceID: Optional[str] = None

    rootNavigatorKey.currentState!.overlay!.context.pushNamed("loading");
    // Navigator.of(rootNavigatorKey.currentState!.overlay!.context)
    //     .push(DialogRoute(
    //   barrierColor: Colors.white.withAlpha(120),
    //   context: context,
    //   builder: (context) => Container(
    //     color: Colors.white.withAlpha(100),
    //     child: Center(
    //       child: CircularProgressIndicator(
    //         color: Theme.of(context).primaryColor,
    //       ),
    //     ),
    //   ),
    // ));
    final response = await requesterSignUp(body, headers);
    custom_print('jargon', 'jaga jaga');
    custom_print(response.body, 'jaga jaga');
    // if (response.statusCode==200){}
    if (handleJsonResponse(response)?['status'] != true) {
      rootNavigatorKey.currentState!.overlay!.context.pop();
      rootNavigatorKey.currentState!.overlay!.context.pushNamed("error");
      Future.delayed(
        const Duration(seconds: 1),
        () {
          rootNavigatorKey.currentState!.overlay!.context.pop();
        },
      );
    } else {
      avoid_print(handleJsonResponse(response)!['status']);

      storedBody.removeWhere((key, value) => {
            'Essence': 'Register',
            'regId': '123456789',
            'DEVICE_ID': deviceIdInString.toString(),
            'Designation': 'NA',
            'Manifest': 'Community',
          }.containsKey(key));
      await signUpDetailsRecorder.createTable(
          ' CREATE TABLE IF NOT EXISTS signUpTable (   id INTEGER PRIMARY KEY AUTOINCREMENT, Full_Name TEXT, gender TEXT, birthday TEXT, email TEXT, PhoneNumber TEXT, password TEXT )');
      signUpDetailsRecorder.clearTable('signUpTable');

      await signUpDetailsRecorder.insert(storedBody, 'signUpTable');
      custom_print(body, "@#\$");

      // print("!!!!!!!" * 100);
      // print("loginStarted");
      await login(
          context,
          {
            'email': body['email'] as String,
            'password': body['password'] as String,
          },
          false);
      // Navigator.of(rootNavigatorKey.currentState!.overlay!.context).pop();
      rootNavigatorKey.currentState!.overlay!.context.pop();
      // Navigator.of(rootNavigatorKey.currentState!.overlay!.context).push(
      //     DialogRoute(
      //         barrierColor: Colors.white.withAlpha(120),
      //         context: context,
      //         builder: (context) => const SuccessPage()));
      rootNavigatorKey.currentState!.overlay!.context.pushNamed("success");
      await Future.delayed(const Duration(milliseconds: 2000), () {
        // Navigator.of(rootNavigatorKey.currentState!.overlay!.context).pop();
        rootNavigatorKey.currentState!.overlay!.context.pop();
        print("Going to my home page" * 100);
        context.go('/MyHomePage');
        // Navigator.of(rootNavigatorKey.currentState!.context).push(MaterialPageRoute(
        //   builder: (context) => const MainPage(),
        // ));
      });
    }
    // avoid_print('objectify ' * 10);

    // return response; // userCryptoDetails.insert(rawResult!, 'addressDetails');
  }

  // Future<String> createAddress() async {
  //   String result = '';
  //   Map<String, dynamic> rawResult = await cryptoHandler.createAddress();
  //   userCryptoDetails.insert(rawResult, 'addressDetails');
  //   result = rawResult['address'];

  //   return result;
  // }

  // Future<Map<String, dynamic>> createCryptoWallet(
  //     String email, String userId) async {
  //   Map<String, dynamic>? result = {};

  //   return result;
  // }

  // rememberUser(bool rem) {
  //   isLoggedin = rem;
  // }
}

// login after sign up **********************************************************88888888888

Future<bool> login(
    BuildContext context, Map<String, String> body, bool keepMe) async {
  custom_print(body, 'checking body');
  print('00000');
  bool result = false;
  // bool checkLogin = false;
  DatabaseHelper loginPreference = DatabaseHelper(
      fieldString:
          'toKeepMe BOOLEAN,Phone TEXT,Password TEXT Full_Name TEXT,pin TEXT',
      tableName: 'preLoginDetails',
      dbName: 'preLoginDetails.db');
  DatabaseHelper userDetailsRetreiver = DatabaseHelper(
      dbName: 'userDetails.db',
      tableName: 'signUpTable',
      fieldString:
          'Full_Name TEXT, gender TEXT, birthday TEXT, email TEXT, PhoneNumber TEXT, password TEXT,pin TEXT, Unique_ID TEXT');

  print('11111' * 111);
  Future.delayed(
    const Duration(seconds: 20),
    () {
      if (!result) {
        return result;
      }
    },
  );
  print('2222' * 111);
  // 937a4a8c13e317dfd28effdd479cad2f
  final headers = {
    'authentication': '937a4a8c13e317dfd28effdd479cad2f',
  };

  avoid_print('body is $body ' * 40);

  // Navigator.of(rootNavigatorKey.currentState!.overlay!.context).push(DialogRoute(
  //   barrierColor: Colors.white.withAlpha(120),
  //   context: context,
  //   builder: (context) => Container(
  //     color: Colors.white.withAlpha(100),
  //     child: Center(
  //         child: CircularProgressIndicator(
  //       color: Theme.of(context).primaryColor,
  //     )),
  //   ),
  // ));
  Response? response;
  print("ubuntu222 " * 100);
  bool isMainProcessSuccessful = (await () async {
    try {
      // under try
      print("ubuntu " * 100);
      response = await signIn(body, headers).timeout(
        const Duration(seconds: 13),
        onTimeout: () {
          return Response(json.encode({'status': false}), 200);
          // print("ubuntu " * 100);
        },
      );
      print("enddie " * 100);
      if (handleJsonResponse(response!)?['status'] != true) {
        custom_print(handleJsonResponse(response!), 'status ti ni problem');
        return false;
      } else {
        custom_print(response!.body, 'checking response body');
        custom_print(response, 'response re');
        print("***" * 100);
        print(response!.body);
        print("***" * 100);

        return true;
      }
    } catch (e) {
      custom_print(e, 'mainprocessError');
      // avoid_print('isMainProcessSuccessful error');
      // Navigator.of(rootNavigatorKey.currentState!.overlay!.context).pop();
      // Navigator.of(rootNavigatorKey.currentState!.overlay!.context)
      //     .push(MaterialPageRoute(
      //   builder: (context) => const Center(child: ErrorPage()),
      // ));
      // Future.delayed(
      //   const Duration(seconds: 1),
      //   () {
      //     Navigator.of(rootNavigatorKey.currentState!.overlay!.context).pop();
      //   },
      // );
      response = Response(json.encode({'status': 'false'}), 900);
      return false;
    }
  }.call());

  // if (response.statusCode==200){}

  if (!isMainProcessSuccessful) {
    // custom_print(
    //     rootNavigatorKey.currentState!.overlay!.widget, 'widget on overlay');
    // if (rootNavigatorKey.currentState!.overlay!.widget is Center) {
    //
    // }
    // Navigator.of(rootNavigatorKey.currentState!.overlay!.context).pop();
    rootNavigatorKey.currentState!.overlay!.context.pushNamed("error");
    // Navigator.of(rootNavigatorKey.currentState!.overlay!.context).push(
    //     DialogRoute(
    //         barrierColor: Colors.white.withAlpha(120),
    //         context: context,
    //         builder: (context) => const ErrorPage()));
    await Future.delayed(
      const Duration(milliseconds: 1500),
      () {
        // Navigator.of(rootNavigatorKey.currentState!.overlay!.context).pop();
        // context.owner.
        rootNavigatorKey.currentState!.overlay!.context.pop();
        // Navig
      },
    );
  } else {
    print("Mainprocess successful " * 70);
    // other processes function
    bool isOtherProcessSuccessful = await (() async {
      try {
        // under try

        result = true;
        // 'hdjsdhfff'.contains(other)
        // login detail storer

        DatabaseHelper loginDetailsRecorder = DatabaseHelper(
            dbName: 'userDetails.db',
            tableName: 'signUpTable',
            fieldString:
                'Full_Name TEXT, gender TEXT, birthday TEXT, email TEXT, PhoneNumber TEXT, password TEXT,pin TEXT, Unique_ID TEXT');

        // loginDetailsRecorder.insert(data, tableNam);
        print("1" * 200);
        Map<String, dynamic> storedBody = (response != null)
            ? (handleJsonResponse(response!)?['data'][0] ?? {})
            : {};
        storedBody.removeWhere((key, value) => {
              'Essence': 'Register',
              'regId': '123456789',
              'DEVICE_ID': deviceIdInString.toString(),
              'Designation': 'NA',
              'Manifest': 'Community',
            }.containsKey(key));
        await loginDetailsRecorder.createTable(
            ' CREATE TABLE IF NOT EXISTS signUpTable (   id INTEGER PRIMARY KEY AUTOINCREMENT, Full_Name TEXT, gender TEXT, birthday TEXT, email TEXT, PhoneNumber TEXT, password TEXT,Unique_ID TEXT )');

//  id INTEGER PRIMARY KEY AUTOINCREMENT, Full_Name TEXT,
//Gender TEXT, birthday TEXT,
// Email_Address TEXT, Phone_Number TEXT, Password TEXT )');
        print("2" * 200);
        await loginDetailsRecorder.clearTable('signUpTable');
        (storedBody.isNotEmpty)
            ? await loginDetailsRecorder.insert({
                'Full_Name': storedBody['Name'],
                'gender': storedBody['gender'],
                'email': storedBody['Email'],
                'birthday': storedBody['birthday'],
                'PhoneNumber': storedBody['Phone'],
                'password': body['password'],
                'Unique_ID': storedBody['Unique_ID']
              }, 'signUpTable')
            : 'do nothing';

        print('Signup table');
        print((await userDetailsRetreiver.getAll('signUpTable')));
        print('Signup table');

        Map<String, String> preLoginBody = body;
        () {
          // loginPreference.clearTable('preLoginDetails');
          loginPreference.insert(
              (((keepMe)
                  ? preLoginBody
                  : () {
                      preLoginBody.removeWhere(
                          (key, value) => key.toLowerCase() == 'password');
                      return preLoginBody;
                    }.call())),
              'preLoginDetails');
        }.call();
        print("3" * 200);
        Map<String, dynamic> userDetails =
            (await userDetailsRetreiver.getAll('signUpTable'))[0];
        Provider.of<UserHandler>(context, listen: false)
            .storeOtherUserDetails(userDetails);
        print("4" * 200);

        return true;
        // WATCH
      } catch (e) {
        avoid_print('the error is ');
        avoid_print(e);
        custom_print(e, 'otherProcessError');
        return false;
      }
    }.call());

    avoid_print(handleJsonResponse(response!)!['status']);
    if (isOtherProcessSuccessful) {
      print("other process successful " * 70);

      // Navigator.of(rootNavigatorKey.currentState!.overlay!.context).pop();
      // Navigator.of(rootNavigatorKey.currentState!.overlay!.context).push(DialogRoute(
      //     barrierColor: Colors.white.withAlpha(120),
      //     context: context,
      //     builder: (context) => const SuccessPage()));
      // await Future.delayed(
      //   const Duration(milliseconds: 1500),
      //   () {
      //     Navigator.of(rootNavigatorKey.currentState!.overlay!.context).pop();
      //     Navigator.of(context).popUntil((route) => route.isFirst);
      //     Navigator.of(context).pop();
      //   },
      // );

      // watchout !!!!!!! so i am conflicted between using the pop and push and the go
      // context.goNamed("success");
      // rootNavigatorKey.currentState!.overlay!.context.pop();
      // rootNavigatorKey.currentState!.overlay!.context.pushNamed("success");
      // watchout
      rootNavigatorKey.currentState!.overlay!.context.goNamed("success");

      // await () async {

      //   Map<String, dynamic> userDetails =
      //       (await loginPreference.getAll('preLoginDetails'))[0];
      //   if (userDetails['pin'] != null &&
      //       userDetails['pin'].toString().isNotEmpty) {
      //     Future.delayed(
      //       Duration.zero,
      //       () {
      //         Provider.of<UserHandler>(context, listen: false)
      //             .storePin(userDetails['pin']);
      //       },
      //     );
      //   } else {
      //   showDialog(
      //   barrierColor: Colors.white.withAlpha(170),
      //   context: context,
      //   builder: (context) => Alert1(),
      // );

      //     // Navigator.of(context).push(DialogRoute(
      //     //   context: context,
      //     //   builder: (context) => Alert1(),
      //     // ));
      //   }
      // }.call();
      // showDialog(
      //   barrierColor: Colors.white.withAlpha(170),
      //   context: context,
      //   builder: (context) => Alert1(),
      // );
      // Navigator.of(rootNavigatorKey.currentState!.context).pop();
      // Navigator.of(rootNavigatorKey.currentState!.context).popUntil(
      //   (route) => route.isFirst,
      // );

      // avoid_print('is logged in ' * 12);
    } else {
      // other process error
      // avoid_print(' other process error error $isOtherProcessSuccessful');
      // Navigator.of(rootNavigatorKey.currentState!.overlay!.context).pop();
      // Navigator.of(rootNavigatorKey.currentState!.overlay!.context).push(
      //     DialogRoute(
      //         barrierColor: Colors.white.withAlpha(120),
      //         context: context,
      //         builder: (context) => const ErrorPage()));
      rootNavigatorKey.currentState!.overlay!.context.pushNamed("error");
      await Future.delayed(
        const Duration(milliseconds: 1500),
        () {
          // Navigator.of(rootNavigatorKey.currentState!.overlay!.context).pop();
          rootNavigatorKey.currentState!.overlay!.context.pop();
        },
      );
    }
  }

  (handleJsonResponse(response!)?['status'] == false ||
          handleJsonResponse(response!)?['status'] == null)
      ? result = false
      : result = true;

  return result;
}

// rememberUser(bool rem) {
//   isLoggedin = rem;
// }

Future<Map<String, dynamic>> fetchCryptoDetail(String email) async {
  Map<String, dynamic> result = {};
  String url = '$baseURL/fetch_crypto_details';

  // dio.FormData body = dio.FormData.fromMap({
  //   "Essence": "access",
  //   "regId": ";lkmlkmflkmlfkmf",
  //   "Designation": "content",
  //   "Tag": json.encode({
  //     "Essence": "crypto",
  //     "State": "read_expl",
  //     "Manifest": {"user_id": email}
  //   })
  // });
  // dio.Response response = await dio.Dio().postUri(Uri.parse(url),
  //     data: body,
  //     options: dio.Options(
  //         headers: {'authentication': '937a4a8c13e317dfd28effdd479cad2f'}));

  Map<String, dynamic> rawResult = await requestResources(
      url,
      {"email": email},
      {},
      // {'authentication': '937a4a8c13e317dfd28effdd479cad2f'},
      'encoded_post');

  // custom_print(response.data, 'request result is getting  ');
  // Map<String, dynamic> rawResult =
  //     (response.data is List) ? {"result": response.data} : response.data;
  if (rawResult['status']) {
    custom_print(rawResult, 'fetchCryptoDetail');
    for (var i in rawResult["data"]) {
      print("+++++" * 120);
      print(i);
      print("|||||" * 120);

      var j = json.decode(i);
      print(j);
      print(j[0]);
      print("|||||" * 120);
      print(j[0].runtimeType);

      print("|||||" * 120);
      print(i);

      print("+++++" * 120);
      i = json.decode(i);

      result.addAll({
        i['detail']["walletBlockchain"]: {'address': i['address']}
      });
    }
    // result={json.decode(rawResult["data"][0]['detail'])["walletBlockchain"]}
  } else {}

  return result;
}

// *****************************************************************************************************
Map<String, dynamic>? handleJsonResponse(Response response) {
  Map<String, dynamic>? jsonResponse;
  if (response.statusCode == 200 || response.statusCode == 201) {
    jsonResponse = json.decode(response.body);
    avoid_print('Parsed JSON: $jsonResponse');
  } else {
    avoid_print('Error: ${response.statusCode}');
    avoid_print(' ${response.body}');
    avoid_print('Error report finished');
  }
  return jsonResponse;
}
