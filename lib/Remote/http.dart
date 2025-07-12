import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(connectTimeout: const Duration(seconds: 3)),

  /*
  connectTimeout: const Duration(seconds: 30, minutes: 1),
    receiveTimeout: const Duration(seconds: 30, minutes: 1),
  
  */
);

final elite = Dio(
  BaseOptions(connectTimeout: const Duration(seconds: 60)),

  /*
  connectTimeout: const Duration(seconds: 30, minutes: 1),
    receiveTimeout: const Duration(seconds: 30, minutes: 1),
  
  */
);
