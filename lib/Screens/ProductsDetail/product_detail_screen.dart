// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings

// import 'dart:js_interop';

// import 'package:flutter/widgets.dart' as w;
// import 'package:Yomcoin/models/models.dart';
// import 'package:Yomcoin/screens/login.dart';
import 'package:farm_to_dish/app_theme_file.dart';
import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';

import '../../global_objects.dart';
import '../../global_widgets.dart';
import '../screens.dart';
// import 'product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // List<ProductModel> selectedProducts = [ProductModel()];
  List<String> imageURLList = [
    "${assets}fruitVeggie.png",
    "${assets}grains.png",
    "${assets}pepper.png",
    "${assets}tubbers.png",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FarmToDishTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(children: [
                SizedBox(
                    height: 300,
                    child: ImageDisplayer(imageURLList: imageURLList)),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                              // color:
                              // FarmToDishTheme.scaffoldBackgroundColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          "Yams",
                          style: TextStyle(
                              // color:
                              // FarmToDishTheme.scaffoldBackgroundColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Price",
                          style: TextStyle(
                              // color:
                              // FarmToDishTheme.scaffoldBackgroundColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          "${currency}2000",
                          style: TextStyle(
                              // color:
                              // FarmToDishTheme.scaffoldBackgroundColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "rating",
                          style: TextStyle(
                              // color:
                              // FarmToDishTheme.scaffoldBackgroundColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          "⭐️ 4.8",
                          style: TextStyle(
                              // color:
                              // FarmToDishTheme.scaffoldBackgroundColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      "Descriptions",
                      style: TextStyle(
                          // color:
                          // FarmToDishTheme.scaffoldBackgroundColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "This is a delicious delicacy good for everyone, contains protein, carbohydrate, vitamins and other  nutritional supplements needed for your heath.",
                      style: TextStyle(
                          // color:
                          // FarmToDishTheme.scaffoldBackgroundColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 80)
                  ],
                )
              ]),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: MaterialButton(
                color: FarmToDishTheme.faintGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {},
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: Text(
                    "Add To Cart",
                    style: TextStyle(
                      color: FarmToDishTheme.scaffoldBackgroundColor,
                      // fontSize: 14,
                      // fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            // color: FarmToDishTheme.deepGreen,
            child: _buildTopRow(),
            // height: double.infinity,
            // width: double.infinity,
            alignment: Alignment.topCenter,
          ),
        ]),
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
          CircleAvatar(
            backgroundColor: FarmToDishTheme.accentLightColor,
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.chevron_left,
                color: FarmToDishTheme.faintGreen,
              ),
            ),
          ),
          // Text(
          //   "Products",
          //   style: TextStyle(
          //       // color: FarmToDishTheme.scaffoldBackgroundColor,
          //       fontSize: 20,
          //       fontWeight: FontWeight.bold),
          // ),
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
}
