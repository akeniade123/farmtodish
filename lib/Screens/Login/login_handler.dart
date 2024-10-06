import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../global_handlers.dart';
import '../../global_objects.dart';
import '../../global_widgets.dart';
import '../../memory_analyst.dart';
import '../../requester.dart';

class LoginHandler {
  DatabaseHelper loginPreference = DatabaseHelper(
      fieldString: 'toKeepMe int,pin TEXT',
      tableName: 'preLoginDetails',
      dbName: 'preLoginDetails.db');
  DatabaseHelper userDetailsRetreiver = DatabaseHelper(
      dbName: 'userDetails.db',
      tableName: 'signUpTable',
      fieldString:
          'Full_Name TEXT, gender TEXT, birthday TEXT, email TEXT, PhoneNumber TEXT, password TEXT,pin TEXT, Unique_ID TEXT');

  Future<Map<String, dynamic>?> fetchDetail() async {
    Map<String, dynamic>? result;

    List<Map<String, dynamic>> rawResult =
        await loginPreference.getAll('preLoginDetails');
    avoid_print('rawResult is $rawResult');

    if (rawResult.isNotEmpty) {
      try {
        result = rawResult[0];

        avoid_print('result is $result');
      } catch (e) {
        avoid_print('error ti wa oo odo');
        avoid_print(e);
      }
    }
    // result = rawResult[0];
    return result;
  }

  Future<Map<String, dynamic>> getOTP(String fullName) async {
    Map<String, dynamic> result = {};
    String url = 'https://www.elitepage.com.ng/base/user/entry';

    Map<String, dynamic> body = {
      "regId": "kljnjknkjnkjnbjkkjhkhj",
      "Full_Name": fullName,
      'Essence': 'Profile',
      'domain': 'PasswordOTP'
    };

    Map<String, dynamic> rawResult = await requestResources(url, body,
        {'authentication': '937a4a8c13e317dfd28effdd479cad2f'}, 'post');

    custom_print(rawResult, 'retrievePassword');
    result = rawResult;

    return result;
  }

  Future<Map<String, dynamic>> resetPassword(
      String fullName, String password) async {
    Map<String, dynamic> result = {};
    String url = 'https://www.elitepage.com.ng/base/user/entry';

    Map<String, dynamic> body = {
      "regId": "kljnjknkjnkjnbjkkjhkhj",
      "Full_Name": fullName,
      'Essence': 'Profile',
      'domain': 'ResetPassword',
      'Password': password
    };

    Map<String, dynamic> rawResult = await requestResources(url, body,
        {'authentication': '937a4a8c13e317dfd28effdd479cad2f'}, 'post');

    custom_print(rawResult, 'retrievePassword');
    // DateTime(year).difference(DateTime.now()).inHours;

    return result;
  }

