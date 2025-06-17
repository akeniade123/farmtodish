// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings

// import 'dart:js_interop';

import 'dart:math';

// import 'package:Yomcoin/models/models.dart';
// import 'package:Yomcoin/screens/login.dart';
import 'package:farm_to_dish/app_theme_file.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:sqflite/sqflite.dart';

import '../../Remote/requestcore.dart';
import '../../global_objects.dart';
import '../../global_string.dart';
import '../../global_widgets.dart';
import '../screens.dart';

// import 'common_widget.dart';
// import 'screen_data_handler/signup_handler.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // late SignUpHandler signUpHandler;
  @override
  void initState() {
    // signUpHandler = SignUpHandler();

    // temp init values for testing

    // dateOfBirth = DateTime.now();
    // fullNameRetriever.text = generateRandomName() + " " + generateRandomName();
    // emailRetriever.text = 'A' + generateRandomName() + "@gmail.com";
    // phoneNumberRetriever.text = generateRandomName(isPhone: true);
    // passwordRetriever.text = 'asdf1234';
    // confirmPasswordRetriever.text = 'asdf1234';
    // gender = 'Male';
    super.initState();
  }

  String generateRandomName({bool isPhone = false}) {
    String result = '';
    if (!isPhone) {
      result = (Random().nextInt(10000) + 1000).toString();
    } else {
      result = (Random().nextInt(899999999) + 100000000).toString();
    }
    return result;
  }

  bool checkBool = false;
  DateTime? dateOfBirth;
  String errorMessage = '';
  TextEditingController fullNameRetriever = TextEditingController();
  TextEditingController emailRetriever = TextEditingController();
  TextEditingController phoneNumberRetriever = TextEditingController();

  TextEditingController passwordRetriever = TextEditingController();
  TextEditingController confirmPasswordRetriever = TextEditingController();
  String? gender;
  bool hasError = false;

  void showError(errorMessage) {
    hasError = true;
    final snackBar = SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(errorMessage),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        textColor: Theme.of(context).primaryColorLight,
        label: 'CLOSE',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool obscurePasswordText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: FarmToDishTheme.scaffoldBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  SpanedText(),
                  SizedBox(height: 10),
                  Squire(
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(bottom: 10, right: 10, left: 10),
                          border: InputBorder.none,
                          hintText: 'Full Name',
                          hintStyle: FarmToDishTheme.iStyle
                          // label: Text("Full Name :"),
                          ),
                      // : ,
                      controller: fullNameRetriever,
                      // textEditingController: fullNameRetriever,
                      // inputDecoration: InputDecoration(
                      //     hintStyle: iStyle,
                      //     border: InputBorder.none,
                      //     hintText: 'First name first'),
                      // hintText: 'First name first'
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Squire(
                          height: 40,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: DropdownButtonFormField(
                              hint: Text(
                                'Gender',
                                style: FarmToDishTheme.iStyle,
                              ),
                              isExpanded: false,
                              icon: Expanded(
                                child: Center(
                                  child: Container(
                                    alignment: Alignment.topCenter,
                                    child: Icon(Icons.keyboard_arrow_down,
                                        size: 20),
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                              items: [
                                DropdownMenuItem<String>(
                                  child: Text('Male',
                                      style: FarmToDishTheme.iStyle),
                                  value: 'Male',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Female',
                                      style: FarmToDishTheme.iStyle),
                                  value: 'Female',
                                )
                              ],
                              onChanged: (value) {
                                setState(() {
                                  gender = value ?? '';
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Squire(
                        height: 35,
                        width: 190,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text('Birth Day: ',
                                  style: Theme.of(context).textTheme.bodySmall),
                              Expanded(
                                child: Text(
                                  (dateOfBirth ?? '')
                                          .toString()
                                          .split(' ')
                                          .first
                                          .replaceAll(RegExp(r'-'), '/') +
                                      '',
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    DateTime? dob = await showDatePicker(
                                      initialDatePickerMode:
                                          DatePickerMode.year,
                                      context: context,
                                      initialDate: DateTime.now(),
                                      lastDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                    );
                                    setState(() {
                                      dateOfBirth = dob;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Theme.of(context).primaryColorLight,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Squire(
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(bottom: 10, right: 10, left: 10),
                          border: InputBorder.none,
                          hintText: 'Email' ' :',
                          hintStyle: FarmToDishTheme.iStyle
                          // label: Text('Email' ' :'),

                          ),
                      // label: 'Email' ' :',
                      // controller: ,
                      controller: emailRetriever,
                    ),
                  ),
                  SizedBox(height: 10),
                  Squire(
                    height: 49,
                    child: TelephoneNumberWidget(
                      context: context,
                      controller: phoneNumberRetriever,
                    ),
                  ),
                  SizedBox(height: 10),
                  Squire(
                    height: 40,
                    child: Stack(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                bottom: 10, right: 10, left: 10),
                            border: InputBorder.none,
                            hintStyle: FarmToDishTheme.iStyle,
                            hintText: "Password",
                            // label: Text("Password" ' :'),
                          ),
                          obscureText: obscurePasswordText,
                          // label: "Password" ' :',
                          controller: passwordRetriever,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurePasswordText = !obscurePasswordText;
                                  });
                                },
                                icon: Icon(
                                  size: 20,
                                  color: Theme.of(context).primaryColorLight,
                                  (obscurePasswordText)
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Squire(
                  //   child: Row(
                  //     children: [
                  //       LabeledTextField(
                  //         obscureText: obscurePasswordText,
                  //         label: 'Password',
                  //         // hintText: 'First name first',
                  //         onChanged: (value) {
                  //           password = value;
                  //         },
                  //       ),
                  //       IconButton(
                  //           onPressed: () {
                  //             setState(() {
                  //               obscurePasswordText != obscurePasswordText;
                  //             });
                  //           },
                  //           icon: Icon(
                  //             (obscurePasswordText)
                  //                 ? Icons.visibility_outlined
                  //                 : Icons.visibility_off_outlined,
                  //           ))
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  Squire(
                    height: 40,
                    child: Stack(
                      children: [
                        TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  bottom: 10, right: 10, left: 10),
                              border: InputBorder.none,
                              hintStyle: FarmToDishTheme.iStyle,
                              hintText: "Confirm Password",
                              // label: Text("Password" ' :'),
                            ),
                            obscureText: obscurePasswordText,
                            // decoration: InputDecoration(
                            //   border: InputBorder.none,
                            //   label: Text('Confirm Password'),
                            // ),
                            controller: confirmPasswordRetriever),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurePasswordText = !obscurePasswordText;
                                  });
                                },
                                icon: Icon(
                                  size: 20,
                                  color: Theme.of(context).primaryColorLight,
                                  (obscurePasswordText)
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: MaterialButton(
                          height: 40,
                          // minWidth: 250,
                          onPressed: (hasInternetAccess)
                              ? ((!checkBool)
                                  ? null
                                  : () async {
                                      // context.go("/HomeScreen");
                                      // identifyDeviceId();
                                      // // tempy
                                      // List<String> map = [
                                      //   '/cableServiceStore.db',
                                      //   '/electricity.db',
                                      //   '/internetService.db',
                                      //   '/airtime.db',
                                      //   '/my_database.db',
                                      //   '/userDetails.db',
                                      //   '/preLoginDetails',
                                      //   '/transferStore.db',
                                      // ];
                                      // for (var i in map) {
                                      //   String path =
                                      //       p.join(await getDatabasesPath(), i);
                                      //   File file = File(path);
                                      //   if (file.existsSync()) {
                                      //     file.deleteSync();
                                      //   }
                                      // }

                                      // .....
                                      String fullName = fullNameRetriever.text;
                                      String email = emailRetriever.text;
                                      String password = passwordRetriever.text;
                                      String confirmPassword =
                                          confirmPasswordRetriever.text;
                                      String phoneNumber =
                                          phoneNumberRetriever.text;

                                      /*
                                      regId:kljnjknkjnkjnbjkkjhkhj
                                      Full_Name:Oluwasheyi Blade22
                                      Essence:Register
                                      Phone_Number:08152004070
                                      Password:random
                                      Gender:Male
                                      DEVICE_ID:87687874
                                      Email_Address:adeyinkaakeni@gmail.com
                                      Designation:NA
                                      Manifest:Community
                                      //Unique_ID:""
                                      //Tag:""
                                      */

                                      //                               email:str
                                      // password:str
                                      // firstName: Optional[str] = None
                                      // lastName: Optional[str] = None
                                      // PhoneNumber: Optional[str] = None
                                      // birthday: Optional[str] = None
                                      // gender: Optional[str] = None
                                      // deviceID: Optional[str] = None
                                      List<Function> checkList = [
                                        () {
                                          if (password.isEmpty ||
                                              confirmPassword.isEmpty ||
                                              fullName.isEmpty ||
                                              email.isEmpty) {
                                            showError(' An entry is empty ');
                                          }
                                        },
                                        () {
                                          if (password != confirmPassword) {
                                            showError('passoword unmatched');
                                          }
                                        },
                                        () {
                                          if (gender == null) {
                                            showError(
                                                'Please, select a gender ');
                                          }
                                        },
                                        () {
                                          if (dateOfBirth == null) {
                                            showError(
                                                'Please, select your date of birth ');
                                          }
                                        }
                                      ];

                                      for (int i = 0;
                                          hasError == false &&
                                              checkList.length > i;
                                          i++) {
                                        checkList[i]();
                                      }

                                      (!hasError)
                                          ? Future.delayed(
                                              Duration.zero,
                                              () {
                                                Map<String, String> body = {
                                                  'regId':
                                                      'kljnjknkjnkjnbjkkjhkhj',
                                                  'Essence': 'Register',
                                                  'Email_Address': email,
                                                  'Gender': gender.toString(),
                                                  "Password": password,
                                                  'Phone_Number': phoneNumber,
                                                  'DEVICE_ID': '',
                                                  'Full_Name': fullName,
                                                  'Designation': 'NA',
                                                  'Manifest': 'Community',
                                                  'Unique_ID': "",
                                                  'Tag': "",
                                                  // "birthday": (dateOfBirth == null)
                                                  //     ? null
                                                  //     : DateUtils.dateOnly(dateOfBirth!)
                                                  //         .toString(),
                                                  // "firstName": fullName.split(' ')[0],
                                                  // "lastName":
                                                  //     (fullName.split(' ').length > 1)
                                                  //         ? (fullName.split(' ')[1])
                                                  //         : '',
                                                };
                                                FetchData(context, body, login);
                                                //
                                                // signUpHandler.signUp(context, body);
                                              },
                                            )
                                          : 1;

                                      hasError = false;
                                    })
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: Duration(seconds: 1),
                                          content: Center(
                                              child: Text('No internet'))));
                                },
                          color: FarmToDishTheme.faintGreen,
                          // Color.fromARGB(255, 69, 22, 147),
                          disabledColor: Colors.grey,
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Registered? "),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                          },
                          child: Text(
                            "Login now",
                            // style: TextStyle(color: Colors.blue),
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: checkBool,
                        onChanged: (value) {
                          // signUpHandler.deleteDB();
                          setState(() {
                            checkBool = !checkBool;
                          });
                        },
                      ),
                      Text(
                        'I accept the terms and conditions of  this \n organization.',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class SpanedText extends StatelessWidget {
  const SpanedText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: 30),
        children: [
          TextSpan(
              text: 'Sign Up ',
              style: TextStyle(
                color: Color.fromARGB(255, 69, 22, 147),
              )),
          TextSpan(
            text: 'Now',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

// bool checkBool2 = false;
