import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Models/model_stack.dart';
import '../app_theme_file.dart';
import '../global_objects.dart';
import '../global_string.dart';
import '../global_widgets.dart';

class Navs extends StatefulWidget {
  final String essence;

  final String caption;

  Navs({super.key, required this.essence, required this.caption});

  @override
  State<StatefulWidget> createState() => _NavsState();
}

class _NavsState extends State<Navs> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Wrap(children: [
      Container(
          padding: const EdgeInsets.all(20),
          width: 290,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: FarmToDishTheme.scaffoldBackgroundColor),
          child: Column(children: [_fields(widget.essence, widget.caption)])),
    ]));
  }

  Container _fields(String essence, String caption) {
    switch (essence) {
      case psw_:
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            // color: FarmToDishTheme.accentLightColor,
          ),
          child: _pswSec(),
        );

      default:
        return Container();
    }
  }

  Column _pswSec() {
    //  List<String> set_ = [psw_, dlv_, ref_, shr_, tms_, cnt_];
    List<ProfileLog> fld = [
      ProfileLog(name: psw_0, essence: psw_0),
      ProfileLog(name: psw_1, essence: psw_1),
      ProfileLog(name: psw_2, essence: psw_2),
      ProfileLog(name: psw_3, essence: psw_3),
      ProfileLog(name: psw_4, essence: psw_4),
    ];
    /*

Version 1.0
    */
    return Column(
        children: fld.map((e) => ess(e.name, e.essence, context)).toList());
  }
}

class FundWallet extends StatefulWidget {
  const FundWallet({super.key});

  @override
  State<StatefulWidget> createState() => _FundWalletState();
}

class _FundWalletState extends State<FundWallet> {
  final TextEditingController _amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Wrap(children: [
      Container(
          padding: const EdgeInsets.all(20),
          width: 290,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: FarmToDishTheme.scaffoldBackgroundColor),
          child: Column(children: [
            Column(
              children: [
                const Center(
                  child: Text("Enter an Amount"),
                ),
                buildDivider(),
                const SizedBox(height: 20),
                Squire(
                  height: 40,
                  child: TextField(
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            bottom: 10, right: 10, left: 10),
                        border: InputBorder.none,
                        hintText: 'Amount',
                        hintStyle: FarmToDishTheme.iStyle
                        // label: Text('Email' ' :'),

                        ),
                    // label: 'Email' ' :',
                    // controller: ,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: MaterialButton(
                      height: 20,
                      minWidth: 100,
                      onPressed: () async {
                        if (_amount.text.isNotEmpty) {
                          amount = double.parse(_amount.text);
                          pay_ = {amt: amount};
                          context.go("/PaymentScreen");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              displaySnackBar("empty required field"));
                        }
                      },
                      color: FarmToDishTheme.faintGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: const Text(
                        "Pay",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )),
              ],
            )
          ])),
    ]));
  }
}
