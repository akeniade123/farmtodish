import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../env.dart';
import '../global_objects.dart';
import '../global_string.dart';
import '../global_widgets.dart';
import 'requestmodel.dart';

Navigate nvg = Navigate();

Future<List<Widget>>? obtainData(
    Map<String, Object> tag,
    String domain,
    String essence,
    String designation,
    String endgoal,
    String function,
    bool active,
    BuildContext context) async {
  List<Widget> rslts = [];
  nvg = Navigate();

  return rslts;
}

FutureBuilder<List<Widget>> castData(Future<List<Widget>>? futureclasses,
    String function, String essence, String endgoal) {
  return FutureBuilder(
      future: futureclasses,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget>? data_ = snapshot.data;
          int size = data_!.length;
          basedlg = context;

          if (size > 0) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      itemCount: size,
                      padding: const EdgeInsets.all(8),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return data_[index];
                      })
                ],
              ),
            );
          } else {
            Widget basic = const Text("No Data");
            switch (function) {
              case server:
                basic = const NoInternet();
                break;
            }
            return basic;
          }
        } else if (snapshot.hasError) {
          return const Center(
              child: Text("an error just occurred, please try again"));
        }
        return Center(
          child: LoadingAnimationWidget.flickr(
              leftDotColor: Colors.blue, rightDotColor: bgmainclr, size: 30),
        );
      });
}
