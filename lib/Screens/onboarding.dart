import 'dart:convert';
import 'dart:developer';
import 'package:go_router/go_router.dart';

import '../Repository/databaseHelper.dart';
import '../env.dart';
import '../global_string.dart';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:shared_preferences/shared_preferences.dart';

//import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../sharedpref.dart';

//var shrd = SharedPref();

/*
Future<void> main() async {
  await shrd.getPrefBool(shm) ?? false;
  runApp(const OnboardingPage());
}
*/

void main() {
  runApp(const OnboardingPage());
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  late SharedPref pref;
  late Future<bool> _futureNav;

  @override
  void initState() {
    super.initState();

    // Navigator.of(MainNavKey.currentState!.overlay!.context).push(DialogRoute(
    //   barrierColor: Colors.white.withAlpha(120),
    //   context: context,
    //   builder: (context) => Container(
    //     color: Colors.white.withAlpha(100),
    //     child: Center(
    //         child: CircularProgressIndicator(
    //       color: Theme.of(context).primaryColor,
    //     )),
    //   ),
    // ));

    Future.delayed(Duration.zero, () async {
      await prelim();
    });

    // Navigator.of(MainNavKey.currentState!.overlay!.context).pop();
  }

  bool isLastPage = false;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> prelim() async {
    pref = SharedPref();

    setState(() {
      _futureNav = pref.getPrefBool(shm);
    });

    if (await _futureNav) {
      DatabaseHelper dbh = DatabaseHelper(table: usrTbl);
      int qq = await dbh.queryRowCount();
      if (qq > 0) {
        List<Map<String, dynamic>> ddd = await dbh.queryAllRows();
        String str = jsonEncode(ddd);
        log("User Data: $str");
        context.go(home);
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => const DashboardLayout(),
        //   ),
        // );
      } else {
        if (await _futureNav) {
          log("Already launched before now...");
          // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //     builder: (context) => const Login())); //const LoginScreen()));)

          context.go(login);
        } else {
          //  FlutterNativeSplash.remove();
        }
      }
    } else {
      //  FlutterNativeSplash.remove();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(bottom: 70),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: [
            Image.asset('assets/images/slide_1.png'),
            Image.asset('assets/images/slide_2.png'),
            Image.asset('assets/images/slide_3.png'),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool(shm, true);
                context.go(login);

                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //     builder: (context) =>
                //         const Login())); //const LoginScreen()));
              },
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1)),
                  foregroundColor: Colors.white,
                  backgroundColor: bgmainclr,
                  minimumSize: const Size.fromHeight(80)),
              child: const Text(
                'Get Started',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ))
          : Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: Checkbox.width),
              height: 60,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: const Text(
                        'SKIP',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () => controller.jumpToPage(2),
                    ),
                    Center(
                        child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                          dotColor: Colors.black26,
                          activeDotColor: Colors.teal.shade700),
                      onDotClicked: (index) => controller.animateToPage(index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn),
                    )),
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1)),
                        foregroundColor: Colors.white,
                        backgroundColor: bgmainclr,
                      ),
                      child: const Text('NEXT'),
                      onPressed: () => controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn),
                    )
                  ])));
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}
