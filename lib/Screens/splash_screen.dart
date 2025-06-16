import 'dart:developer';
import 'package:go_router/go_router.dart';

import '../Repository/databaseHelper.dart';
import '../env.dart';
import '../firebaseHandler.dart';
import '../global_objects.dart';
import '../global_string.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../firebase_options.dart';
import '../sharedpref.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'onboarding.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  late VideoPlayerController _controller;
  late DatabaseHelper dbh;
  late Stopwatch stopwatch;
  late SharedPref pref;
  Future<int>? prelim_;
  bool prelim = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pref = SharedPref();
    stopwatch = Stopwatch();

    /*

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
        log("Notification permission yet to be granted***");
      } else {
        log("Notification permission allowed already...");
      }
    });

    */
    msgg();

    try {
      _controller = VideoPlayerController.asset(
        'assets/images/splash.mp4',
      )
        ..initialize().then((_) {
          //  setState(() {});
        })
        ..setVolume(0.0);
    } catch (e) {
      log("Splash prelim:");
    }
    try {
      _playVideo();
    } catch (e) {}
  }

  Future<void> msgg() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (await pref.getPrefBool(token) == false) {
      try {
        fbId = (await FirebaseMessaging.instance.getToken())!;
        pref.setPrefString(tk_id, fbId);
        pref.setPrefBool(token, true);
        log("UserToken***$fbId");
      } catch (e) {}
    }
    try {
      fbId = (await pref.getPrefString(tk_id))!;
      log("UserToken***$fbId");
    } catch (e) {}

    log("Chktkn$fbId");

    if (fbId != community || fbId.isNotEmpty) {
      if (await pref.getPrefBool(prlmtpc) == false) {
        String topic = "genElites";
        if (lone) {
          topic = "gen$org_";
        }
        subscribeToTopic(topic);
        await pref.setPrefBool(prlmtpc, true);
      }

      if (await pref.getPrefBool(defdm) == false) {
        subscribeToTopic(org_.replaceAll(" ", ""));
        await pref.setPrefBool(defdm, true);
      }

      FirebaseMessaging.onMessage.listen(receivedMessage);
      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        log("Fore OPen");
        // do something
      });
    }
  }

  Future<void> receivedMessage(RemoteMessage remoteMessage) async {
    await handleUpdates(remoteMessage, true);
  }

  Future<int> prlmChk() async {
    bool prelim = await pref.getPrefBool(shm);
    return 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _playVideo() async {
    FlutterNativeSplash.remove();
    try {
      stopwatch.start();
      await _controller.play();
      int dur = _controller.value.duration.inSeconds;
      log("Duration:$dur");
    } catch (e) {
      log("Splash error: $e");
    }

    (appStatus == prod)
        ? {init = const Splashscreen()} //  OnboardingPage()}
        : {init = const Splashscreen()}; // ActivityFlow()};
    prlmChk();

    // await Future.delayed(const Duration(seconds: 8));
    splashWait();
  }

  Future<void> splashWait() async {
    int elapsed = stopwatch.elapsedMilliseconds;

/*
    while (elapsed < splashTime) {
      log("Time elapsed:$elapsed");
      splashWait();
    }
    */

    /*
    Future.delayed(Duration.zero,(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
          return AlertDialog(
            title: Text("How are you?"),
          );
    });
  });
    */

    if (prelim == true) {
      // Navigator.pushNamed(context, '/');
      bool lgn_ = await pref.getPrefBool(lgn);
      if (lgn_ == true) {
        /*
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const DashboardLayout(),
          ),
        );
        */
        context.go("/HomeScreen");
      } else {
        dbh = DatabaseHelper(table: usrTbl);

        if (await dbh.queryRowCount() > 0) {
          context.go("/HomeScreen");
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) => const DashboardLayout(),
          //   ),
          // );
        } else {
          context.go(login);
          //   Navigator.of(context).pushReplacement(
          //       MaterialPageRoute(builder: (context) => const Login()));
          //
        }
      }
    } else {
      context.go(login);
      //  Navigator.of(context).pushReplacement(
      //      MaterialPageRoute(builder: (context) => const OnboardingPage()));
    }
    // Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(
                  _controller,
                ),
              )
            : Container(),
      ),
    );
  }
}
