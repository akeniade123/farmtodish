import 'package:farm_to_dish/app_theme_file.dart';
import 'package:farm_to_dish/global_handlers.dart';
import 'package:farm_to_dish/notificationcontroller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

import 'env.dart';
import 'firebaseHandler.dart';
import 'firebase_options.dart';
import 'global_objects.dart';
import 'global_string.dart';
import 'routing_detail.dart';
import 'sharedpref.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();

  // deviceId;

  if (!UniversalPlatform.isWeb) {
    WidgetsFlutterBinding.ensureInitialized();
  }

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]); // -->[1]

  // identifyDeviceId();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static var navigatorKey;

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPref pref;
  @override
  initState() {
    // NotificationController.startListeningNotificationEvents();
    super.initState();

    pref = SharedPref();

    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(resumeCallBack: () async {
      // The app is now resumed, so let's change the value to false
      setState(() {
        logger("At Foreground ****");
      });
    }, suspendingCallBack: () async {
      // The app is now inactive, so let's change the value to true
      setState(() {
        //  isAppInactive = true;
        logger("In the Background ****");
      });
    }));

    msgg();
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
        logger("UserToken***$fbId");
      } catch (e) {}
    }
    try {
      fbId = (await pref.getPrefString(tk_id))!;
      logger("UserToken***$fbId");
    } catch (e) {}

    logger("Chktkn$fbId");

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
        logger("Fore OPen");
        // do something
      });
    }
  }

  Future<void> receivedMessage(RemoteMessage remoteMessage) async {
    await handleUpdates(remoteMessage, true);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // navigatorKey: rootNavigatorKey,
      scaffoldMessengerKey: snackbarKey,
      routerConfig: myRouter,
      title: 'FarmToDish',
      theme: FarmToDishTheme.light(),
      // home: WillPopScope(
      //   onWillPop: () async {
      //     DateTime now = DateTime.now();
      //     if (currentBackPressTime == null ||
      //         now.difference(currentBackPressTime!) >
      //             const Duration(seconds: 2)) {
      //       currentBackPressTime = now;
      //       setState(() {});
      //       await Fluttertoast.showToast(msg: 'exit_warning');
      //       return false;
      //     }
      //     return Future.value(true);
      //   },
      //   child: const loggerinScreen(),
      // ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
