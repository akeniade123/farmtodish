import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:farm_to_dish/Screens/Products/product_model.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

import 'Repository/databaseHelper.dart';
import 'Remote/modelstack.dart';
import 'Screens/Cart/cart_item_model.dart';
import 'Screens/Login/user.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
//08030750148    Mr. Segun Emmanuel...
bool isLoggedIn = false;

late User ussr_;
late int amount;

late BuildContext drwdlg, dshCtx, crrctx, bbCtx, cbtCtx;

late DatabaseHelper dbCart;

late BuildContext? dlg;
late BuildContext? baseCtx;

late Map<String, dynamic> otp_;

late BuildContext basedlg;

late Widget init;

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> sectionNavigatorKey =
    GlobalKey<NavigatorState>();

bool hasInternetAccess = true;

AndroidDeviceInfo? deviceId;

//2030717028

DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
String deviceIdInString = '';
void identifyDeviceId() async {
  if (Platform.isAndroid) {
    deviceId = await deviceInfo.androidInfo;
    deviceIdInString = deviceId!.id;
    // avoid_print('device id is $deviceIdInString');
  }
}

// AndroidDeviceInfo? deviceId;
List<String> productTypes = [
  "fruits And Vegie",
  "Tubers",
  "Grains and legumes",
  "Spices"
];

/*
Map<int, List<String>> sectionSlabs = {
  0: ["Fruits vegetables", "${assets}fruitVeggie.png"],
  1: ["Grains and legumes", "${assets}grains.png"],
  2: ["Tubers", "${assets}tubbers.png"],
  3: ["Spices", "${assets}pepper.png"],
};

*/

List<Map<String, dynamic>> productTypeDetails = [
  {"name": "Fruits & Veggies", "imageURL": "${assets}fruitVeggie.png"},
  {"name": "Grains & Legumes", "imageURL": "${assets}grains.png"},
  {"name": "Tubers", "imageURL": "${assets}tubbers.png"},
  {"name": "Spices", "imageURL": "${assets}pepper.png"},
];

late List<ProductModel> prdt;

List<ProductModel> testProducts = [
  ProductModel(
      imageURL: "${assets}yams.png",
      name: "Yam",
      price: 3200,
      quantity: 10,
      unit: "tubers"),
  ProductModel(
      imageURL: "${assets}chicken.png",
      name: "Chicken",
      price: 4500,
      quantity: 23,
      unit: "kilo"),
  ProductModel(
      imageURL: "${assets}goat_meat.png",
      name: "Goat Meat",
      price: 4700,
      quantity: 12,
      unit: "kilo"),
  ProductModel(
      imageURL: "${assets}onions.png",
      name: "Onions",
      price: 3500,
      quantity: 118,
      unit: "small baskets"),
];

String assets = !(UniversalPlatform.isAndroid) ? "../assets/" : "assets/";
// String assets = "";

String currency = "₦";

showdialog(Widget child, Function() externalFunction, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => child,
  );
}

OrderModel? currentOrder;

// final rootNavigatorKey = GlobalKey<NavigatorState>();

String baseURL = "https://www.farmtodish.com/base";

void avoid_print(Object? o) {}
void custom_print(Object? o, String about) {
  print('starting $about ...' * 50);
  print(o);
  print('ending $about ...' * 50);
}

late dashNote dnn;
late liveNote lnt;
late serverFile svrf;
late contentMode cstk;
late liveSession lss;
late comboNote cmbN;
late stackStar strr;
late balance bll;
late userDtlz usrdtlz;
late broadcast brdcst;

Future<String>? account, usrNm;

class UINotifier extends ChangeNotifier {
  final _randomGenerator = Random();
  int? _generatedNumber;
  int? get generatedNumber => _generatedNumber;

  int min = 0, max = 0;
  void generateRandomNumber() {
    _generatedNumber = min + _randomGenerator.nextInt(max + 1 - min);
    notifyListeners();
  }

  void dashNotice(dashNote dnn_) {
    dnn = dnn_;
    notifyListeners();
  }

  void liveNotice(liveNote lnv) {
    lnt = lnv;
    notifyListeners();
  }

  void userName(userDtlz dtlz) {
    usrdtlz = dtlz;
    notifyListeners();
  }

  void accountBalance(balance bal_) {
    bll = bal_;
    notifyListeners();
  }

  void broadCast(broadcast brdc) {
    brdcst = brdc;
    notifyListeners();
  }

  void fileObtained(serverFile svr) {
    svrf = svr;
    notifyListeners();
  }

  /*

  void categoryCast(bool ctg) {
    usdt = ctg;
    notifyListeners();
  }

  void userNotify(User usr) {
    ussr_ = usr;
    notifyListeners();
  }

  void listNotify(List<Notice> ntcc) {
    lntc = ntcc;
    notifyListeners();
  }

  */

  void cbtNotify(contentMode cst) {
    cstk = cst;
    notifyListeners();
  }

  void stackChar(stackStar str) {
    strr = str;
    notifyListeners();
  }

  void comboNotify(comboNote cmb) {
    cmbN = cmb;
    notifyListeners();
  }
}
