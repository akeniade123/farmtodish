import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:farm_to_dish/Repository/databaseHelper.dart';
import 'package:farm_to_dish/app_theme_file.dart';
import 'package:farm_to_dish/global_handlers.dart';
//import 'package:farm_to_dish/notificationcontroller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

import 'Remote/requestmodel.dart';
import 'env.dart';
import 'firebaseHandler.dart';
import 'firebase_options.dart';
import 'global_objects.dart';
import 'global_string.dart';
import 'routing_detail.dart';
import 'sharedpref.dart';

const _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = true;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // await NotificationController.initializeLocalNotifications();
  // await NotificationController.initializeIsolateReceivePort();

  await initializeService();

  dbCart = DatabaseHelper(table: orderItem);

  // FirebaseMessaging.

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // deviceId;

  if (!UniversalPlatform.isWeb) {
    WidgetsFlutterBinding.ensureInitialized();
  }

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]); // -->[1]

  crashlyticsBase();
  // identifyDeviceId();
  runApp(const MyApp());
}

void crashlyticsBase() {
  const fatalError = true;
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  handleUpdates(message, false);

  // print("Handling a background message: ${message.messageId}");
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  String strk = "basic";

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String crrState = "None";

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) async {
      service.setAsForegroundService();

      try {
        logger("Transcience: Preliminary");
        SharedPref pref = SharedPref();

        strk = (await pref.getPrefString(paystruct))!;
        logger("Transcience: $strk");
      } catch (e) {
        logger("Transcience error: $e");
      }

      print("Currency: ${service.toString()}");
      crrState = "Foregroundxxx";
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
      crrState = "Background";
    });

/*

    service.onDataReceived.listen((event) {
      print('Background data received: $event');
    });

    */

    service.on('UINotify').listen((event) {
      logger("Awesome Notifier");
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        /// OPTIONAL for use custom notification
        /// the notification id must be equals with AndroidConfiguration when you call configure() method.
        flutterLocalNotificationsPlugin.show(
          888,
          'COOL SERVICE',
          'Awesome ${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'my_foreground',
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );

        // if you don't using custom notification, uncomment this
        service.setForegroundNotificationInfo(
          title: "Farm to Dish ",
          content: "Background Session at ${DateTime.now()}",
        );
      }
    }

    /// you can see this log in logcat
    print(
        'Tentacle:: $crrState ### $strk  FLUTTER BACKGROUND SERVICE***: ${DateTime.now()}');

/*
    if (ussr_.Eligible == "0" && await pref.getPrefString(usrPrf) != usrPrf) {
      if (profPic != null) {
        Uint8List img = await profPic!.readAsBytes();
        await saveData(
            name: ussr_.Name, bio: "bio", file: img, essence: usrPrf);
      }
      print("$usrPrf: Unindexed profile...");
    } else {
      print("$usrPrf: Indexed profile...");
    }

*/

    SharedPref pref = SharedPref();

    //Revisit these

    /*

      if (await pref.getPrefString(usrPrf) != usrPrf) {
        if (profPic != null) {
          Uint8List img = await profPic!.readAsBytes();
          await saveDataToFbStorage(
              name: "${ussr_.Name.replaceAll(" ", "").toLowerCase()}.png",
              bio: "bio",
              file: img,
              essence: usrPrf);

          print("$usrPrf: AdexIndexed profile... procession");
        } else {
          print("$usrPrf: Unindexed profile...***");
        }
      } else {
        print("$usrPrf: Indexed profile...");
      }

      print(
          'Tentacle Exec: $crrState ### $strk  FLUTTER BACKGROUND SERVICE***: ${DateTime.now()}');

      DatabaseHelper dbh = DatabaseHelper(table: paystruct);

      List<Map<String, dynamic>> db = await dbh.queryAllRows();
      for (int i = 0; i < db.length; i++) {
        Map<String, dynamic> dbb = db[i];

        // logger("${dbb[id_]} *** ${dbb[payload]}");
        Map<String, dynamic> dyn = jsonDecode(dbb[payload]);
        logger(dyn[ess]);
        switch (dyn[ess]) {}
      }

      */

    // test using external plugin
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "device": device,
      },
    );
  });
}

class MyApp extends StatefulWidget {
  static var navigatorKey;

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPref pref;

  late Future<void> _initializeFlutterFireFuture;

  Future<void> _testAsyncErrorOnInit() async {
    Future<void>.delayed(const Duration(seconds: 2), () {
      final List<int> list = <int>[];
      print(list[100]);
    });
  }

  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    if (_kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    if (_kShouldTestAsyncErrorOnInit) {
      await _testAsyncErrorOnInit();
    }
  }

  @override
  initState() {
    // NotificationController.startListeningNotificationEvents();
    super.initState();

    // _initializeFlutterFireFuture = _initializeFlutterFire();

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

    //  logger("Queued: ${await dbh.queryRowCount()}");
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
        logger("UserToken Indexed***$fbId");
      } catch (e) {}
    }
    try {
      fbId = (await pref.getPrefString(tk_id))!;
      logger("UserToken Retrieved***$fbId");
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
      FirebaseMessaging.onMessageOpenedApp.listen(receivedMessage);
      // FirebaseMessaging.onMessageOpenedApp.listen((event) {
      //   logger("Fore OPen");
      //   // do something
      // });
      //  FirebaseMessaging.instance.getInitialMessage().then((value) => null)
    }

    DatabaseHelper dbh = DatabaseHelper(table: ctg);
    int ipp = await dbh.queryRowCount();
    logger("***$ipp");
  }

  Future<void> receivedMessage(RemoteMessage remoteMessage) async {
    await handleUpdates(remoteMessage, true);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => UINotifier(), child: routeDefs(_scaffoldKey));

    /*
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
    */
  }

  MaterialApp routeDefs(GlobalKey<ScaffoldState> ctxKey) {
    //  FlutterNativeSplash.remove();
    return MaterialApp.router(
      // navigatorKey: rootNavigatorKey,
      scaffoldMessengerKey: snackbarKey,
      routerConfig: myRouter,
      title: 'FarmToDish',
      theme: FarmToDishTheme.light(),
      // home: const Splashscreen(),

      // pDt: (context) => const Profile()
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
