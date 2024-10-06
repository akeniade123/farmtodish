// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings

// import 'dart:js_interop';

import 'dart:io';
import 'dart:math';
// import 'package:flutter/widgets.dart' as w;
// import 'package:Yomcoin/models/models.dart';
// import 'package:Yomcoin/screens/login.dart';
import 'package:farm_to_dish/Screens/DeliveryCar/delivery_car_model.dart';
import 'package:farm_to_dish/Screens/screens.dart';
import 'package:farm_to_dish/app_theme_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../../global_objects.dart';
import '../../global_widgets.dart';
// import '../screens.dart';
import 'cart_item_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItemModel> selectedProducts = currentOrder?.items ?? [];
  DeliveryCarModel? selectedDeliveryCar = currentOrder?.vehicle;
  @override
  void initState() {
    currentOrder ??= OrderModel(items: []);
    super.initState();
  }

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
                  // borderRadius: BorderRadius.circular(30),
                  color: FarmToDishTheme.scaffoldBackgroundColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SingleChildScrollView(
                    primary: true,
                    child: Column(
                      children: [
                        _buildDeliveryCarDisplay(),
                        SizedBox(height: 20),
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * .6,
                        //   child: ListView.separated(
                        //     primary: false,
                        //     itemBuilder: (context, index) => _buildCartSlab(
                        //         imageURL: "${assets}yams.png",
                        //         priceStatement: "${currency}300",
                        //         quantityStatement: " 5 tubers",
                        //         name: "Yams"),
                        //     separatorBuilder: (context, index) => SizedBox(
                        //       height: 10,
                        //     ),
                        //     itemCount: 6,
                        //   ),
                        // ),
                        // SizedBox(height: 20),
                        SizedBox(
                          // height: MediaQuery.of(context).size.height * .5,
                          child: SingleChildScrollView(
                            primary: false,
                            child: Column(
                                children: selectedProducts
                                    .map(
                                      (e) => Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: _buildCartSlab(
                                            imageURL: e.imageURL,
                                            priceStatement:
                                                e.getPriceStatment(),
                                            quantityStatement:
                                                e.getQuantityStatement(),
                                            name: e.name,
                                            model: e),
                                      ),
                                    )
                                    .toList()
                                // List.generate(selectedProducts.length, (index) =>   _buildCartSlab(
                                //     imageURL: selectedProducts[index],
                                //     priceStatement: "${currency}300",
                                //     quantityStatement: " 5 tubers",
                                //     name: "Yams"),
                                // )
                                //  [
                                // _buildCartSlab(
                                //     imageURL: "${assets}yams.png",
                                //     priceStatement: "${currency}300",
                                //     quantityStatement: " 5 tubers",
                                //     name: "Yams"),
                                //   SizedBox(height: 20),
                                //   _buildCartSlab(
                                //       imageURL: "${assets}yams.png",
                                //       priceStatement: "${currency}300",
                                //       quantityStatement: " 5 tubers",
                                //       name: "Yams"),
                                //   SizedBox(height: 20),
                                //   _buildCartSlab(
                                //       imageURL: "${assets}yams.png",
                                //       priceStatement: "${currency}300",
                                //       quantityStatement: " 5 tubers",
                                //       name: "Yams"),
                                //   SizedBox(height: 20),
                                //   _buildCartSlab(
                                //       imageURL: "${assets}yams.png",
                                //       priceStatement: "${currency}300",
                                //       quantityStatement: " 5 tubers",
                                //       name: "Yams"),
                                //   SizedBox(height: 20),
                                //   _buildCartSlab(
                                //       imageURL: "${assets}yams.png",
                                //       priceStatement: "${currency}300",
                                //       quantityStatement: " 5 tubers",
                                //       name: "Yams"),
                                //   SizedBox(height: 20),
                                // ],
                                ),
                          ),
                        ),
                        Visibility(
                          visible: currentOrder?.items.isNotEmpty ?? false,
                          replacement: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MaterialButton(
                                minWidth: 200,
                                height: 40,
                                onPressed: () {
                                  context.go("/ProductScreen");
                                },
                                child: Text(
                                  "Select Product",
                                  style: TextStyle(
                                      color: FarmToDishTheme
                                          .scaffoldBackgroundColor),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: FarmToDishTheme.faintGreen,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Price",
                                        style: TextStyle(
                                          // color: FarmToDishTheme
                                          //     .scaffoldBackgroundColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${currency}${currentOrder?.getTotalPrice() ?? 0}",
                                        style: TextStyle(
                                          // color: FarmToDishTheme
                                          //     .scaffoldBackgroundColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  MaterialButton(
                                    color: FarmToDishTheme.faintGreen,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    onPressed: () {
                                      context.go("/PaymentScreen");
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 5),
                                      child: Text(
                                        "Pay now",
                                        style: TextStyle(
                                          color: FarmToDishTheme
                                              .scaffoldBackgroundColor,
                                          // fontSize: 14,
                                          // fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        SizedBox(height: 70),
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

  Widget _buildDeliveryCarDisplay() {
    print("\$\$" * 120);
    print(selectedDeliveryCar);
    print("\$\$" * 120);
    return (selectedDeliveryCar == null)
        ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("No Delivery Selected"),
            MaterialButton(
              color: FarmToDishTheme.faintGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                // context.pop();
                context.goNamed("DeliveryCarScreen");
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Text(
                  "Add delivery pool",
                  style: TextStyle(
                    color: FarmToDishTheme.scaffoldBackgroundColor,
                    // fontSize: 14,
                    // fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ])
        : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text((selectedDeliveryCar?.name).toString()),
            MaterialButton(
              color: FarmToDishTheme.faintGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                context.goNamed("DeliveryCarScreen");
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Text(
                  "Change car",
                  style: TextStyle(
                    color: FarmToDishTheme.scaffoldBackgroundColor,
                    // fontSize: 14,
                    // fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ]);
  }

  Container _buildCartSlab({
    String? imageURL,
    String? quantityStatement,
    String? priceStatement,
    String? name,
    required CartItemModel model,
  }) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: FarmToDishTheme.accentLightColor,
        boxShadow: List.filled(
          4,
          FarmToDishTheme.genericBoxShadow,
        ),
      ),
      width: double.infinity,
      child: Row(mainAxisSize: MainAxisSize.max, children: [
        Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: FarmToDishTheme.accentLightColor,
            ),
            child: Image.asset(
              imageURL.toString(),
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.broken_image_outlined),
            )),
        SizedBox(width: 10),
        Expanded(
          // color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.toString(),
                style: TextStyle(
                  // color: FarmToDishTheme
                  //     .scaffoldBackgroundColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // SizedBox(height: 20),
              Text(
                quantityStatement.toString(),
                style: TextStyle(
                    // color: FarmToDishTheme
                    //     .scaffoldBackgroundColor,
                    // fontSize: 14,
                    // fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(height: 10),
              // gradientDivider
              Container(
                height: 1,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.transparent,
                  FarmToDishTheme.deepGreen,
                  Colors.transparent
                ])),
              ),
              // Divider(
              //   color: FarmToDishTheme.deepGreen
              //       .withOpacity(.5),
              //   height: 10,
              //   endIndent: 20,
              //   indent: 20,
              // ),SizedBox(width: 20),
              // SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        "Price : \n${priceStatement.toString()}",
                        style: TextStyle(
                            // color: FarmToDishTheme
                            //     .scaffoldBackgroundColor,
                            // fontSize: 14,
                            // fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // isAdded = !isAdded;
                        // widget.onClickExternalsFunction.call(isAdded);
                        currentOrder?.removeThis(model);
                        // OrderModel;
                        setState(() {});
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: FarmToDishTheme.themeRed,
                        ),
                        child: Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
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

  Widget _buildTopRow() {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          (context.canPop())
              ? IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: Icon(
                    Icons.chevron_left,
                    color: FarmToDishTheme.scaffoldBackgroundColor,
                  ),
                )
              : SizedBox(),
          Text(
            "Cart",
            style: TextStyle(
                color: FarmToDishTheme.scaffoldBackgroundColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            // color: FarmToDishTheme.accentLightColor,
            height: 26,
            width: 26,
            child: Stack(
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: FarmToDishTheme.scaffoldBackgroundColor,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 7,
                    backgroundColor: FarmToDishTheme.themeRed,
                    child: Text(
                      "1",
                      style: TextStyle(
                          color: FarmToDishTheme.scaffoldBackgroundColor,
                          fontSize: 10),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
