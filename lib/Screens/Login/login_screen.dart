import 'dart:convert';

import 'package:farm_to_dish/app_theme_file.dart';
import 'package:farm_to_dish/env.dart';
import 'package:farm_to_dish/requester.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../Repository/databaseHelper.dart';
import '../../Remote/endpoints.dart';
import '../../Remote/requester.dart';
import '../../Remote/server_response.dart';
import '../../Remote/service_protocols.dart';
import '../../global_handlers.dart';
import '../../global_objects.dart';
import '../../global_string.dart';
import '../../global_widgets.dart';
import '../Home/home_screen.dart';
import '../OTP/enter_otp.dart';
import 'login_handler.dart';
import 'user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNumberRetriever = TextEditingController();
  TextEditingController passwordRetriever = TextEditingController();
  TextEditingController emailRetreiver = TextEditingController();

  bool rememberBool = false;

  Future<Map<String, dynamic>>? FetchData(String essence) async {
    Map<String, dynamic> txt = {}; // Text("Sign in");
    Map<String, String> tag = {};

    switch (essence) {
      case login:
        tag.addEntries({
          "regId": "prelim",
          "Phone": phoneNumberRetriever.text,
          "Essence": "Phone_No_Login",
          "Password": passwordRetriever.text
        }.entries);
        break;
      case pswOTP:
        tag.addEntries({
          "regId": "prelim",
          "Full_Name": emailRetreiver.text,
          "Essence": "Profile",
          "domain": "PasswordOTP"
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
        urlEnc,
        "",
        context,
        true);

    if (data_ != null) {
      txt = data_;
      String dtt = jsonEncode(data_);
      ServerPrelim svp = ServerPrelim.fromJson(jsonDecode(dtt));
      Object obj = svp.msg;
      if (svp.status) {
        ServerResponse svr = ServerResponse.fromJson(jsonDecode(dtt));
        LoginUser(context, obj, svr, essence);
      } else {
        customSnackBar(context, "***${obj.toString()}***");
      }
    }

    signin = false;
    otp = false;
    logger("Done with sign in procession");
    setState(() {});
    return txt;
  }

  bool signin = false;
  bool otp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FarmToDishTheme.scaffoldBackgroundColor,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: "Welcome ",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: FarmToDishTheme.highlightBlue),
                  ),
                  TextSpan(
                    text: "Back",
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                ])),
                Text(
                  "login into your account",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // TextFormField(),
            Squire(
              // height: 38,
              child: TelephoneNumberWidget(
                context: context,
                controller: phoneNumberRetriever,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: Squire(
                    height: 40,
                    // width: 190,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Text(
                          //   'Password :',
                          //   style: Theme.of(context).textTheme.bodySmall,
                          // ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: TextField(
                                style: Theme.of(context).textTheme.bodySmall,
                                obscureText: true,
                                obscuringCharacter: '*',
                                controller: passwordRetriever,
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                    isCollapsed: true,
                                    border: InputBorder.none),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Squire(
                    height: 40,
                    width: 127,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            'keep me',
                            style: TextStyle(fontSize: 10),
                          ),
                          Checkbox(
                              value: rememberBool,
                              onChanged: (e) {
                                // rememberBool = e;
                                setState(() {
                                  rememberBool = !rememberBool;
                                });
                              })
                        ],
                      ),
                    )),
              ],
            ),
            // SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                  onPressed: () async {
                    if (hasInternetAccess) {
                      if (emailRetreiver.text.isNotEmpty) {
                        Navigator.of(
                                rootNavigatorKey.currentState!.overlay!.context)
                            .push(DialogRoute(
                          context: context,
                          builder: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ));
                        // Future.delayed(
                        //   Duration(seconds: 1),
                        //   () {
                        // Navigator.of(
                        //         rootNavigatorKey.currentState!.overlay!.context)
                        //     .pop();
                        //   },
                        // );
                        // Map<String, dynamic> result =
                        //     await loginHandler.getOTP(emailRetreiver.text);
                        // print('1111111' * 100);

                        // Navigator.of(
                        //         rootNavigatorKey.currentState!.overlay!.context)
                        //     .pop();

                        // Navigator.of(rootNavigatorKey.currentState!.context)
                        //     .push(MaterialPageRoute(
                        //   builder: (context) {
                        //     return OTPPage(
                        //       neededMap: result,
                        //     );
                        //   },
                        // ));

                        // context.go('/forgetPasswordPage',
                        //     extra: json.encode(result));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Theme.of(context).primaryColor,
                            content: const Center(
                              child: Text("Please, enter your email "),
                            ),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          // backgroundColor: Theme.of(context).,primaryColor
                          content: Text("No Inernet connection"),
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Forgot Password',
                      style: FarmToDishTheme.iStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorLight),
                    ),
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: MaterialButton(
                    disabledColor: Colors.grey,
                    // disabledTextColor: Colors.black,
                    // minWidth: double.maxFinite,
                    onPressed: (hasInternetAccess)
                        ? (() async {
                            (appStatus == dev)
                                ? {context.go("/HomeScreen")}
                                : {
                                    if (phoneNumberRetriever.text.isNotEmpty &&
                                        passwordRetriever.text.isNotEmpty)
                                      {
                                        FetchData(login)

                                        // await LoginHandler().login(
                                        //     context,
                                        //     {
                                        //       'email': emailRetreiver.text,
                                        //       'password':
                                        //           passwordRetriever.text,
                                        //     },
                                        //     rememberBool)

                                        // if (!checkLogin) {
                                        //   Navigator.of(rootNavigatorKey
                                        //           .currentState!.overlay!.context)
                                        //       .push(MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         Center(child: ErrorPage()),
                                        //   ));
                                        //   Future.delayed(
                                        //     Duration(seconds: 1),
                                        //     () {
                                        //       Navigator.of(rootNavigatorKey
                                        //               .currentState!.overlay!.context)
                                        //           .pop();
                                        //     },
                                        //   );
                                        // }
                                      }
                                    else
                                      {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(displaySnackBar(
                                                "empty required fields"))
                                      }
                                  };
                          })
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    duration: Duration(seconds: 2),
                                    dismissDirection:
                                        DismissDirection.horizontal,
                                    content: Text('No internet connection')));
                          },
                    color: FarmToDishTheme.faintGreen,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: 40,
                    child: const Text(
                      "Log In",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("New user? "),
                TextButton(
                    onPressed: () {
                      // prePush(context);
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => SignUpScreen(),
                      // ));
                      context.push("/signUp");
                    },
                    child: Text(
                      "Register now",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorLight),
                    ))
              ],
            ),
          ],
        ),
      )),
    );
  }
}

class LoginScreenHandler {
  Future login(String email, String password) async {
    Map<String, String> body = {
      "regId": "prelim",
      "Full_Name": email,
      "Essence": "Profile",
      "Password": password
    };
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'authentication': '937a4a8c13e317dfd28effdd479cad2f'
    };
    requestResources("$baseURL/user/entry", body, headers, "Post");
  }
}

Future<void> LoginUser(BuildContext context, Object obj, ServerResponse svr,
    String essence) async {
  logger("User Logger $obj");
  try {
    Map<String, dynamic> otp_ = obj as Map<String, dynamic>;

    customSnackBar(context, otp_['message']!);

    List usrLogin = svr.data;
    User ussr_ = User.fromData(usrLogin[0]);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return otp(
            value: otp_['code']!.toString(),
            recipient: otp_["Email"],
            essence: essence,
            user: ussr_,
          );
        },
      ),
    );
  } catch (e) {
    customSnackBar(context, svr.msg.toString());

    List usrLogin = svr.data;
    User ussr_ = User.fromData(usrLogin[0]);

    DatabaseHelper dbh = DatabaseHelper(table: usrTbl);
    await dbh.insertData(User.toMap(ussr_));

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(), // DashboardLayout(),
      ),
    );
  }
}
