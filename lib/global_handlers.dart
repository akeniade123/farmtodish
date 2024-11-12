// import 'package:Yomcoin/memory_analyst.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:farm_to_dish/global_objects.dart';
import 'package:farm_to_dish/sharedpref.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import '../../models/global_objects.dart';x/x
import '../../requester.dart';
import 'Screens/Products/product_model.dart';
import 'global_string.dart';
import 'memory_analyst.dart';

class UserHandler extends ChangeNotifier {
  Map<String, dynamic> crytoDetailStored = {};
  String pinStored = '';
  String triedPin = '';
  String matchPin1 = '';
  String matchPin2 = '';

  Map<String, dynamic> otherUserDetails = {};
  bool hasPin = false;
  Future<String> getAmount(String uniqueID) async {
    String result = '';

    Map body = {'userID': uniqueID}; // result=rawResult ;

    Map<String, dynamic> rawResult = await requestResources('$baseURL/amount',
        body, {"Content-Type": "application/json"}, 'encoded_post');
    // custom_print([
    //   result,
    //   '|||',
    //   rawResult,
    //   rawResult.runtimeType,
    //   rawResult['data']['amount']
    // ], "#####");

    // Response response = await post(
    //     Uri.parse('https://www.elitepage.com.ng/base/class/prt'),
    //     body: body,
    //     headers: {
    //       'authentication': '937a4a8c13e317dfd28effdd479cad2f',
    // "Content-Type": "application/json",
    //     });

    // Map<String, dynamic> rawResult = handleJsonResponse(response);
    result = rawResult['data']['amount'].toString();
    // try {
    //   result = rawResult['data']['amount'];
    // } catch (e) {
    //   try {
    //     result = rawResult['data']['amount'];
    //   } catch (e) {}
    // }
    print(result);
    // custom_print([
    //   result,
    //   '|||',
    //   rawResult,
    //   rawResult.runtimeType,
    //   rawResult['data']['amount']
    // ], "#####");
    return result;
  }

  void storeCryptoDetail(Map<String, dynamic> crytoDetail) {
    crytoDetailStored = crytoDetail;
    notifyListeners();
  }

  void reset() {
    pinStored = '';
    triedPin = '';
    matchPin1 = '';
    matchPin2 = '';
    crytoDetailStored = {};
    otherUserDetails = {};
  }

  void storeOtherUserDetails(Map<String, dynamic> otherDetails) {
    otherUserDetails = otherDetails;
    notifyListeners();
  }

  void storePin(String pin) {
    pinStored = pin;
    hasPin = true;
    notifyListeners();
  }

  void storeTriedPin(String pin) {
    triedPin = pin;

    notifyListeners();
  }

  void storeMatchPin(String pin, bool first) {
    (first) ? matchPin1 = pin : matchPin2 = pin;
    notifyListeners();
  }

  Future<void> createPin(String pin) async {
    // avoid_print('pin creation started ' * 120);
    DatabaseHelper userPinRecorder = DatabaseHelper(
        dbName: 'userDetails.db',
        tableName: 'signUpTable',
        fieldString:
            'Full_Name TEXT, gender TEXT, birthday TEXT, email TEXT, PhoneNumber TEXT, password TEXT,pin TEXT,Unique_ID TEXT');
    await userPinRecorder.updateRow(
      'signUpTable',
      otherUserDetails['id'],
      {'pin': pin},
    );
    storePin(pin);
    notifyListeners();
    // avoid_print('******** ' * 120);
  }

  bool validatePin(String pin) {
    return pinStored == pin;
  }

  bool matchPin(String pin) {
    return matchPin1 == matchPin2;
  }
}

class DishHandler extends ChangeNotifier {
  void productList(List<ProductModel> _prdt) {
    prdt = _prdt;
    notifyListeners();
  }
}

bool isAppActive = false;

void logger(String message) {
  log(message);
}

class TransactionHistoryHandler extends ChangeNotifier {
  List<Map<String, dynamic>> allHistory = [];
  List<Map<String, dynamic>> tempAllHistoryHolder = [];

  DatabaseHelper cableHistoryDBHandler = DatabaseHelper(
      fieldString:
          'cableId TEXT, cableNumber TEXT,orderId TEXT,orderType TEXT ',
      dbName: 'cableServiceStore.db',
      tableName: 'PurchaseHistoryTable');
  DatabaseHelper electricityHistoryDBHandler = DatabaseHelper(
      dbName: 'electricity.db',
      tableName: 'ElectricBillTransactionDetails',
      fieldString:
          'orderid TEXT,meterNo TEXT, Status TEXT,Amount TEXT,time TEXT, ElectricCompany TEXT, MeterType TEXT, PhoneNo TEXT  ');

  DatabaseHelper dataHistoryDBHandler = DatabaseHelper(
      dbName: 'internetService.db',
      tableName: 'dataTransactionHistory',
      fieldString:
          'phoneNumber TEXT,operator TEXT,package TEXT,orderID TEXT,time TEXT ');

