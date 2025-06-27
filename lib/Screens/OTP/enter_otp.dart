// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../../Repository/databaseHelper.dart';
import '../../Remote/endpoints.dart';
import '../../Remote/requester.dart';
import '../../Remote/server_response.dart';
import '../../Remote/service_protocols.dart';
import '../../env.dart';
import '../../global_string.dart';
import '../../global_widgets.dart';
import '../../sharedpref.dart';
import '../Home/home_screen.dart';
import '../Login/login_screen.dart';
import '../Login/user.dart';

class otp extends StatefulWidget {
  final String value, recipient, essence;
  final User user;
  const otp(
      {super.key,
      required this.value,
      required this.recipient,
      required this.essence,
      required this.user});

  @override
  State<otp> createState() => _otpState();
}

// ignore: camel_case_types
class _otpState extends State<otp> {
  final TextEditingController _password = TextEditingController();
  bool passwordinvisible = true;
  bool otp_ = false;

  @override
  void initState() {
    super.initState();
    otp_ = false;
    //  FlutterNativeSplash.remove();
  }

  late Widget btnn_;

  Future<Map<String, dynamic>>? _futureData;

  Future<Map<String, dynamic>>? FetchData(String essence) async {
    Map<String, dynamic> txt = {}; // Text("Sign in");
    Map<String, String> tag = {};

    switch (essence) {
      case pswOTP:
        User ussr_ = widget.user;
        tag.addEntries({
          "regId": "prelim",
          "Full_Name": ussr_.Name,
          "Password": _password.text,
          "Essence": "Profile",
          "domain": "ResetPassword"
        }.entries);
        break;
    }

    Endpoint enp = Endpoint();
    String url = enp.getEndpoint(login, communal, true);

    Map<String, dynamic>? data_ = await postReq(
        enp.getEndpoint(login, communal, true),
        tag,
        rqstElite,
        login,
        "",
        urlEnc,
        context,
        true);

    if (data_ != null) {
      txt = data_;
      String dtt = jsonEncode(data_);
      ServerPrelim svp = ServerPrelim.fromJson(jsonDecode(dtt));
      Object obj = svp.msg;
      if (svp.status) {
        ServerResponse svr = ServerResponse.fromJson(jsonDecode(dtt));
        List usrLogin = svr.data;
        User ussr_ = User.fromData(usrLogin[0]);
        DatabaseHelper dbh = DatabaseHelper(table: usrTbl);
        await dbh.insertData(User.toMap(ussr_));

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        customSnackBar(context, obj.toString());
      }
    }

    otp_ = false;
    log("Done with sign in procession");
    setState(() {});
    return txt;
  }

  @override
  Widget build(BuildContext context) {
    String rcp = widget.recipient;
    String cnf = "";

    List<String> splitted = rcp.split('@');
    int len = splitted[0].length;

    try {
      if (len > 5) {
        cnf += "***";
        cnf += splitted[0].substring(3, len);
      } else {
        cnf += splitted[0];
      }
      cnf += "@${splitted[1]}";
    } catch (e) {
      log("There's an issue with the supplied email address");
    }

//                               const string = 'dartlang';
// var result = string.substring(1); // 'artlang'
// result = string.substring(1, 4); // 'art'

    otp_ == false
        ? btnn_ = const Text("Change Password")
        : btnn_ = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Requesting...'),
              LoadingAnimationWidget.flickr(
                  size: 20,
                  leftDotColor: Colors.white,
                  rightDotColor: Colors.blue)
            ],
          );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 249, 249),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 249, 249, 249),
        foregroundColor: Colors.black,
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: const Color.fromARGB(255, 249, 249, 249),
                  child: Column(
                    children: [
                      const Center(
                        child: Row(
                          children: [
                            Text(
                              'Confirm',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 19, 70, 104),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Otp!',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            Text(
                                "Lets confirm it’s you, Enter the OTP that was sent to $cnf"),
                            const SizedBox(
                              height: 39,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Enter OTP!',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            OTPTextField(
                              controller: OtpFieldController(),
                              length: 7,
                              width: double.infinity,
                              fieldStyle: FieldStyle.box,
                              outlineBorderRadius: 5,
                              style: const TextStyle(fontSize: 10),
                              onChanged: (pin) {},
                              onCompleted: (verification) async {
                                if (verification == widget.value) {
                                  switch (widget.essence) {
                                    case login:
                                      DatabaseHelper dbh =
                                          DatabaseHelper(table: usrTbl);
                                      await dbh
                                          .insertData(User.toMap(widget.user));

                                      SharedPref pref = SharedPref();
                                      String? dtt =
                                          await pref.getPrefString("usrTbl");
                                      pref.setPrefString(usrTbl, dtt!);

                                      Map<String, dynamic> dbb = {
                                        usrTbl: jsonDecode(dtt),
                                        login: true,
                                        appState: prelim,
                                        indexed: false
                                      };

                                      dbh = DatabaseHelper(table: mnf);
                                      await dbh.insertData({cpt: dbb});

                                      await pref.setPrefBool(login, true);
                                      pref = SharedPref();
                                      await pref.setPrefString(
                                          appState, prelim);

                                      pref = SharedPref();
                                      await pref.setPrefBool(indexed, false);

                                      context.go("/HomeScreen");

                                      /*
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen(),
                                        ),
                                      );
                                      */
                                      break;
                                    case pswOTP:
                                      Widget wdg = Column(
                                        children: [
                                          const Center(
                                            child: Text("User Verification"),
                                          ),
                                          const Divider(
                                            thickness: 2,
                                          ),
                                          TextField(
                                            controller: _password,
                                            obscureText: passwordinvisible,
                                            decoration: InputDecoration(
                                                hintText: 'Password',
                                                helperText:
                                                    "Password must contain upper and lowercase",
                                                suffixIcon: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        passwordinvisible =
                                                            !passwordinvisible;
                                                      });
                                                    },
                                                    icon: Icon(passwordinvisible
                                                        ? Icons.visibility
                                                        : Icons
                                                            .visibility_off_sharp)),
                                                border:
                                                    const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(12),
                                                        ),
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    249,
                                                                    249,
                                                                    249))),
                                                filled: true,
                                                fillColor: const Color.fromARGB(
                                                    255, 249, 249, 249)),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            height: 60,
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  if (_password.text.isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            displaySnackBar(
                                                                "empty required field"));
                                                  } else {
                                                    otp_ = true;
                                                    setState(() {});
                                                    _futureData =
                                                        FetchData(pswOTP);
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: bgmainclr),
                                                child: btnn_),
                                          )
                                        ],
                                      );
                                      Modal(context, 220, wdg);
                                      break;
                                  }
                                } else {
                                  customMessage(context, "OTP entry error",
                                      "The OTP entered is incorrect, kindly confirm and make a re-entry");
                                }
                              },
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Don\'t get OTP?'),
                                TextButton(
                                    onPressed: () {
                                      switch (widget.essence) {
                                        case login:
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen(),
                                          ));

                                          break;
                                      }
                                    },
                                    child: const Text(
                                      'Resend',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 19, 70, 104)),
                                    ))
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
