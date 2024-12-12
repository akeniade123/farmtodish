import 'package:card_swiper/card_swiper.dart';
import 'package:farm_to_dish/app_theme_file.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import 'global_objects.dart';

class Squire extends StatefulWidget {
  final num? height;
  final num? width;
  final Widget? child;
  const Squire({super.key, this.height, this.width, this.child});

  @override
  State<Squire> createState() => _SquireState();
}

class _SquireState extends State<Squire> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: (widget.height?.toDouble() ?? 50.0),
        width: (widget.width?.toDouble() ?? double.infinity),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: FarmToDishTheme.accentLightColor,
          boxShadow: List.filled(4, FarmToDishTheme.genericBoxShadow
              // BoxShadow(
              //     blurRadius: 1,
              //     offset: Offset(2, 2),
              //     color: Colors.black.withAlpha(20)),
              ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: widget.child,
        ),
      ),
    );
  }
}

SnackBar displaySnackBar(String message) {
  return SnackBar(
    content: Text(message),
  );
}

void customSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(displaySnackBar(message));
}

@override
Modal(BuildContext context, double hth, Widget? entry) {
  dlg = context;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        dlg = context;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: SizedBox(
            height: hth,
            child: entry,
          ),
        );
      });
}

void customMessage(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: Text(title),
        content: Text(message),
      );
    },
  );
}

Consumer titled(String title) {
  return Consumer<UINotifier>(builder: (context, notifier, child) {
    return Text("");
  });
}

class TelephoneNumberWidget extends StatelessWidget {
  String? hintText;
  TextEditingController? controller;
  String? exportedNumber = '';
  Function(PhoneNumber)? onNumberChange;
  TelephoneNumberWidget(
      {super.key,
      required this.context,
      this.controller,
      this.hintText,
      this.onNumberChange,
      this.exportedNumber = ''});

  final BuildContext context;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PhoneNumber number = PhoneNumber(isoCode: 'NG');
    return InternationalPhoneNumberInput(
      searchBoxDecoration: const InputDecoration(
          constraints: BoxConstraints(maxHeight: 30),
          hintText: "hintText",
          contentPadding: EdgeInsets.all(0)),
      inputDecoration: InputDecoration(
        hintStyle: FarmToDishTheme.iStyle,
        hintText: hintText ?? '',
        // constraints:
        // BoxConstraints.tight(Size(double.maxFinite, double.minPositive)),
        border: InputBorder.none,
      ),
      onInputChanged: onNumberChange,
      onInputValidated: (bool value) {
        // avoid_print(value);
      },
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.DROPDOWN,
      ),
      ignoreBlank: false,
      hintText: hintText ?? '',
      autoValidateMode: AutovalidateMode.disabled,
      selectorTextStyle: const TextStyle(color: Colors.black),
      initialValue: number,
      textFieldController: controller ?? _controller,
      formatInput: true,
      keyboardType:
          const TextInputType.numberWithOptions(signed: true, decimal: true),
      inputBorder: const OutlineInputBorder(),
      onSaved: (PhoneNumber number) {
        // avoid_print('On Saved: $number');
      },
    );
  }
}

class TelePhone extends InternationalPhoneNumberInput {
  TelePhone({super.key, required super.onInputChanged});
}

class TitleMoreAndBodyWidget extends StatelessWidget {
  // String title;
  Widget titleWidget;

  void Function()? seeAllFunction;
  Widget body;

  // TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black);

  final bool? isSeeAll;
  // ignore: non_constant_identifier_names
  // Widget SeeAll=TextButton(onPressed: (){seeAllFunction()}, child: Text("see all"));

  TitleMoreAndBodyWidget({
    super.key,
    this.seeAllFunction,
    required this.body,
    this.isSeeAll,
    required this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle? style = Theme.of(context).textTheme.bodySmall;
    return Column(
      children: [
        Row(
          children: [
            // Text(title, style: style),
            titleWidget,
            const Expanded(child: SizedBox()),
            SeeAllOrNot(
                isSeeAll ?? false,
                TextButton(
                    onPressed: () {
                      // avoid_print(isSeeAll);
                      seeAllFunction?.call();
                    },
                    child: Text("see all", style: style))),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        body
      ],
    );
  }
}

class SeeAllOrNot extends StatelessWidget {
  bool isTrue;

  Widget wdgy;
  SeeAllOrNot(this.isTrue, this.wdgy, {super.key});

  @override
  Widget build(BuildContext context) {
    return (isTrue)
        ? wdgy
        : const SizedBox(
            height: 2,
            width: 2,
          );
  }
}

class ImageDisplayer extends StatefulWidget {
  final List<String> imageURLList;
  const ImageDisplayer({super.key, required this.imageURLList});

  @override
  State<ImageDisplayer> createState() => _ImageDisplayerState();
}

class _ImageDisplayerState extends State<ImageDisplayer> {
  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            // width: 00,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            clipBehavior: Clip.hardEdge,
            child: const Icon(
              Icons.image,
              size: 50,
            ),
            // Image.asset(
            //   "assets/foodDetail1.png",
            //   fit: BoxFit.fill,
            // ),
          ),
        );
      },
      itemCount: widget.imageURLList.length,
      outer: true,
      viewportFraction: 1,
      scale: 1,
      indicatorLayout: PageIndicatorLayout.SCALE,
      pagination: SwiperPagination(
        builder: DotSwiperPaginationBuilder(
            activeColor: FarmToDishTheme.deepGreen,
            color: FarmToDishTheme.accentLightColor),
      ),
      // const SwiperPagination(
      //     alignment: Alignment.bottomCenter,
      //     builder: SwiperPagination.dots,
      //     margin: EdgeInsets.all(0)),
      control: SwiperControl(
          color: FarmToDishTheme.faintGreen,
          iconNext: const IconData(0),
          iconPrevious: const IconData(0)

          // iconNext: Icons.arrow_circle_right,
          // iconPrevious: Icons.arrow_circle_left,
          ),
    );

    // CarouselSlider(
    //   options: CarouselOptions(height: 400.0),
    //   items: [1, 2, 3, 4, 5].map((i) {
    //     return Builder(
    //       builder: (BuildContext context) {
    //         return Container(
    //             width: MediaQuery.of(context).size.width,
    //             margin: const EdgeInsets.symmetric(horizontal: 5.0),
    //             decoration: const BoxDecoration(color: Colors.amber),
    //             child: Text(
    //               'text $i',
    //               style: const TextStyle(fontSize: 16.0),
    //             ));
    //       },
    //     );
    //   }).toList(),
    // );
  }
}

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> with TickerProviderStateMixin {
  // late FlutterGifController controller;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withAlpha(100),
      child: Stack(
        children: [
          Center(
              child: Image.asset(
            'assets/error_gif_2.gif',
          )),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Material(
                  child: IconButton(
                      onPressed: () {
                        // try {

                        // } catch (e) {

                        // }
                        Navigator.of(
                                rootNavigatorKey.currentState!.overlay!.context)
                            .pop();
                      },
                      icon: Icon(
                        Icons.close, color: Theme.of(context).primaryColorLight,
                        // weight: ,
                        size: 30,
                      ))),
            ),
          ),
        ],
      ),
    );
  }
}

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withAlpha(100),
      child: Center(child: Image.asset('assets/success_gif_2.gif')),
    );
  }
}

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withAlpha(100),
      child: Center(
          child: CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
      )),
    );
  }
}

