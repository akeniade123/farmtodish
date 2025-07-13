import 'package:dio/dio.dart';

import '../global_string.dart';
import 'requester.dart';

final dio = Dio(
  BaseOptions(connectTimeout: const Duration(seconds: 60)),

  /*
  connectTimeout: const Duration(seconds: 30, minutes: 1),
    receiveTimeout: const Duration(seconds: 30, minutes: 1),
  
  */
);

final elite = Dio(
  BaseOptions(
      connectTimeout: const Duration(minutes: 2, seconds: 60),
      headers: getHeader(rqstElite)),

//headers: getHeader(request),
  /*
  connectTimeout: const Duration(seconds: 30, minutes: 1),
    receiveTimeout: const Duration(seconds: 30, minutes: 1),
  
  */
);
