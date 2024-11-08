import 'package:farm_to_dish/app_theme_file.dart';
import 'package:farm_to_dish/requester.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../global_objects.dart';
import '../../global_widgets.dart';

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
            const SizedBox(height: 27),
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
                                obscuringCharacter: '#',
                                controller: passwordRetriever,
                                decoration: InputDecoration(
                                    hintText: "Password :",
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
                SizedBox(width: 4),
                Squire(
                    height: 40,
                    width: 127,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'keep me',
                            style: TextStyle(fontSize: 12),
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
                              Center(child: CircularProgressIndicator()),
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
                            content: Center(
                              child: Text("Please, enter your email "),
                            ),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
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
                      style: FarmToDishTheme.iStyle!.copyWith(
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
                            context.go("/HomeScreen");
                            // await loginHandler.login(
                            //     context,
                            //     {
                            //       'email': emailRetreiver.text,
                            //       'password': passwordRetriever.text,
                            //     },
                            //     rememberBool);

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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      "Log In",
                      style: TextStyle(color: Colors.white),
                    ),
                    height: 40,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("New user? "),
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


class LoginScreenHandler{
  Future login(String email, String password)async{
    requestResources("$baseURL", body, headers, requestType)
  }
}