// class Alert1 extends StatelessWidget {
//   // Offset? offset = Offset.fromDirection(180, 5);
//   bool fromLeft;

//   String? password = '';

//   // void Function(String)? textRecorder;
//   Alert1({this.password, super.key, this.fromLeft = false});

//   // final List<Widget> popUpList;

//   @override
//   Widget build(BuildContext context) {
//     return Animate(
//       effects: [
//         SlideEffect(begin: Offset.fromDirection((fromLeft) ? pi : 0, 5))
//       ],
//       child: AlertDialog(
//         shape: RoundedRectangleBorder(
//             side: BorderSide(color: Colors.black),
//             borderRadius: BorderRadius.circular(14)),
//         title: Align(alignment: Alignment.center, child: Text('Create Pin')),
//         // alignment: Alignment.center,
//         actionsAlignment: MainAxisAlignment.center,
//         content: FittedBox(
//           child: PopUpPinWidget(
//             textRecorder: (password) {
//               context.read<UserHandler>().storeMatchPin(password, true);
//             },
//           ),
//         ),
//         // contentPadding: const EdgeInsets.only(bottom: 0),
//         actions: [
//           Padding(
//               padding: const EdgeInsets.only(bottom: 16.0),
//               child: MaterialButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     Navigator.push(
//                         context,
//                         DialogRoute(
//                           context: context,
//                           builder: (context) => Animate(
//                             effects: [
//                               SlideEffect(
//                                   // duration: Duration(milliseconds: 1000),
//                                   begin: Offset.fromDirection(0, 5))
//                             ],
//                             child: Alert2(),
//                           ),
//                         ));
//                   },
//                   minWidth: 100,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(7)),
//                   color: Theme.of(context).primaryColor,
//                   child: Text('Create',
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodySmall
//                           ?.copyWith(color: Colors.white))))
//         ],
//       ),
//     );
//   }
// }

// class PopUpPinWidget extends StatefulWidget {
//   void Function(String)? textRecorder;

//   PopUpPinWidget({
//     super.key,
//     required this.textRecorder,
//   });

//   @override
//   State<PopUpPinWidget> createState() => _PopUpPinWidgetState();
// }

// class _PopUpPinWidgetState extends State<PopUpPinWidget> {
//   String text = '';
//   String realText = '';

//   _onKeyboardTap(String value) {
//     setState(() {
//       //TODO 3: RECORD THE VALUE
//       if ((text.length) < 6) {
//         text += '#';
//         realText += value;
//         widget.textRecorder!(realText);
//       }
//       ;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 240,
//       width: 200,
//       child: FittedBox(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               height: 80,
//               width: 280,
//               decoration: BoxDecoration(
//                   color: Colors.black.withAlpha(20),
//                   borderRadius: BorderRadius.circular(10)),
//               child: Center(
//                 child: Text(
//                   text,
//                   // textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             SizedBox(
//               // width: 320,
//               child: NumericKeyboard(
//                 textStyle: TextStyle(fontSize: 30),
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 onKeyboardTap: _onKeyboardTap,
//                 rightButtonFn: () {
//                   if (text.isEmpty) return;
//                   setState(() {
//                     text = text.substring(0, text.length - 1);
//                     realText = realText.substring(0, realText.length - 1);
//                     widget.textRecorder!(realText);
//                   });
//                 },
//                 rightButtonLongPressFn: () {
//                   if (text.isEmpty) return;
//                   setState(() {
//                     text = '';
//                     realText = '';
//                     widget.textRecorder!(realText);
//                   });
//                 },
//                 rightIcon: Icon(
//                   Icons.backspace,
//                   color: Theme.of(context).primaryColorLight,
//                 ),
//                 leftButtonFn: () {
//                   avoid_print('left button clicked');
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class DialogPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final WidgetBuilder builder;

  const DialogPage({
    required this.builder,
    this.anchorPoint,
    this.barrierColor = Colors.black87,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
        context: context,
        settings: this,
        builder: (context) => Dialog(
          child: builder(context),
        ),
        anchorPoint: anchorPoint,
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        themes: themes,
      );
}
