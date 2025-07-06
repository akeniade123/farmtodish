import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app_theme_file.dart';
import '../global_objects.dart';
import '../global_string.dart';
import '../global_widgets.dart';

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
        child: Container(
            padding: const EdgeInsets.all(20),
            height: 340,
            width: 290,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: FarmToDishTheme.scaffoldBackgroundColor),
            child: Column(children: [
              Column(
                children: [
                  const Center(
                    child: Text("Enter an Amount"),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  TextField(
                    controller: _amount,
                    decoration: const InputDecoration(
                        hintText: 'Amount',
                        helperText: "Amount must be in digits",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 249, 249, 249))),
                        filled: true,
                        fillColor: Color.fromARGB(255, 249, 249, 249)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: MaterialButton(
                        height: 20,
                        minWidth: 100,
                        onPressed: () async {
                          if (_amount.text.isNotEmpty) {
                            amount = int.parse(_amount.text);
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
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )),
                ],
              )
            ])));
  }
}
