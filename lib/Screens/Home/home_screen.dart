// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings

// import 'dart:js_interop';

import 'dart:io';
import 'dart:math';
// import 'package:flutter/widgets.dart' as w;
// import 'package:Yomcoin/models/models.dart';
// import 'package:Yomcoin/screens/login.dart';
import 'package:farm_to_dish/Dialogs/dialog_to_adding_products.dart';
import 'package:farm_to_dish/Screens/DeliveryCar/delivery_car_model.dart';
// import 'package:farm_to_dish/Screens/Payment/cart_model.dart';
import 'package:farm_to_dish/Screens/Products/product_model.dart';
import 'package:farm_to_dish/app_theme_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../../global_objects.dart';
import '../../global_widgets.dart';
import '../screens.dart';

// import 'common_widget.dart';
// import 'screen_data_handler/signup_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  // bool checkBool = false;
  DateTime? dateOfBirth;
  String errorMessage = '';
  TextEditingController fullNameRetriever = TextEditingController();
  TextEditingController emailRetriever = TextEditingController();
  TextEditingController phoneNumberRetriever = TextEditingController();

  TextEditingController passwordRetriever = TextEditingController();
  TextEditingController confirmPasswordRetriever = TextEditingController();
  String? gender;
  bool hasError = false;
  Map<int, List<String>> sectionSlabs = {
    0: ["Fruits vegetables", "${assets}fruitVeggie.png"],
    1: ["Grains and legumes", "${assets}grains.png"],
    2: ["Tubers", "${assets}tubbers.png"],
    3: ["Spices", "${assets}pepper.png"],
  };

  void showError(errorMessage) {
    // [
    //   "${asset}assetss/fruitVeggie.png",
    //   "${asset}assetss/grains.png",
    //   "${asset}assetss/pepper.png",
    //   "${asset}assetss/tubbers.png",
    // ];

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
  List<DeliveryCarModel> deliveryCarList = [
    DeliveryCarModel(),
    DeliveryCarModel(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FarmToDishTheme.scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconButtonWithBorder(
                      func: () {}, iconData: Icons.person_outline_outlined),
                  Text(
                    "Welcome, Babatunde Bamgbose",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  _iconButtonWithBorder(
                      func: () {}, iconData: Icons.notifications),
                ],
              ),
              SizedBox(height: 10),
              _accountDetail(),
              SizedBox(height: 10),
              _buildPack2(),
              SizedBox(height: 10),
              Wrap(
                runAlignment: WrapAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: productTypeDetails
                    .map((e) => _buildCategorySlab(e))
                    .toList(),
              ),
              //  sectionSlabs.keys
              //     .map((e) => _buildCategorySlab(e))
              //     .toList()),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delivery Pools",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 13),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: deliveryCarList
                            .map((e) => _buildDeliveryPoolCard(e))
                            .toList()
                        // [
                        //   _buildDeliveryPoolCard(),
                        //   SizedBox(width: 13),
                        //   _buildDeliveryPoolCard(),
                        //   SizedBox(width: 13),
                        //   _buildDeliveryPoolCard(),
                        // ],
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: 80,
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryPoolCard(DeliveryCarModel e) {
    return InkWell(
      onTap: () {
        // context.go("location")
        // context.push();
        Navigator.of(rootNavigatorKey.currentState!.context).push(
          MaterialPageRoute(
            builder: (context) => DeliveryCarDetailScreen(model: e),
          ),
        );
      },
      child: Container(
        height: 185,
        width: 180,
        decoration: BoxDecoration(
          color: FarmToDishTheme.accentLightColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: List.filled(
            4,
            FarmToDishTheme.genericBoxShadow,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  // padding: EdgeInsets.all(5),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // "${assets}fruitVeggie.png"

                  child: Image.asset("${assets}map.png")),
              Text(
                "Delivery Pools",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Color(0xff373737),
                  ),
                  Text(
                    "Main Gate",
                    style: TextStyle(
                      fontSize: 14,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySlab(Map e) {
    return InkWell(
      onTap: () {
        context.pushNamed("ProductScreen", extra: e["name"]);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: FarmToDishTheme.accentLightColor,
            borderRadius: BorderRadius.circular(7),
            boxShadow: List.filled(4, FarmToDishTheme.genericBoxShadow)),

        // height: 110,
        width: 95, height: 120,
        // MediaQuery.of(context).size.width * .25 - 30,

        child: AspectRatio(
          aspectRatio: 92 / 110,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Image.asset(e["imageURL"] ?? ""),
                  ),
                  Text(
                    e["name"],
                    textAlign: TextAlign.center,
                    // style: TextStyle(),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  SizedBox _accountDetail() {
    return SizedBox(
      height: 115,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(15),
              height: 113,
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Available Balance",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Transaction History",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "₦35,762.33",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: MaterialButton(
                      height: 20,
                      minWidth: 100,
                      onPressed: () {
                        context.go("/ProductScreen");
                      },
                      color: FarmToDishTheme.faintGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "Fund Wallet",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: FarmToDishTheme.deepGreen,
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 5,
                  ),

/*

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Available Balance",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Transaction History",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  
                  */
                ],
              ),
            )
          ]),
        ],
      ),
    );
  }

  SizedBox _buildPack2() {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 166,
              width: double.infinity,
              // child: ,
              decoration: BoxDecoration(
                  color: FarmToDishTheme.accentLightColor,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 155,
                    child: Text(
                      "Facilitating healthy food to dishes...",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: FarmToDishTheme.deepGreen,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  MaterialButton(
                    height: 35,
                    minWidth: 155,
                    onPressed: () {
                      context.go("/ProductScreen");
                    },
                    color: FarmToDishTheme.faintGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Order Now",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ]),
          Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              "${assets}shop.png",
              fit: BoxFit.fitHeight,
              width: MediaQuery.of(context).size.width * .4,
            ),
          ),
        ],
      ),
    );
  }

  Container _iconButtonWithBorder({IconData? iconData, Function()? func}) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: FarmToDishTheme.borderColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: IconButton(onPressed: () {}, icon: Icon(iconData)),
    );
  }
}
