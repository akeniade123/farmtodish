// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings

// import 'dart:js_interop';

// import 'package:flutter/widgets.dart' as w;
// import 'package:Yomcoin/models/models.dart';
// import 'package:Yomcoin/screens/login.dart';
import 'dart:io';

import 'package:farm_to_dish/Screens/Chat/models/profile.dart';
import 'package:farm_to_dish/app_theme_file.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:sqflite/sqflite.dart';

import '../../Dialogs/dialog_stack.dart';
import '../../Models/model_stack.dart';
import '../../Remote/requestcore.dart';
import '../../Repository/databaseHelper.dart';
import '../../global_objects.dart';
import '../../global_string.dart';
import '../../global_widgets.dart';
import '../Products/product_screen.dart';

// import 'common_widget.dart';
// import 'screen_data_handler/signup_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late DatabaseHelper dbo;

  Future<List<Map<String, dynamic>>>? pndOrder, dlvOrder;
  Future<Wrap>? stack;

  @override
  void initState() {
    super.initState();
    dbo = DatabaseHelper(table: order);
    usrNm = null;
    usrNm = getData(usr, context); //_userDtls(acct);
    pndOrder = _futureOrderStack(true);
    dlvOrder = _futureOrderStack(false);
  }

  Future<List<Map<String, dynamic>>> _futureOrderStack(bool current) async {
    List<Map<String, dynamic>> orders = [];
    if (current == true) {
      Map<String, dynamic> cls = {stt: pnd};
      List<Map<String, dynamic>> orders = await dbo.queryRowsClause(cls);
    } else {
      Map<String, dynamic> cls = {stt: dlv};
      List<Map<String, dynamic>> orders = await dbo.queryRowsClause(cls);
    }
    return orders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FarmToDishTheme.scaffoldBackgroundColor,
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 200),
          child: AppBar(
              toolbarHeight: 350,
              centerTitle: true,
              backgroundColor: FarmToDishTheme.scaffoldBackgroundColor,
              title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    _buildTopComponent(),
                    _buildSecondBlock(),
                    // divider
                    // Divider(color: ,)
                    buildDivider(),
                    SizedBox(height: 20),
                  ]))),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 33.0, vertical: 20),
        child: Column(
          children: [
            SizedBox(height: 5),
            Text(
              "Account Summary",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: FarmToDishTheme.deepGreen,
              ),
            ),
            _account(avl_bl),
            _account(csh_bk),
            _account(lvl),
            _buildSelectorTab(),
            SizedBox(height: 20),
            _settings(),
            SizedBox(height: 20),
            TitleMoreAndBodyWidget(
              body: (pndOrder == null)
                  ? (Text("No pending transaction"))
                  : Column(children: [_stackTranzacts(true)]),
              titleWidget: _buildTitleForLists("Current Order"),
              isSeeAll: true,
            ),
            SizedBox(height: 20),
            TitleMoreAndBodyWidget(
              body: Column(children: [
                _buildItem(
                    imageWidget: Image.asset(
                      "${assets}yams.png",
                    ),
                    title: "Yam Tubers",
                    subtitle: "goods in transit"),
                SizedBox(height: 15),
                // _buildItem(
                //     imageWidget: Image.asset(
                //       "${assets}yams.png",
                //     ),
                //     title: "Yams and peppers",
                //     subtitle: "1 day to delivery"),
                // SizedBox(height: 15),
                // _buildItem(
                //     imageWidget: Image.asset(
                //       "${assets}yams.png",
                //     ),
                //     title: "Yams and peppers",
                //     subtitle: "1 day to delivery"),
              ]),
              titleWidget: _buildTitleForLists("History"),
              isSeeAll: true,
            ),
            SizedBox(height: 20),
            SizedBox(
                width: double.infinity,
                height: 40,
                child: MaterialButton(
                  height: 20,
                  minWidth: 100,
                  onPressed: () async {
                    logout(context);
                  },
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: const Text(
                    "Log Out",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                )),
            SizedBox(height: 70),
          ],
        ),
      )),
    );
  }

  FutureBuilder<Wrap> _stackTranzacts(bool current) {
    return FutureBuilder(
        future: stack,
        builder: (context, snapshot) {
          return Wrap(alignment: WrapAlignment.center, children: []);
        });

    // return Column(
    //   children: [
    //     _buildItem(
    //         imageWidget: Image.asset(
    //           "${assets}shop.png",
    //         ),
    //         title: "Yams and peppers",
    //         subtitle: "1 day to delivery"),
    //     SizedBox(height: 15),
    //     _buildItem(
    //         imageWidget: Image.asset(
    //           "${assets}yams.png",
    //         ),
    //         title: "Yams and peppers",
    //         subtitle: "1 day to delivery"),
    //     SizedBox(height: 15),
    //     _buildItem(
    //         imageWidget: Image.asset(
    //           "${assets}yams.png",
    //         ),
    //         title: "Yams and peppers",
    //         subtitle: "1 day to delivery"),
    //   ],
    // );
  }

  Container _buildItemz(Map<dynamic, dynamic> content) {
    return Container(
      height: 89,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: FarmToDishTheme.accentLightColor,
          boxShadow: List.filled(4, FarmToDishTheme.genericBoxShadow)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
        child: Row(children: [
          Container(
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                "${assets}shop.png",
              )),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                content[id],
                style: FarmToDishTheme.listMainText,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.watch_later,
                    color: FarmToDishTheme.listSubText.color,
                    size: 15,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "***",
                    style: FarmToDishTheme.listSubText,
                  ),
                ],
              ),
            ],
          )
        ]),
      ),
    );
  }

  // Widget _stackTranzacts() {}

  Container _buildItem({Widget? imageWidget, String? title, String? subtitle}) {
    return Container(
      height: 89,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: FarmToDishTheme.accentLightColor,
          boxShadow: List.filled(4, FarmToDishTheme.genericBoxShadow)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
        child: Row(children: [
          Container(
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: imageWidget),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title.toString(),
                style: FarmToDishTheme.listMainText,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.watch_later,
                    color: FarmToDishTheme.listSubText.color,
                    size: 15,
                  ),
                  SizedBox(width: 10),
                  Text(
                    subtitle.toString(),
                    style: FarmToDishTheme.listSubText,
                  ),
                ],
              ),
            ],
          )
        ]),
      ),
    );
  }

  Container _buildTitleForLists(String title) {
    return Container(
      alignment: Alignment.center,
      height: 35,
      // width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: FarmToDishTheme.deepGreen),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Text(
          title,
          style: TextStyle(
            color: FarmToDishTheme.scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }

  Row _account(String essence) {
    String _acct = "";
    Future<String>? dtl;
    switch (essence) {
      case avl_bl:
        _acct = acct;
        dtl = account;
        break;
      case csh_bk:
        _acct = csh_bk;
        dtl = account;
        break;

      case lvl:
        _acct = lvl;
        dtl = account;
        break;

      default:
        break;
    }
    return Row(
      children: [
        Align(alignment: Alignment.bottomLeft, child: Text("$essence:")),
        const Expanded(child: SizedBox()),
        Align(
          alignment: Alignment.bottomRight,
          child: (account == null)
              ? Text("---")
              : usrDtl(context, _acct, dtl, FarmToDishTheme.deepGreen, 15),
        ),
      ],
    );
  }

  String selectedTabName = "";

  Container _settings() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: FarmToDishTheme.accentLightColor,
      ),
      child: _set(),
    );
  }

  Column _set() {
    //  List<String> set_ = [psw_, dlv_, ref_, shr_, tms_, cnt_];
    List<ProfileLog> fld = [
      ProfileLog(name: psw_, essence: psw_),
      ProfileLog(name: dlv_, essence: dlv_),
      //    ProfileLog(name: ref_, essence: ref_),
      //    ProfileLog(name: shr_, essence: shr_),
      //  ProfileLog(name: tms_, essence: tms_),
      ProfileLog(name: cnt_, essence: cnt_)
    ];
    /*

Version 1.0
    */
    return Column(
        children: fld.map((e) => nav(e.name, e.essence, context)).toList());
  }

  TitleMoreAndBodyWidget _buildSelectorTab() {
    return TitleMoreAndBodyWidget(
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            SelectionChip(
              name: "Fund Wallet",
              imageURL: "${assets}fruitVeggie.png",
              isSelected: selectedTabName == "fruits And Vegie",
              onClickFunction: (p0) {
                selectedTabName = "fruits And Vegie";
                setState(() {});

                showDialog(
                    context: context, builder: (context) => FundWallet());
              },
              essence: '',
            ),
            SizedBox(width: 10),
            SelectionChip(
              name: "Earn Cashback",
              imageURL: "${assets}grains.png",
              isSelected: selectedTabName == "Grains and legumes",
              onClickFunction: (p0) {
                selectedTabName = "Grains and legumes";
                customSnackBar(context, "Cash back terrain begins in August");

                setState(() {});
              },
              essence: '',
            ),
            SizedBox(width: 10),
            SelectionChip(
              name: "Upgrade Level",
              imageURL: "${assets}tubbers.png",
              isSelected: selectedTabName == "Tubers",
              onClickFunction: (p0) {
                customSnackBar(context,
                    "We'll review your request and get across upon verification");

                selectedTabName = "Tubers";
                setState(() {});
              },
              essence: '',
            ),
            SizedBox(width: 10)
          ]),
        ),
        titleWidget: Text(
          "Transactions",
          style: TextStyle(
              // color:
              // FarmToDishTheme.scaffoldBackgroundColor,
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ));
  }

  Column _buildSecondBlock() {
    return Column(
      children: [
        CircleAvatar(
          // clipBehavior: Clip.hardEdge,
          // decoration: BoxDecoration(shape: BoxShape.circle),
          radius: 60,
          backgroundImage: Image.asset("${assets}shop.png").image,
          // child: ,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO : attach live data
            (usrNm == null)
                ? Text("Hi!")
                : usrDtl(context, usr, usrNm, Colors.black, 13),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => Navs(
                            essence: psw_,
                            caption: psw_,
                          ));
                },
                icon: Icon(
                  Icons.edit_square,
                  color: FarmToDishTheme.deepGreen,
                ))
          ],
        )
      ],
    );
  }

  Row _buildTopComponent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: Navigator.of(context).canPop(),
          child: CircleAvatar(
            backgroundColor: FarmToDishTheme.accentLightColor,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.chevron_left),
            ),
          ),
        ),
        //   IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_outlined))
      ],
    );
  }
}

whatsapp(var contact) async {
  // = "+880123232333";
  var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
  var iosUrl =
      "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

  try {
    if (Platform.isIOS) {
      await launchUrl(Uri.parse(iosUrl));
    } else {
      await launchUrl(Uri.parse(androidUrl));
    }
  } on Exception {
    // EasyLoading.showError('WhatsApp is not installed.');
  }
}
