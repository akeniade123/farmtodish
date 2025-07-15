// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings

// import 'dart:js_interop';

// import 'package:flutter/widgets.dart' as w;
// import 'package:Yomcoin/models/models.dart';
// import 'package:Yomcoin/screens/login.dart';
import 'dart:convert';

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:farm_to_dish/app_theme_file.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../Repository/databaseHelper.dart';
import '../../global_handlers.dart';
import '../../global_objects.dart';
import '../../global_string.dart';
// import 'package:sqflite/sqflite.dart';

// import 'common_widget.dart';
// import 'screen_data_handler/signup_handler.dart';
class MainPage extends StatefulWidget {
  const MainPage(this.navigationShell, {super.key});
  final StatefulNavigationShell navigationShell;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // List<Widget> pages = [
  //   const MyHomePage(),
  //   const BillsPaymentScreen(),
  //   const MarketScreen(),
  //   const CryptoHomeScreen(),
  //   const ProfileScreen()
  // ];
  bool checkIfCurrentIndexIsTheSameAsItem(int index) {
    return (widget.navigationShell.currentIndex == index);
  }

  List<TabItem> items = [];
  Future<BottomBarInspiredInside>? tabs;

  Future<String>? category() async {
    DatabaseHelper dbm = DatabaseHelper(table: mnf);

    int i = await dbm.queryRowCount();

    if (i > 0) {
      List<Map<String, dynamic>> dd = await dbm.queryAllRows();
      Map<String, dynamic> ust = dd[0];
      cppt = jsonDecode(ust[cpt]);
      Map<String, dynamic> pp = cppt[usrTbl];

      logger("Category Deserialization: $cppt");
      switch (pp[ctg]) {
        case "10":
          logger("It's 10");
          break;
        case "11":
          logger("It's -- 11");
          break;
        default:
          logger("It's definitely ${pp[ctg]}");
          break;
      }
    }
    return "Category";
  }

  Consumer ftr() {
    return Consumer<UINotifier>(builder: (context, notifier, child) {
      return castTabs();
    });
  }

  FutureBuilder<BottomBarInspiredInside> castTabs() {
    return FutureBuilder(
        future: tabs,
        builder: (context, snapshot) {
          return BottomBarInspiredInside(
            items: items,
            // backgroundColor: Colors.transparent,
            backgroundColor: FarmToDishTheme.faintGreen,

            color: Colors.white,
            colorSelected: FarmToDishTheme.deepGreen,
            indexSelected: widget.navigationShell.currentIndex,
            onTap: onTap,
            chipStyle: const ChipStyle(
              convexBridge: true,
              background: Colors.white,
            ),
            itemStyle: ItemStyle.circle,
            animated: true,
          );
        });
  }

  @override
  void initState() {
    super.initState();
    category();
  }

  void onTap(index) {
    widget.navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == widget.navigationShell.currentIndex,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    items = [
      TabItem(
        icon: Icons.person,
      ),
      TabItem(

          // icon: ImageIcon(Image.asset("coffee.png").image),
          icon: (checkIfCurrentIndexIsTheSameAsItem(1))
              ? Icons.home_filled
              : Icons.home_filled
          // title: 'Shop',
          ),
      TabItem(

          // icon: ImageIcon(Image.asset("coffee.png").image),
          icon: Icons.inventory_2
          // title: 'Shop',
          ),
      TabItem(

          // icon: ImageIcon(Image.asset("coffee.png").image),
          icon: Icons.local_shipping
          // title: 'Shop',
          ),
      // TabItem(

      //     // icon: ImageIcon(Image.asset("coffee.png").image),
      //     icon: Icons.schedule_send_sharp
      //     // title: 'Shop',
      //     ),
    ];

    // void _onTap(index) {
    //   prePush(context);
    //   if (index == 2 || index == 3) {
    //     isCurrentScreenWithCryptoSignal = true;
    //   } else {}
    //   setState(() {
    //     _formerIndex = selectedIndex;
    //     selectedIndex = index;
    //     if (_formerIndex == index) {
    //     } else {
    //       bottomNavKey.currentState?.push(PageRouteBuilder(
    //         transitionDuration: Duration.zero,
    //         reverseTransitionDuration: Duration.zero,
    //         pageBuilder: (context, animation1, animation2) {
    //           return pages[index].animate().slideX(
    //               duration: 100.ms,navigationShell
    //               begin: (_formerIndex < selectedIndex) ? 6 : -6);
    //         },
    //       ));
    //     }
    //   });
    // }

    return Scaffold(
      // persistentFooterButtons: [],
      body: Stack(children: [
        widget.navigationShell,
        // Navigator(
        //   key: bottomNavKey,
        //   onGenerateRoute: (settings) {
        //     return MaterialPageRoute(
        //       settings: settings,
        //       builder: (context) => Container(child: const HomeContent()),
        //     );
        //   },
        // ),
        Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                FarmToDishTheme.faintGreen,
                FarmToDishTheme.deepGreen
              ])),
              child: BottomBarInspiredInside(
                items: items,
                // backgroundColor: Colors.transparent,
                backgroundColor: FarmToDishTheme.faintGreen,

                color: Colors.white,
                colorSelected: FarmToDishTheme.deepGreen,
                indexSelected: widget.navigationShell.currentIndex,
                onTap: onTap,
                chipStyle: const ChipStyle(
                  convexBridge: true,
                  background: Colors.white,
                ),
                itemStyle: ItemStyle.circle,
                animated: true,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
