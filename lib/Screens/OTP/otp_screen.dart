import 'package:farm_to_dish/app_theme_file.dart';
import 'package:flutter/material.dart';

import '../../global_objects.dart';

// import 'package:Yomcoin/requester.dart';
import 'package:flutter/services.dart';
// import '../main.dart';
// import '../models/global_objects.dart';
// import 'common_widget.dart';

// import 'otp_change_password_page.dart';

class OTPPage extends StatefulWidget {
  // final String neededMapStringformat;
  Map<String, dynamic> neededMap = {};

  OTPPage({
    super.key,
    // this.neededMapStringformat = "{}",
  }) {
    // neededMap = json.decode(neededMapStringformat);
  }

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  String otp = '';

  void changePopUp() {
    setState(() {
      (popUp == 0) ? popUp = 1 : popUp = 0;
    });
  }

  Future<Map<String, dynamic>> getotp(String fullName__) async {
    Map<String, dynamic> result = {};
    String url = 'https://www.elitepage.com.ng/base/user/entry';

    Map<String, dynamic> body = {
      "regId": "kljnjknkjnkjnbjkkjhkhj",
      "Full_Name": fullName__,
      'Essence': 'Profile',
      'domain': 'PasswordOTP'
    };

    // Map<String, dynamic> rawResult = await requestResources(url, body,
    //     {'authentication': '937a4a8c13e317dfd28effdd479cad2f'}, 'post');

    // custom_print(rawResult, 'retrievePassword');
    // result = rawResult;

    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FarmToDishTheme.scaffoldBackgroundColor,
      body: Center(
        child: SizedBox(
          // padding: EdgeInsets.all(20),
          // color: Colors.blue,
          // height: 350,
          // width: 300,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 30),
                    children: [
                      TextSpan(
                          text: 'Confirm ',
                          style: TextStyle(
                            color: FarmToDishTheme.highlightBlue,
                          )),
                      const TextSpan(
                        text: 'Otp !',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const Text(
                    'Lets confirm it’s you, Enter the OTP that was sent to your mail'),
                const SizedBox(height: 20),
                const Text("Enter OTP"),
                const SizedBox(height: 4),
                // OTP(),
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                        fillColor: FarmToDishTheme.accentLightColor,
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none
                            // BorderSide(
                            //     color: Colors.transparent,
                            //     style: BorderStyle.none),

                            ),
                        hintText: 'Enter OTP',
                        hintStyle: FarmToDishTheme.iStyle
                            .copyWith(color: FarmToDishTheme.faintGreen)),
                    onChanged: (value) {
                      otp = value;
                    },
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        height: 40,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                        color: FarmToDishTheme.faintGreen,
                        // Theme.of(context).primaryColor,
                        // minWidth: 300,
                        onPressed: () {
                          // if (otp == widget.neededMap['message']['code'].toString()) {
                          //   prePush(context);
                          //   Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) {
                          //       return PasswordReseOriginaltPage(
                          //         neededMap: widget.neededMap,
                          //       );
                          //     },
                          //   ));
                          // } else {
                          //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          //       content: Center(child: Text('Wrong OTP'))));
                          // }
                        },
                        child: const Text(
                          'Confirm',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                StreamBuilder(
                    stream: Stream.periodic(const Duration(seconds: 1),
                        (computationCount) {
                      return computationCount;
                    }),
                    builder: (context, snapshot) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Did not get OTP?'),
                          TextButton(
                              onPressed: () async {
                                //  getOTP();
                                Navigator.of(rootNavigatorKey
                                        .currentState!.overlay!.context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => const Center(
                                      child: CircularProgressIndicator()),
                                ));
                                Map<String, dynamic> otpDetail = await getotp(
                                    widget.neededMap['message']['Name']);
                                Navigator.of(rootNavigatorKey
                                        .currentState!.overlay!.context)
                                    .pop();
                                if (otpDetail['status']) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Center(
                                              child: Text('OTP resent'))));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Center(
                                              child: Text(
                                                  'Full Name does not exist'))));
                                }
                              },
                              child: Text('Resend in ${snapshot.data}'))
                        ],
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

int popUp = 0;

class OTPWidget extends StatefulWidget {
  const OTPWidget({super.key});

  @override
  State<OTPWidget> createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  void textFieldOnChangeCallback(value) {
    if (value.length == 1) {
      // FocusScope.of(context).
      // context.
      FocusScope.of(context).nextFocus();
    }
    if (value.isEmpty) {
      FocusScope.of(context).previousFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 0.0),
        // color: Colors.red,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),

        // width: 0,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // children: [
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: TextField(
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                  if (value.isEmpty) {
                    FocusScope.of(context).previousFocus();
                  }
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    // hintText: "0",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(10)))),
              ),
            ),
            SizedBox(
              height: 60,
              width: 60,
              child: TextField(
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                  if (value.isEmpty) {
                    FocusScope.of(context).previousFocus();
                  }
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    // hintText: "0",
                    border:
                        OutlineInputBorder(borderRadius: BorderRadius.zero)),
              ),
            ),
            SizedBox(
              height: 60,
              width: 60,
              child: TextField(
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                  if (value.isEmpty) {
                    FocusScope.of(context).previousFocus();
                  }
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    // hintText: "0",
                    border:
                        OutlineInputBorder(borderRadius: BorderRadius.zero)),
              ),
            ),
            SizedBox(
              height: 60,
              width: 60,
              child: TextField(
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                  if (value.isEmpty) {
                    FocusScope.of(context).previousFocus();
                  }
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    // hintText: "0",
                    border:
                        OutlineInputBorder(borderRadius: BorderRadius.zero)),
              ),
            ),
            SizedBox(
              height: 60,
              width: 60,
              child: TextField(
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                  if (value.isEmpty) {
                    FocusScope.of(context).previousFocus();
                  }
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    // hintText: "0",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(10)))),
              ),
            ),
          ],
        ));
  }
}