  Future<bool> login(
      BuildContext context, Map<String, String> body, bool keepMe) async {
    custom_print(body, 'checking body');
    bool result = false;
    // bool checkLogin = false;
    Future.delayed(
      const Duration(seconds: 20),
      () {
        if (!result) {
          return result;
        }
      },
    );

    // 937a4a8c13e317dfd28effdd479cad2f
    final headers = {
      'authentication': '937a4a8c13e317dfd28effdd479cad2f',
    };

    avoid_print('body is $body ' * 40);
    rootNavigatorKey.currentState!.overlay!.context.pushNamed("loading");
    // Navigator.of(rootNavigatorKey.currentState!.overlay!.context)
    //     .push(DialogRoute(
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

    bool isMainProcessSuccessful = (await () async {
      try {
        // under try
        response = await signIn(body, headers)
            // .timeout(
            //   const Duration(seconds: 130),
            //   onTimeout: () {
            //     return Response(json.encode({'status': false}), 200);
            //   },
            // )
            ;

        if (handleJsonResponse(response!)?['status'] != true) {
          // custom_print(handleJsonResponse(response!), 'status ti ni problem');
          print(response?.body);
          print(handleJsonResponse(response!));

          // custom_print(handleJsonResponse(response!), 'status ti ni problem');
          // there is a scene where users may want to login into another device while still signed in on one
          if (handleJsonResponse(response!)?["message"] ==
              "user already logged in") {
            bool toLogin = (await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    print("object");
                    return AlertDialog(
                      title: Text(
                        "You cannot log in on more than one device \n do you want to logout of other device and continue with this one",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: [
                        MaterialButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.pop<bool>(context, true);
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        MaterialButton(
                          shape: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          // ShapeBorder(),
                          onPressed: () {
                            Navigator.pop<bool>(context, false);
                          },
                          child: Text("No"),
                        ),
                      ],
                    );
                  },
                )) ??
                false;
            if (toLogin) {
              Response signOutResponse =
                  await signOut({"email": body?["email"] ?? ""}, headers);

              response = await signIn(body, headers);
            }
            // custom_print(toLogin, "special");
            return toLogin;
          } else {
            return false;
          }
        } else {
          // custom_print(response!.body, 'checking response body');

          return true;
        }
      } catch (e) {
        // custom_print(e, 'mainprocessError');
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
      avoid_print('isMainProcessSuccessful 2 error');
      // custom_print(
      //     rootNavigatorKey.currentState!.overlay!.widget, 'widget on overlay');
      // if (rootNavigatorKey.currentState!.overlay!.widget is Center) {
      //
      // }
      Navigator.of(rootNavigatorKey.currentState!.overlay!.context).pop();
      Navigator.of(rootNavigatorKey.currentState!.overlay!.context).push(
          DialogRoute(
              barrierColor: Colors.white.withAlpha(120),
              context: context,
              builder: (context) => const ErrorPage()));
      await Future.delayed(
        const Duration(milliseconds: 1500),
        () {
          Navigator.of(rootNavigatorKey.currentState!.overlay!.context).pop();
        },
      );
    } else {
      print("Main process successful " * 70);
      // other processes function
      bool isOtherProcessSuccessful = await (() async {
        // under try
        result = true;
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
                'gender': storedBody['Gender'],
                'email': storedBody['Email'],
                'birthday': (DateTime.tryParse(storedBody['birthday']) == null)
                    ? null
                    : DateUtils.dateOnly(
                            DateTime.tryParse(storedBody['birthday'])!)
                        .toString(),
                // 'birthday': storedBody['birthday'],

                // DateUtils.dateOnly(dateOfBirth!)
                'PhoneNumber': storedBody['Phone'],
                'password': body['password'],
                'Unique_ID': storedBody['Unique_ID']
              }, 'signUpTable')
            : 'do nothing';

        // .........

        print('Signup table');
        print((await userDetailsRetreiver.getAll('signUpTable')));
        print("XXXXX" * 120);
        print(await loginPreference.getAll("preLoginDetails"));

        // remember user or not************************
        await () async {
          await loginPreference.clearTable('preLoginDetails');
          await loginPreference.insert(
              {"toKeepMe": keepMe ? 1 : 0},
              // (((keepMe)
              //     ? preLoginBody
              //     : () {
              //         preLoginBody.removeWhere(
              //             (key, value) => key.toLowerCase() == 'password');
              //         return preLoginBody;
              //       }.call())),
              'preLoginDetails');
        }.call();
        print("XXXXX" * 120);
        print(await loginPreference.getAll("preLoginDetails"));
        print("3" * 200);
        Map<String, dynamic> userDetails =
            (await userDetailsRetreiver.getAll('signUpTable'))[0];
        Provider.of<UserHandler>(context, listen: false)
            .storeOtherUserDetails(userDetails);
        print("4" * 200);
        print(
            Provider.of<UserHandler>(context, listen: false).otherUserDetails);

        print("7" * 200);

        print("-_-" * 200);
        // Provider.of<UserHandler>(context, listen: false)
        //     .storeCryptoDetail(cryptoDetail[0]);

        await context
            .read<TransactionHistoryHandler>()
            .getHistoryOnlineAndStoreOffline(
                userID:
                    context.read<UserHandler>().otherUserDetails['Unique_ID']);

        print('fer_ref' * 100);
        print('fer_ref' * 100);
        print("10" * 200);

        return true;
        // WATCH
        try {} catch (e) {
          avoid_print('the error is ');
          avoid_print(e);
          custom_print(e, 'otherProcessError');
          return false;
        }
      }.call());

      avoid_print(handleJsonResponse(response!)!['statucontext.oves']);
      if (isOtherProcessSuccessful) {
        print("other process successful " * 70);
        if (context.mounted) {
          rootNavigatorKey.currentState!.overlay!.context.pushNamed("success");
        }
        // Navigator.of(rootNavigatorKey.currentState!.overlay!.context.ove).pop();
        // Navigator.of(rootNavigatorKey.currentState!.overlay!.context).push(
        //     DialogRoute(
        //         barrierColor: Colors.white.withAlpha(120),
        //         context: context,
        //         builder: (context) => const SuccessPage()));

        await Future.delayed(
          const Duration(milliseconds: 1500),
          () {
            // Navigator.of(rootNavigatorKey.currentState!.overlay!.context).pop();
            rootNavigatorKey.currentState!.overlay!.context.pop();
          },
        );

        if (context.mounted) context.go('/MyHomePage');

        // Navigator.of(rootNavigatorKey.currentState!.context).push(MaterialPageRoute(
        //   builder: (context) => const MainPage(),
        // ));
        // await newMethod(context);
        // Navigator.of(rootNavigatorKey.currentState!.context).pop();
        // Navigator.of(rootNavigatorKey.currentState!.context).popUntil(
        //   (route) => route.isFirst,
        // );

        // avoid_print('is logged in ' * 12);
      } else {
        // other process error
        // avoid_print(' other process error error $isOtherProcessSuccessful');
        Navigator.of(rootNavigatorKey.currentState!.overlay!.context).pop();
        Navigator.of(rootNavigatorKey.currentState!.overlay!.context).push(
            DialogRoute(
                barrierColor: Colors.white.withAlpha(120),
                context: context,
                builder: (context) => const ErrorPage()));
        await Future.delayed(
          const Duration(milliseconds: 1500),
          () {
            Navigator.of(rootNavigatorKey.currentState!.overlay!.context).pop();
          },
        );
      }
    }

