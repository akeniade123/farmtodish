import 'package:dio/dio.dart';
import 'package:farm_to_dish/Remote/http.dart';
import 'package:flutter/material.dart';

import '../global_handlers.dart';

class RequestRoute extends StatefulWidget {
  @override
  State<RequestRoute> createState() => _RequestRouteState();
}

class _RequestRouteState extends State<RequestRoute> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Page'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('get'),
              onPressed: () {
                dio.get<String>('https://httpbin.org/get').then((r) {
                  setState(() {
                    _text = r.data!;
                  });
                });
              },
            ),
            ElevatedButton(
              child: const Text('post'),
              onPressed: () {
                final formData = FormData.fromMap({
                  'file': MultipartFile.fromString('x' * 1024 * 1024),
                });

                dio
                    .post(
                  'https://httpbin.org/post',
                  data: formData,
                  options: Options(
                    sendTimeout: const Duration(seconds: 50),
                    receiveTimeout: const Duration(seconds: 0),
                  ),
                  onSendProgress: (a, b) => print('send ${a / b}'),
                  onReceiveProgress: (a, b) => print('received ${a / b}'),
                )
                    .then((r) {
                  setState(() {
                    _text = r.headers.toString();
                  });
                });
              },
            ),
            ElevatedButton(
              child: const Text('elite'),
              onPressed: () {
                final formData = FormData.fromMap({
                  'file': MultipartFile.fromString('x' * 1024 * 1024),
                });

                try {
                  elite
                      .post(
                    'https://www.farmtodish.com/base/user/entry',
                    data: formData,
                    options: Options(
                      sendTimeout: const Duration(seconds: 30),
                      receiveTimeout: const Duration(seconds: 0),
                    ),
                    onSendProgress: (a, b) => print('send ${a / b}'),
                    onReceiveProgress: (a, b) => print('received ${a / b}'),
                  )
                      .then((r) {
                    setState(() {
                      _text = r.headers.toString();
                    });
                  });
                } catch (e) {
                  logger("The Dio Error:$e");
                }
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
