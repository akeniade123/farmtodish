// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:farm_to_dish/app_theme_file.dart';
import 'package:farm_to_dish/global_handlers.dart';
import 'package:farm_to_dish/global_objects.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:numpad_layout/numpad.dart';
import 'package:provider/provider.dart';

import '../Remote/modelstack.dart';
import '../Remote/requestmodel.dart';
import '../Remote/server_response.dart';
import '../Repository/databaseHelper.dart';
import '../global_string.dart';

import '../../global_objects.dart';
import '../global_widgets.dart';

class EnterPinDialog extends StatefulWidget {
  const EnterPinDialog({super.key});

  @override
  State<EnterPinDialog> createState() => _EnterPinDialogState();
}

class _EnterPinDialogState extends State<EnterPinDialog> {
  String number = '';
  String pin = '';
  bool payment = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: FarmToDishTheme.scaffoldBackgroundColor,
      ),
      // height: MediaQuery.of(context).size.height * 0.8,
      // width: MediaQuery.of(context).size.width * 0.8,

      //3360
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          /*
          Text(
            "Pay $currency${currentOrder?.getTotalPrice() ?? amount}",
            style: const TextStyle(
              // color: FarmToDishTheme.scaffoldBackgroundColor,
              fontSize: 16,
              // fontWeight: FontWeight.w500,
            ),
          ),
          */
          const SizedBox(height: 5),
          Material(
            color: FarmToDishTheme.scaffoldBackgroundColor,
            child: SizedBox(
              // height: 100,
              width: 300,
              child: NumPad(
                numberStyle: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.normal),
                runSpace: 0, mainAxisAlignment: MainAxisAlignment.center,
                paddingLet: const EdgeInsets.all(3),
                // color: FarmToDishTheme.scaffoldBackgroundColor,
                highlightColor: FarmToDishTheme.accentLightColor,
                arabicDigits: false,
                onType: (value) {
                  if (number.length <= 3) {
                    number += "*";
                    pin += value;
                    pnum = pin;
                    logger(pin);
                    setState(() {});
                  } else {
                    customSnackBar(context, "Max character exceeded");
                  }
                },
                rightWidget: IconButton(
                  icon: const Icon(Icons.backspace),
                  onPressed: () {
                    if (number.isNotEmpty) {
                      number = number.substring(0, number.length - 1);
                      pin = pin.substring(0, pin.length - 1);
                      setState(() {});
                    }
                  },
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: MaterialButton(
              height: 50,
              minWidth: 200,
              color: FarmToDishTheme.faintGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () async {
                payment = true;
                Navigate nvg = Navigate();
                //  Map<String, dynamic> mnf = {};

                Map<String, dynamic>? dtt = await nvg.entry(
                    NA, {}, {}, {}, global, chg, chg, true, NA, context);

                try {
                  if (dtt!["status"]) {
                    payment = false;
                    CustomResponse svv = CustomResponse.fromJson(dtt);
                    switch (svv.msg) {
                      /*
                      {
    "status": true,
    "data": {
        "reference": "3h4s4g5e6x21f1x",
        "status": "failed",
        "message": "Transaction declined. Please use the test card."
    },
    "message": "Transaction failed"
}
                      */

                      case "Transaction failed":
                        Map<String, dynamic> dty = svv.data;

                        customSnackBar(context, dty["message"]);

                        break;

                      case "Transaction Successful":
                        break;
                      default:
                        Map<String, dynamic> dtk =
                            svv.msg as Map<String, dynamic>;
                        String msgg = dtk["message"];
                        switch (msgg) {
                          case "Transaction Successful":
                            String msgg = "Transaction Successful";
                            try {
                              logger("Setup Procession");
                              String bllb = dtk["new balance"];

                              // Once Service starts running delete this section of cppt

                              DatabaseHelper dbm = DatabaseHelper(table: mnf);

                              int i = await dbm.queryRowCount();

                              if (i > 0) {
                                List<Map<String, dynamic>> dd =
                                    await dbm.queryAllRows();
                                Map<String, dynamic> ust = dd[0];
                                cppt = jsonDecode(ust[cpt]);
                              }

                              Map<String, dynamic> appSet = cppt;
                              appSet[appState] = linked;
                              appSet[indexed] = true;
                              appSet[acct] = bllb;

                              List<Map<String, dynamic>> ddf =
                                  await dbm.queryAllRows();

                              for (Map<String, dynamic> dd in ddf) {
                                dbm.delete(dd);
                              }

                              await dbm.insertData({cpt: jsonEncode(appSet)});

                              logger("Refactored: $appSet");

                              balance blh = balance(bal: dtk["new balance"]);

                              dshCtx.read<UINotifier>().accountBalance(blh);
                            } catch (e) {}

                            switch (pay_[stt]) {
                              case fnd:
                                Navigator.pop(context);
                                context.go("/HomeScreen");
                                break;
                              case stt:
                                break;
                            }

                            // ScaffoldMessenger.of()
                            snackbarKey.currentState?.showSnackBar(
                              SnackBar(
                                backgroundColor: FarmToDishTheme.deepGreen,
                                // onVisible: ,
                                content: const Text("Successful Transaction"),
                              ),
                            );

                            break;
                        }
                        break;
                    }

                    /*

                    List dts = svv.data;
                    for (int i = 0; i < dts.length; i++) {
                      Map<String, dynamic> dtk = dts[i];
                      // await dbh.insertData(dtk);
                    }
                    */
                    // await pref.setPrefBool(sct, true);
                    // dbh.insertData(row);
                    // log("$sct Accomplished");
                  }
                } catch (e) {
                  // log("error: $e");
                }

                //    await nvg.readData(produce, mnf, global, rd, "", false, rd, context);

                /*
                Navigator.pop(context);
                context.go("/HomeScreen");
                // ScaffoldMessenger.of()
                snackbarKey.currentState?.showSnackBar(
                  SnackBar(
                    backgroundColor: FarmToDishTheme.scaffoldBackgroundColor,
                    // onVisible: ,
                    content: const Text("your goods are on the way"),
                  ),
                );

                */
                // ScaffoldMessenger.of(snackbarKey.currentState!.context)
                // .showSnackBar(
                //     );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: (payment == false)
                    ? Text(
                        "Pay $currency $amount",
                        // "Pay $currency${currentOrder?.getTotalPrice() ?? amount}",
                        style: TextStyle(
                          color: FarmToDishTheme.scaffoldBackgroundColor,
                          // fontSize: 14,
                          // fontWeight: FontWeight.w500,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'Paying $currency${currentOrder?.getTotalPrice() ?? amount}'),
                          LoadingAnimationWidget.flickr(
                              size: 20,
                              leftDotColor: Colors.white,
                              rightDotColor: Colors.blue)
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