  DatabaseHelper airtimeHistoryDBHandler = DatabaseHelper(
      dbName: 'airtime.db',
      tableName: 'airtimeTransactionHistory',
      fieldString:
          'phoneNumber TEXT,operator TEXT,amount TEXT,orderID TEXT, time TEXT');
  Future<List<Map<String, dynamic>>> getAllHistory() async {
    await cableHistoryDBHandler.createTable(
        " CREATE TABLE IF NOT EXISTS  PurchaseHistoryTable  ( id INTEGER PRIMARY KEY AUTOINCREMENT, cableId TEXT, cableNumber TEXT,orderId TEXT,orderType TEXT )");
    await electricityHistoryDBHandler.createTable(
        " CREATE TABLE IF NOT EXISTS  ElectricBillTransactionDetails  ( id INTEGER PRIMARY KEY AUTOINCREMENT, orderid TEXT,meterNumber TEXT, Status TEXT,amount TEXT,time TEXT, serviceProvider TEXT )");
    await dataHistoryDBHandler.createTable(
        " CREATE TABLE IF NOT EXISTS  dataTransactionHistory  ( id INTEGER PRIMARY KEY AUTOINCREMENT, phoneNumber TEXT,operator TEXT,package TEXT,orderID TEXT,time TEXT )");
    await airtimeHistoryDBHandler.createTable(
        " CREATE TABLE IF NOT EXISTS  airtimeHistoryDBHandler  ( id INTEGER PRIMARY KEY AUTOINCREMENT, phoneNumber TEXT,operator TEXT,amount TEXT,orderID TEXT, time TEXT)");

    List<Map<String, dynamic>> result = [];

    result.addAll([
      ...(await cableHistoryDBHandler.getAll('PurchaseHistoryTable')).map((e) {
        return {...e, 'service': 'cable'};
      }),
      ...(await electricityHistoryDBHandler
              .getAll('ElectricBillTransactionDetails'))
          .map((e) {
        return {...e, 'service': 'electricity'};
      }),
      ...(await dataHistoryDBHandler.getAll('dataTransactionHistory')).map((e) {
        return {...e, 'service': 'data'};
      }),
      ...(await airtimeHistoryDBHandler.getAll('airtimeTransactionHistory'))
          .map((e) {
        return {...e, 'service': 'airtime'};
      }),
    ]);

    sort(result);

    // avoid_print(DateTime.now());
    tempAllHistoryHolder = result;
    allHistory = result;

    return result;
  }

  void updateHistory() {
    allHistory = tempAllHistoryHolder;
    notifyListeners();
  }

  Future<void> getHistoryOnlineAndStoreOffline(
      {DateTime? startDate, DateTime? endDate, required String userID}) async {
// gets history from the internet past 30 days by default
    String url = "$baseURL/getTransactions";
    Map<String, dynamic> body = {
      "startDate": startDate?.toString(),
      "endDate": endDate?.toString(),
      "userId": userID
    };
    Map<String, String> headers = {};
    // List<Map<String, dynamic>>

    Map<String, dynamic> rawResult =
        await requestResources(url, body, headers, "encoded_post");
    if (rawResult["status"]) {
      List data = rawResult["data"];
      for (Map<String, dynamic> i in data) {
        Map<String, dynamic> transactionDetail =
            json.decode(i["transactionDetails"]);

        switch (i["serviceType"]) {
          case "cable":
            await cableHistoryDBHandler.insert(
                transactionDetail, 'PurchaseHistoryTable');

            break;
          case "airtime":
            await airtimeHistoryDBHandler.insert(
                transactionDetail, 'airtimeHistoryDBHandler');

            break;
          case "data":
            await dataHistoryDBHandler.insert(
                transactionDetail, 'dataTransactionHistory');

            break;
          case "electricity":
            await electricityHistoryDBHandler.insert(
                transactionDetail, 'ElectricBillTransactionDetails');

            break;

          default:
        }
      }
    }
  }

  Future<void> storeHistoryOnline(
      {required String userId,
      required String userEmail,
      Map? transactionDetails,
      required String serviceType,
      date}) async {
// gets history from the internet past 30 days by default
    String url = "$baseURL/storeTransactions";
    Map<String, dynamic> body = {
      "userEmail": userEmail,
      "transactionDetails": transactionDetails ?? {},
      "userId": userId,
      "serviceType": serviceType,
      "date": date
    };

    Map<String, String> headers = {};

    Map<String, dynamic> rawResult =
        await requestResources(url, body, headers, "encoded_post");
    if (rawResult["status"]) {
      print(rawResult["status"]);
    } else {}
  }

  int compareMapsByDate(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    // Parse the date strings into DateTime objects.
    DateTime date1 = DateTime.parse(map1['time']);
    DateTime date2 = DateTime.parse(map2['time']);

    // Compare the date values and return an integer value.
    return date1.compareTo(date2);
  }

  void sort(List<Map<String, dynamic>> data) {
    data.sort(compareMapsByDate);
  }

  Widget? generateUI(Map<String, dynamic> uiData) {
    Widget? result;

    return result;
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;

  LifecycleEventHandler({
    required this.resumeCallBack,
    required this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print('state >>>>>>>>>>>>>>>>>>>>>> : $state');
    SharedPref pref = SharedPref();
    String? string = await (pref.getPrefString(notifyer));
    logger("NtfChk:$string");

    switch (state) {
      case AppLifecycleState.resumed:
        isAppActive = true;
        logger("Foreground_Engagement");
        await resumeCallBack();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (suspendingCallBack != null) {
          isAppActive = false;
          logger("Background_Engagement");

          await suspendingCallBack();
        } else {}
        break;
      case AppLifecycleState.hidden:
        logger("Hidden_Engagement");
        break;
      // TODO: Handle this case.
    }
  }
}
