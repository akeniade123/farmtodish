import 'package:farm_to_dish/app_theme_file.dart';
import 'package:farm_to_dish/global_objects.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:numpad_layout/numpad.dart';

import '../Remote/requestmodel.dart';
import '../global_string.dart';

class EnterPinDialog extends StatefulWidget {
  const EnterPinDialog({super.key});

  @override
  State<EnterPinDialog> createState() => _EnterPinDialogState();
}

class _EnterPinDialogState extends State<EnterPinDialog> {
  String number = '';
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Pay N5,000",
            style: TextStyle(
              // color: FarmToDishTheme.scaffoldBackgroundColor,
              fontSize: 16,
              // fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 40),
          Material(
            color: FarmToDishTheme.scaffoldBackgroundColor,
            child: SizedBox(
              // height: 100,
              width: 300,
              child: NumPad(
                numberStyle: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.normal),
                runSpace: 0, mainAxisAlignment: MainAxisAlignment.center,
                paddingLet: const EdgeInsets.all(8),
                // color: FarmToDishTheme.scaffoldBackgroundColor,
                highlightColor: FarmToDishTheme.accentLightColor,
                arabicDigits: false,
                onType: (value) {
                  number += value;
                  setState(() {});
                },
                rightWidget: IconButton(
                  icon: const Icon(Icons.backspace),
                  onPressed: () {
                    if (number.isNotEmpty) {
                      number = number.substring(0, number.length - 1);
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
                Navigate nvg = Navigate();
                Map<String, dynamic> mnf = {};

                Map<String, dynamic>? obj = await nvg.entry(
                    NA, {}, {}, {}, global, chg, chg, true, NA, context);
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
                child: Text(
                  "Pay N5,000",
                  style: TextStyle(
                    color: FarmToDishTheme.scaffoldBackgroundColor,
                    // fontSize: 14,
                    // fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
