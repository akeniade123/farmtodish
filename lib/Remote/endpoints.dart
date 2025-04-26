import 'dart:developer';

import '../env.dart';
import '../global_string.dart';

String base = "https://www.farmtodish.com/";

class Endpoint {
  String getEndpoint(String path, String domain, bool resident) {
    return (resident) ? getElites(path, domain) : getApi(path);
  }

  String getElites(String path, String domain) {
    String result = "";

    String dmm = community;

    if (!lone) {
      dmm = (domain == communal) ? community : desig;
    }

    result = base;

    switch (path) {
      case raw:
        result += "$dmm/user";
        break;
      case login:
        result += "$dmm/user/entry";
        break;
      case generic:
        result += "$dmm/class/prt";
        break;
      case chg:
        result += "$dmm/transaction/cards";
        break;
    }

    log("endpoint: $result");
    return result;
  }

  String getApi(String essence) {
    String result = "";

    /*

    switch (essence) {
      case getAlbum:
        result = 'https://jsonplaceholder.typicode.com/albums';
        break;
    }

    */

    return result;
  }
}
