//import 'package:dropdown_search/dropdown_search.dart';
import 'dart:convert';
//import 'dart:html';

import 'package:farm_to_dish/Repository/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';

import '../Models/model_stack.dart';
import '../Remote/endpoints.dart';
import '../Remote/modelstack.dart';
import '../Remote/requester.dart';
import '../Remote/requestmodel.dart';
import '../Remote/server_response.dart';
import '../app_theme_file.dart';
import '../global_handlers.dart';
import '../global_objects.dart';
import '../global_string.dart';
import '../global_widgets.dart';

import 'package:qr_flutter/qr_flutter.dart';

import '../main.dart';

class ScanQrCode extends StatefulWidget {
  const ScanQrCode({super.key});

  @override
  State<ScanQrCode> createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: 290,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: FarmToDishTheme.scaffoldBackgroundColor),
            child: Center(
              child: QRCodeDartScanView(
                // onCameraError: (String error) {
                //   debugPrint('Error: $error');
                // },

                // cropRect: CropRect(left: 0, top: 0, width: 100, height: 100), // You can crop the image to improve accuracy by specifying a rectangle region. ( default = null)
                // imageDecodeOrientation: ImageDecodeOrientation.original, // you can force how the image orientation will be decoded (default = original)
                typeScan: TypeScan
                    .live, // if TypeScan.takePicture will try decode when click to take a picture(default TypeScan.live)
                // intervalScan: const Duration(seconds:1)
                // onResultInterceptor: (old,new){
                //  do any rule to controll onCapture.
                // }
                // takePictureButtonBuilder: (context,controller,isLoading){ // if typeScan == TypeScan.takePicture you can customize the button.
                //    if(loading) return CircularProgressIndicator();
                //    return ElevatedButton(
                //       onPressed:controller.takePictureAndDecode,
                //       child:Text('Take a picture'),
                //    );
                // }
                // resolutionPreset: = QrCodeDartScanResolutionPreset.high,
                // formats: [ // You can restrict specific formats.
                //  BarcodeFormat.qrCode,
                //  BarcodeFormat.aztec,
                //  BarcodeFormat.dataMatrix,
                //  BarcodeFormat.pdf417,
                //  BarcodeFormat.code39,
                //  BarcodeFormat.code93,
                //  BarcodeFormat.code128,
                //  BarcodeFormat.ean8,
                //  BarcodeFormat.ean13,
                // ],
                // croppingStrategy: CroppingStrategy.cropCenterSquare(
                //   squareSizeFactor: 0.7,
                // ),
                onCapture: (Result result) {
                  logger("Captured: ${result.text}");
                  // do anything with result
                  // result.text
                  // result.rawBytes
                  // result.resultPoints
                  // result.format
                  // result.numBits
                  // result.resultMetadata
                  // result.time
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QRImage extends StatelessWidget {
  const QRImage({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: 290,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: FarmToDishTheme.scaffoldBackgroundColor),
            child: Center(
              child: QrImageView(
                data: content,
                size: 280,
                // You can include embeddedImageStyle Property if you
                //wanna embed an image from your Asset folder
                embeddedImageStyle: const QrEmbeddedImageStyle(
                  size: Size(
                    100,
                    100,
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
      case dlv_:
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            // color: FarmToDishTheme.accentLightColor,
          ),
          child: _pswSec(essence),
        );

      //return

      default:
        return Container();
    }
  }

  Column _pswSec(String essence) {
    //  List<String> set_ = [psw_, dlv_, ref_, shr_, tms_, cnt_];

    List<ProfileLog> fld = [];
    switch (essence) {
      case psw_:
        fld = [
          ProfileLog(name: psw_0, essence: psw_0),
          //    ProfileLog(name: psw_1, essence: psw_1),
          //    ProfileLog(name: psw_2, essence: psw_2),
          //    ProfileLog(name: psw_3, essence: psw_3),
          //    ProfileLog(name: psw_4, essence: psw_4),
          ProfileLog(name: psw_5, essence: psw_5),
        ];
        break;
      case dlv_:
        fld = [
          ProfileLog(name: dlv_0, essence: dlv_0),
          //   ProfileLog(name: dlv_1, essence: dlv_1),
        ];
        break;
    }

    /*

Version 1.0
    */
    return Column(
        children: fld.map((e) => ess(e.name, e.essence, context)).toList());
  }
}

class LocateMe extends StatefulWidget {
  final String essence;

  const LocateMe({super.key, required this.essence});

  @override
  State<LocateMe> createState() => _LocateMeState();
}

class _LocateMeState extends State<LocateMe> {
  Future<Position>? pos;
  List<String> itemz = [];
  Map<String, dynamic> bkk = {};
  String location = "";
  String addr = "";
  String code = "";
  String accnm = "";
  final TextEditingController _account_nm = TextEditingController();

  @override
  void initState() {
    pos = null;
    drpz = dropDownlst(id: "id", array: []);
    lat = lng = "";
    pos = locator();
  }

  // final dropDownKey = GlobalKey<DropdownSearchState>();

  Future<Position>? locator() async {
    Navigate nvg = Navigate();
    Endpoint enp = Endpoint();

    logger("Where: ${widget.essence}");
    switch (widget.essence) {
      case csp:
        Map<String, dynamic>? obj = await getReq(
            enp.getEndpoint(trz, global, true), rqstElite, csp, context, true);
        //  await nvg.readData(NA, {}, global, trz, "content", false, rd);
        logger("Bank List: $obj");

        ServerPrelim? svp = ServerPrelim.fromJson(obj!); // as ServerPrelim?;
        if (svp.status) {
          ServerResponse svr = ServerResponse.fromJson(obj);
          for (dynamic d in svr.data) {
            try {
              setState(
                () {
                  itemz.add(d["name"]);
                  bkk[d["name"]] = d["code"];
                  // bkk.addEntries({d["name"]: d["code"]}
                  //   as Iterable<MapEntry<String, dynamic>>);
                  //  bkk.addEntries({d["name"]: d["code"]}.entries);
                  //bkk.addEntries(MapEntry(d["name"], d["code"]) as Iterable<MapEntry<String, dynamic>>);
                },
              );
            } catch (e) {}
          }
        }
        break;
      case mkt:
        List<String> nmm = [];
        Map<String, dynamic>? obj = await nvg.readData(
            mkt, {"lat": ""}, global, "access", "content", false, rd_e);
        logger("Response: $obj");

        ServerPrelim? svp = ServerPrelim.fromJson(obj!); // as ServerPrelim?;
        if (svp.status) {
          ServerResponse svr = ServerResponse.fromJson(obj);
          for (dynamic d in svr.data) {
            try {
              setState(() {
                //  gender = value ?? '';
                itemz.add(d["name"]);
              });
            } catch (e) {
              logger("Data Fetch error: $e");
            }
          }
        }

        logger("Total: ${nmm.length}");
        // itemz = nmm;
        logger('The Names: ${jsonEncode(itemz)}');
        break;
    }

    await getCurrentLocation();

    //  {"Essence":"market_segment", "State":"read_expl", "Manifest":{"lat":""}}

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint('location: ${position.latitude}');

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    logger("Hello: ${placemarks} -- ${placemarks.first}");

    switch (widget.essence) {
      case psw_5:
      case dlv_0:
        setState(() {
          addr =
              "Your Current Location depicts: ${placemarks.first.locality}, ${placemarks.first.subAdministrativeArea}, ${placemarks.first.administrativeArea}, ${placemarks.first.country} based on the coordinates of lat: ${position.latitude} & long: ${position.longitude}, further information will assists for efficient order deliveries, do well to ensure you're around the exact vicinity you expect your delivery before setting location ";
        });

        break;
      default:
        try {
          setState(() {
            addr =
                "Your Current Location depicts: ${placemarks.first.locality}, ${placemarks.first.subAdministrativeArea}, ${placemarks.first.administrativeArea}, ${placemarks.first.country} based on the coordinates of lat: ${position.latitude} & long: ${position.longitude} ";
          });
        } catch (e) {}
        break;
    }
    //  "Your Current Location depicts ${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.subAdministrativeArea}, ${placemarks.first.administrativeArea}, ${placemarks.first.country} based on the coordinates of lat: ${position.latitude} & long: ${position.longitude}, further information  assists with ";

    switch (widget.essence) {
      case mkt:
        dropDownlst drp_ = dropDownlst(id: "Locator", array: itemz);
        dshCtx.read<UINotifier>().dropDown(drp_);
        break;
      case csp:
        dropDownlst drp_ = dropDownlst(id: "Locator", array: itemz);
        dshCtx.read<UINotifier>().dropDown(drp_);
        break;
    }

    return position;

    /*

    getCurrentLocation().then((value) {
      lat = "${value.latitude}";
      lng = "${value.longitude}";
    });
    */

    //  pos = Position(longitude: lng, latitude: latitude, timestamp: timestamp, accuracy: accuracy, altitude: altitude, altitudeAccuracy: altitudeAccuracy, heading: heading, headingAccuracy: headingAccuracy, speed: speed, speedAccuracy: speedAccuracy)
  }

  Consumer lct_() {
    return Consumer<UINotifier>(builder: (context, notifier, child) {
      return Locator("Select Location", itemz); //07033280489
    });
  }

  Widget Locator(String desc, List<String> items_) {
    logger('The Names: ${jsonEncode(items_)}');

    Widget wdg = const Text("No View");

    String cta = "Share my location";

    switch (widget.essence) {
      case dlv_0:
        cta = "Update";
        break;
      case csp:
        cta = "Apply";
        break;
    }

    switch (widget.essence) {
      case csp:
      case psw_5:
      case dlv_0:
        wdg = Center(
          child: Column(
            children: [
              Text(" $addr"),
              Squire(
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          bottom: 10, right: 10, left: 10),
                      border: InputBorder.none,
                      hintText: 'Address ' ' :',
                      hintStyle: FarmToDishTheme.iStyle
                      // label: Text('Email' ' :'),

                      ),
                  // label: 'Email' ' :',
                  // controller: ,
                  controller: _address,
                ),
              ),
              //  (widget.essence == psw_5) ? const Text("") : Text(""),

              (widget.essence == csp)
                  ? Wrap(
                      children: [
                        Column(
                          children: [
                            Autocomplete<String>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                }
                                return items_.where((String option) {
                                  return option.contains(
                                      textEditingValue.text.toLowerCase());
                                });
                              },
                              onSelected: (String selection) {
                                logger("Bank_Chosen: $selection");
                                logger("Bank_Code: ${bkk[selection]}");
                                code = bkk[selection];

                                setState(() {
                                  accnm = "";
                                });
                                // debugPrint('You just selected $selection');
                              },
                              // Customize fieldViewBuilder and optionsViewBuilder as needed
                            ),
                            Squire(
                              height: 40,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 10, right: 10, left: 10),
                                    border: InputBorder.none,
                                    hintText: 'Account Number ' ' :',
                                    hintStyle: FarmToDishTheme.iStyle
                                    // label: Text('Email' ' :'),

                                    ),
                                // label: 'Email' ' :',
                                // controller: ,
                                controller: _account_nm,
                                onChanged: (value) async {
                                  try {
                                    setState(() {
                                      accnm = "";
                                    });

                                    if (value.length >= 10 && code.isNotEmpty) {
                                      showLoaderDialog(context);
                                      Map<String, String> mnf_ = {
                                        "Account_no": value,
                                        "Bank_code": code,
                                        "Essence": "Account_no",
                                        "regId": "lkmlkmflkmlfkmf"
                                      };
                                      nvg = Navigate();
                                      Map<String, dynamic>? obj =
                                          await nvg.entry(
                                              mkt,
                                              mnf_,
                                              {},
                                              {},
                                              global,
                                              cssp,
                                              jsonEncode(mnf_),
                                              false,
                                              upd_,
                                              context);

                                      try {
                                        ServerPrelim svr =
                                            ServerPrelim.fromJson(obj!);
                                        Navigator.pop(context);
                                        try {
                                          ServerResponse svg =
                                              ServerResponse.fromJson(obj);
                                          if (svg.data.isNotEmpty) {
                                            setState(() {
                                              accnm =
                                                  svg.data[0]["account_name"];
                                            });
                                            // _account_nm.text = accnm;
                                          }
                                        } catch (e) {}
                                        customSnackBar(
                                            context, svr.msg.toString());
                                      } catch (e) {}
                                    }
                                  } catch (e) {}
                                },
                              ),
                            ),
                            //(accnm.isNotEmpty) ? Text(accnm) : const Spacer()
                          ],
                        ),
                        (accnm.isNotEmpty) ? Text(accnm) : const Spacer()
                      ],
                    )
                  : const Text(""),

              (addr.isEmpty)
                  ? const Text("")
                  : MaterialButton(
                      height: 30,
                      minWidth: 100,
                      color: FarmToDishTheme.faintGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        cta,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      onPressed: () async {
                        if (lat != "") {
                          switch (widget.essence) {
                            case dlv_0:
                              DatabaseHelper dhl = DatabaseHelper(table: plz);
                              //  plcCln
                              Map<String, dynamic> dd = {
                                lat_: lat,
                                lng_: lng,
                                loc_: _address.text
                              };
                              await dhl.insertData(dd);
                              break;
                            case csp:
                              DatabaseHelper dbm = DatabaseHelper(table: mnf);
                              List<Map<String, dynamic>> dd =
                                  await dbm.queryAllRows();
                              Map<String, dynamic> ust = dd[0];
                              cppt = jsonDecode(ust[cpt]);

                              // logger("Data Deserialization: $cppt");

                              try {
                                logger("App State: ${cppt[appState]}");
                                // app = cppt[appState];
                                Map<String, dynamic> prf = cppt[usrTbl];
                                if (prf.isNotEmpty) {
                                  String unq_ = prf[unq];

                                  Map<String, dynamic> mnf_ = {
                                    "user": unq_,
                                    "lat": lat,
                                    "lng": lng,
                                    "address": _address.text,
                                    "status": "1"
                                  };

                                  Map<String, dynamic>? obj = await nvg.entry(
                                      "salespoint",
                                      mnf_,
                                      {},
                                      {},
                                      global,
                                      "access",
                                      "content",
                                      false,
                                      "create",
                                      context);

                                  try {
                                    ServerPrelim svr =
                                        ServerPrelim.fromJson(obj!);
                                    customSnackBar(context, svr.msg.toString());
                                  } catch (e) {}
                                }
                              } catch (e) {
                                //catch
                              }

                              break;
                          }
                        } else {
                          customSnackBar(context,
                              "yet to obtain your co-ordinate, please wait...");
                        }
                      }),
            ],
          ),
        );
        break;
      case mkt:
        wdg = Center(
          child: Column(
            children: [
              DropdownButtonFormField(
                hint: Text(
                  desc,
                  style: FarmToDishTheme.iStyle,
                ),
                isExpanded: false,
                icon: Expanded(
                  child: Center(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Icon(Icons.keyboard_arrow_down, size: 20),
                    ),
                  ),
                ),
                alignment: Alignment.center,
                decoration: InputDecoration(border: InputBorder.none),
                items: drpz.array.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),

                // [
                //   DropdownMenuItem<String>(
                //     child: Text('Male', style: FarmToDishTheme.iStyle),
                //     value: 'Male',
                //   ),
                //   DropdownMenuItem<String>(
                //     child: Text('Female', style: FarmToDishTheme.iStyle),
                //     value: 'Female',
                //   )
                // ],
                onChanged: (value) {
                  setState(() {
                    int loc = drpz.array.indexOf(value!);
                    location = drpz.array[loc];
                    logger("The Current: $location");
                  });
                },
              ),
              MaterialButton(
                height: 30,
                minWidth: 100,
                onPressed: () async {
                  lat = lng = "";
                  pos = await getCurrentLocation().then((value) {
                    lat = "${value.latitude}";
                    lng = "${value.longitude}";
                  });

                  Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  debugPrint('location: ${position.latitude}');

                  List<Placemark> placemarks = await placemarkFromCoordinates(
                      position.latitude, position.longitude);
                  logger("Hello: ${placemarks} -- ${placemarks.first}");

                  /*
              final coordinates =
                  Coordinates(position.latitude, position.longitude);
              var addresses = await Geocoder.local
                  .findAddressesFromCoordinates(coordinates);
              var first = addresses.first;
              print("${first.featureName} : ${first.addressLine}");

              */

                  logger("The exact location: $location -- $lat -- $lng");
                  if (lat != "") {
                    Navigate nvg = Navigate();

                    Map<String, dynamic> mnf = {"name": location};
                    Map<String, dynamic> ent = {
                      "lat": lat,
                      "lng": lng,
                      "location": jsonEncode(placemarks.first)
                    };

                    Map<String, dynamic>? obj = await nvg.entry(mkt, mnf, ent,
                        mnf, global, "access", "content", false, upd_, context);

                    try {
                      ServerPrelim svr = ServerPrelim.fromJson(obj!);
                      customSnackBar(context, svr.msg.toString());
                    } catch (e) {}
                  }
                },
                color: FarmToDishTheme.faintGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: const Text(
                  "Tag Location",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        );
    }

    return wdg;
  }

  final TextEditingController _address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            width: 290,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: FarmToDishTheme.scaffoldBackgroundColor),
            child: Column(
              children: [
                (pos == null)
                    ? const Text("Searching for your location")
                    : lct_()
              ],
            ),
          ),
        ],
      ),
    );
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
                          pay_ = {amt: amount, stt: fnd};
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