    (handleJsonResponse(response!)?['status'] != true)
        ? result = false
        : result = true;

    return result;
  }

  Future<Null> newMethod(BuildContext context) async {
    return await () async {
      print("%%^^%%^^" * 120);
      Map<String, dynamic> userDetails =
          (await loginPreference.getAll('preLoginDetails'))[0];
      print(userDetails);
      print(userDetails['pin'].runtimeType);

      if (userDetails['pin'] != null &&
          userDetails['pin'].toString().isNotEmpty) {
        Future.delayed(
          Duration.zero,
          () {
            Provider.of<UserHandler>(context, listen: false)
                .storePin(userDetails['pin']);
          },
        );
      } else {
        print(userDetails);
        print(userDetails['pin'].runtimeType);

        // await showDialog(
        //   barrierColor: Colors.white.withAlpha(170),
        //   context: context,
        //   builder: (context) => Alert1(),
        // );

        // await Navigator.of(context).push(DialogRoute(
        //   context: context,
        //   builder: (context) => Alert1(),
        // ));

        print(userDetails);
        print(userDetails['pin'].runtimeType);
      }
    }.call();
  }

  // rememberUser(bool rem) {
  //   isLoggedIn = rem;
  // }

  Future<bool> fetchUserDetailsIfUserIsRemembered(BuildContext context) async {
    bool result = false;

    // other processes function
    bool isOtherProcessSuccessful = await (() async {
      // under try
      try {
        result = true;
        // login detail storer

        Map<String, dynamic> userDetails =
            (await userDetailsRetreiver.getAll('signUpTable'))[0];
        Provider.of<UserHandler>(context, listen: false)
            .storeOtherUserDetails(userDetails);

        //  [];

        // (await userCryptoDetails.getAll('addressDetails'));

        custom_print(
            await userDetailsRetreiver.getAll('signUpTable'), 'totality');

        await () async {
          print("111111" * 120);

          print("2222" * 120);

          print("3333" * 120);
        }.call();
        print("77777" * 120);

        return true;
        // WATCH
      } catch (e) {
        custom_print(e, 'otherProcessError');
        return false;
      }
    }.call());

    if (isOtherProcessSuccessful) {
      result = true;
      print("other process successful " * 70);
      // custom_print("user details fetchec", "about");

      await () async {
        Map<String, dynamic> userDetails =
            (await loginPreference.getAll('preLoginDetails'))[0];
        if (userDetails['pin'] != null &&
            userDetails['pin'].toString().isNotEmpty) {
          Future.delayed(
            Duration.zero,
            () {
              Provider.of<UserHandler>(context, listen: false)
                  .storePin(userDetails['pin']);
            },
          );
        } else {
          // showDialog(
          //   barrierColor: Colors.white.withAlpha(170),
          //   context: context,
          //   builder: (context) => Alert1(),
          // );
          // Navigator.of(context).push(DialogRoute(
          //   context: context,
          //   builder: (context) => Alert1(),
          // ));
        }
      }.call();
      // Navigator.of(rootNavigatorKey.currentState!.context).pop();
      // Navigator.of(rootNavigatorKey.currentState!.context).popUntil(
      //   (route) => route.isFirst,
      // );

      avoid_print('is logged in ' * 12);
    } else {
      // other process error
      avoid_print(' other process error error $isOtherProcessSuccessful');
      Navigator.of(rootNavigatorKey.currentState!.overlay!.context).pop();
      Navigator.of(rootNavigatorKey.currentState!.overlay!.context).push(
          DialogRoute(
              barrierColor: Colors.white.withAlpha(120),
              context: context,
              builder: (context) => const ErrorPage()));
      await Future.delayed(
        const Duration(milliseconds: 1500),
        () {
          Navigator.of(rootNavigatorKey.currentState!.overlay!.context).pop();
        },
      );
    }
    return result;
  }
}

Map<String, dynamic>? handleJsonResponse(Response response) {
  Map<String, dynamic>? jsonResponse = json.decode(response.body);
  if (response.statusCode == 200) {
    jsonResponse = json.decode(response.body);
  } else {}
  return jsonResponse;
}
