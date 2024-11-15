// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings

// import 'dart:js_interop';

// import 'package:flutter/widgets.dart' as w;
// import 'package:Yomcoin/models/models.dart';
// import 'package:Yomcoin/screens/login.dart';
import 'package:farm_to_dish/Screens/DeliveryCar/delivery_car_model.dart';
import 'package:farm_to_dish/app_theme_file.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:sqflite/sqflite.dart';

import '../../global_objects.dart';
import '../../global_widgets.dart';
import '../screens.dart';
// import 'product_model.dart';

class DeliveryCarScreen extends StatefulWidget {
  const DeliveryCarScreen({super.key});

  @override
  State<DeliveryCarScreen> createState() => _DeliveryCarScreenState();
}

class _DeliveryCarScreenState extends State<DeliveryCarScreen> {
  // List<ProductModel> selectedProducts = [ProductModel()];
  List<String> imageURLList = [
    "${assets}fruitVeggie.png",
    "${assets}grains.png",
    "${assets}pepper.png",
    "${assets}tubbers.png",
  ];
  List<DeliveryCarModel> deliveryCarList = [
    DeliveryCarModel(),
    DeliveryCarModel(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FarmToDishTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: FarmToDishTheme.deepGreen,
              child: _buildTopRow(),
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.topCenter,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: FarmToDishTheme.scaffoldBackgroundColor,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        _buildSearchBar(),
                        SizedBox(height: 20),
                        Wrap(
                            children: deliveryCarList
                                .map((e) => _buildDeliveryPoolCard(e))
                                .toList()
                            // List.filled(
                            //     12,
                            //     Padding(
                            //       padding: const EdgeInsets.all(5.0),
                            //       child: _buildDeliveryPoolCard(),
                            //     ),),
                            ),
                        // SizedBox(

                        //   height: MediaQuery.of(context).size.height * 0.7,
                        //   child: GridView.builder(
                        //     gridDelegate:
                        //         SliverGridDelegateWithFixedCrossAxisCount(
                        //             crossAxisSpacing: 10,
                        //             mainAxisSpacing: 10,
                        //             crossAxisCount: 2),
                        //     itemBuilder: (context, index) =>
                        //         _buildDeliveryPoolCard(),
                        //     itemCount: 12,
                        //   ),
                        // ),

                        SizedBox(height: 80)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 185,
          width: 140,
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
      ),
    );
  }

  TitleMoreAndBodyWidget _buildSelectorTab() {
    return TitleMoreAndBodyWidget(
        body: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SelectionChip(
            name: "fruits And Vegie",
            imageURL: "${assets}fruitVeggie.png",
            onClickFunction: (p0) {
              setState(() {});
            },
          ),
          SelectionChip(
            name: "fruits And Vegie",
            imageURL: "${assets}fruitVeggie.png",
            onClickFunction: (p0) {
              setState(() {});
            },
          ),
          SelectionChip(
            name: "fruits And Vegie",
            imageURL: "${assets}fruitVeggie.png",
            onClickFunction: (p0) {
              setState(() {});
            },
          ),
        ]),
        titleWidget: Text(
          "Categories",
          style: TextStyle(
              // color:
              // FarmToDishTheme.scaffoldBackgroundColor,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ));
  }

  Widget _buildTopRow() {
    return Container(
      padding: EdgeInsets.all(12),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          (Navigator.of(context).canPop())
              ? CircleAvatar(
                  backgroundColor: FarmToDishTheme.accentLightColor,
                  child: IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(
                      Icons.chevron_left,
                      color: FarmToDishTheme.faintGreen,
                    ),
                  ),
                )
              : SizedBox(),
          Expanded(
            child: Text(
              "Delivery Pools",
              style: TextStyle(
                  color: FarmToDishTheme.scaffoldBackgroundColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          // SizedBox(
          //   // color: FarmToDishTheme.accentLightColor,
          //   height: 26,
          //   width: 26,
          //   child: Stack(
          //     children: [
          //       Icon(
          //         Icons.shopping_cart,
          //         color: FarmToDishTheme.scaffoldBackgroundColor,
          //       ),
          //       Align(
          //         alignment: Alignment.bottomRight,
          //         child: CircleAvatar(
          //           radius: 7,
          //           backgroundColor: FarmToDishTheme.themeRed,
          //           child: Text(
          //             "1",
          //             style: TextStyle(
          //                 color: FarmToDishTheme.scaffoldBackgroundColor,
          //                 fontSize: 10),
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  Container _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: FarmToDishTheme.deepGreen,
      ),
      height: 50,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(children: [
        Icon(
          Icons.search,
          color: FarmToDishTheme.scaffoldBackgroundColor,
        ),
        SizedBox(width: 10),
        Expanded(
            child: SizedBox(
                // height: 50,
                child: TextField(
          style: TextStyle(
            color: FarmToDishTheme.scaffoldBackgroundColor,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search Products .....",
            hintStyle: TextStyle(
              color: FarmToDishTheme.scaffoldBackgroundColor,
              // fontSize: 14,
              // fontWeight: FontWeight.w500,
            ),
          ),
        ))),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: FarmToDishTheme.scaffoldBackgroundColor,
          ),
          height: 37,
          width: 37,
          child: Icon(Icons.tune_rounded),
        )
      ]),
    );
  }
}
