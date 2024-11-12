import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<bool> getPrefBool(String name) async {
    bool rslt = false;
    final prefs = await SharedPreferences.getInstance();

    log("*** $name");

    rslt = (prefs.getBool(name) == true) ? true : false;

    log("The current $rslt");
    return rslt;

    //return prefs.getBool(name);
  }

  Future<void> setPrefBool(String name, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(name, value);
  }

  Future<void> setPrefString(String name, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name, value);
  }

  Future<void> setPrefInt(String name, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(name, value);
  }

  Future<void> setPrefDouble(String name, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(name, value);
  }

  Future<String?> getPrefString(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString(name);
    return stringValue;
  }

  Future<int?> getPrefInt(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int? intValue = prefs.getInt(name);
    return intValue;
  }

  Future<double?> getPrefDouble(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return double
    double? doubleValue = prefs.getDouble(name);
    return doubleValue;
  }
}
