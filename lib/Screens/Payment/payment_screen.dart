// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings

// import 'dart:js_interop';

// import 'package:flutter/widgets.dart' as w;
// import 'package:Yomcoin/models/models.dart';
// import 'package:Yomcoin/screens/login.dart';
import 'package:farm_to_dish/Dialogs/enter_pinDialog.dart';
import 'package:farm_to_dish/app_theme_file.dart';
import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';

import '../../global_objects.dart';
import '../../global_string.dart';
// import '../screens.dart';
// import 'cart_model.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController cdnumRetriever = TextEditingController();
  TextEditingController cvnumRetriever = TextEditingController();
  TextEditingController exnumRetriever = TextEditingController();

//var cdnum, cvnum, exnum, pnum;

  // List<CartModel> selectedProducts = [CartModel("")];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FarmToDishTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: Image.asset(
                "${assets}cardsBG.png",
              ).image,
              fit: BoxFit.cover,
            )),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
              height: 370,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: FarmToDishTheme.faintGreen),
                  color: FarmToDishTheme.scaffoldBackgroundColor),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Card Payments",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildCardNumberTexField(),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        _buildCVVTextfield(),
                        SizedBox(width: 20),
                        Expanded(
                          child: _buildExpDateTextfield(),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Card Owner",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Card Payments",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: MaterialButton(
                        height: 50,
                        minWidth: 200,
                        color: FarmToDishTheme.faintGreen,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          cdnum = cdnumRetriever.text;
                          cvnum = cvnumRetriever.text;
                          exnum = exnumRetriever.text;
                          Navigator.of(rootNavigatorKey
                                  .currentState!.overlay!.context)
                              .push(DialogRoute(
                            context: context,
                            builder: (context) =>
                                Dialog(child: EnterPinDialog()),
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          child: Text(
                            "Pay $currency${currentOrder?.getTotalPrice() ?? amount}",
                            style: TextStyle(
                              color: FarmToDishTheme.scaffoldBackgroundColor,
                              // fontSize: 14,
                              // fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // EnterPinDialog()
                  ]),
            )),
      ),
    );
  }

  Container _buildExpDateTextfield() {
    return Container(
      // color: FarmToDishTheme.deepGreen,
      decoration: BoxDecoration(
          color: FarmToDishTheme.accentLightColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: FarmToDishTheme.deepGreen,
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: exnumRetriever,
          decoration: InputDecoration(
            hintText: "Expiry Date",
            fillColor: FarmToDishTheme.deepGreen,
            border: InputBorder.none,
            // OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(10),
            //     borderSide: BorderSide(
            //         color: FarmToDishTheme.faintGreen,
            //         width: 100)
            //         ),
          ),
        ),
      ),
      height: 50,
    );
  }

  Container _buildCVVTextfield() {
    return Container(
      width: 115,
      // color: FarmToDishTheme.deepGreen,
      decoration: BoxDecoration(
          color: FarmToDishTheme.accentLightColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: FarmToDishTheme.deepGreen,
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: cvnumRetriever,
          decoration: InputDecoration(
              hintText: "CVV",
              fillColor: FarmToDishTheme.deepGreen,
              border: InputBorder.none
              // OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(10),
              //     borderSide: BorderSide(
              //         color: FarmToDishTheme.faintGreen,
              //         width: 100)
              //         ),
              ),
        ),
      ),
      height: 50,
    );
  }

  Container _buildCardNumberTexField() {
    return Container(
      // color: FarmToDishTheme.deepGreen,
      decoration: BoxDecoration(
          color: FarmToDishTheme.accentLightColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: FarmToDishTheme.deepGreen,
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: cdnumRetriever,
          decoration: InputDecoration(
              hintText: "Card Number",
              fillColor: FarmToDishTheme.deepGreen,
              border: InputBorder.none
              // OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(10),
              //     borderSide: BorderSide(
              //         color: FarmToDishTheme.faintGreen,
              //         width: 100)
              //         ),
              ),
        ),
      ),
      height: 50,
    );
  }
}
