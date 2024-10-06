import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:farm_to_dish/Screens/Products/product_model.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

import 'Screens/Cart/cart_item_model.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

bool isLoggedIn = false;

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> sectionNavigatorKey =
    GlobalKey<NavigatorState>();

bool hasInternetAccess = true;

AndroidDeviceInfo? deviceId;

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

Map<int, List<String>> sectionSlabs = {
  0: ["Fruits vegetables", "${assets}fruitVeggie.png"],
  1: ["Grains and legumes", "${assets}grains.png"],
  2: ["Tubers", "${assets}tubbers.png"],
  3: ["Spices", "${assets}pepper.png"],
};
List<Map<String, dynamic>> productTypeDetails = [
  {"name": "fruits And Vegie", "imageURL": "${assets}fruitVeggie.png"},
  {"name": "Grains and legumes", "imageURL": "${assets}grains.png"},
  {"name": "Tubers", "imageURL": "${assets}tubbers.png"},
  {"name": "Spices", "imageURL": "${assets}pepper.png"},
];

List<ProductModel> testProducts = [
  ProductModel(
      imageURL: "${assets}yams.png",
      name: "yam",
      price: 1200,
      quantity: 12,
      unit: "tuber"),
  ProductModel(
      imageURL: "${assets}yams.png",
      name: "yam",
      price: 1200,
      quantity: 12,
      unit: "tuber"),
  ProductModel(
      imageURL: "${assets}yams.png",
      name: "yam",
      price: 1200,
      quantity: 12,
      unit: "tuber"),
  ProductModel(
      imageURL: "${assets}yams.png",
      name: "yam",
      price: 1200,
      quantity: 12,
      unit: "tuber"),
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

String baseURL = "";

void avoid_print(Object? o) {}
void custom_print(Object? o, String about) {
  print('starting $about ...' * 50);
  print(o);
  print('ending $about ...' * 50);
}
