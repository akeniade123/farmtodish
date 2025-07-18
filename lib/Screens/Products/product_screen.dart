// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings

// import 'dart:js_interop';
import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:farm_to_dish/Screens/screens.dart';
import 'package:farm_to_dish/app_theme_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
// import 'package:sqflite/sqflite.dart';

import '../../Repository/databaseHelper.dart';
import '../../Dialogs/dialog_to_adding_products.dart';
import '../../Remote/requestmodel.dart';
import '../../Remote/server_response.dart';
import '../../env.dart';
import '../../global_handlers.dart';
import '../../global_objects.dart';
import '../../global_string.dart';
import '../../global_widgets.dart';
import '../Cart/cart_item_model.dart';
// import '../Payment/cart_model.dart';
import 'product_model.dart';

class ProductScreen extends StatefulWidget {
  String? initialySelectedTab;
  ProductScreen({super.key, this.initialySelectedTab = ""});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  DatabaseHelper dbh = DatabaseHelper(table: ptyp);

  DatabaseHelper dbp = DatabaseHelper(table: produce);
  static final customCacheManager = CacheManager(Config('customCacheKey',
      stalePeriod: const Duration(days: 15), maxNrOfCacheObjects: 100));

  late Future<List<ProduceType>>? prSect;
  late Future<List<Widget>>? schip;

  late Future<List<ProductModel>>? pmdl;

  late Future<List<String>>? lst; // = [];

  late Future<int>? cart;
  late int cartz;

  // List<CartItemModel> selectedProducts = [];
  @override
  void initState() {
    // TODO: implement initState
    // selectedProducts = currentOrder?.items ?? [];
    currentOrder ??= OrderModel(items: []);
    selectedTabName = widget.initialySelectedTab ?? "";
    logger("Entity    : $selectedTabName");

    super.initState();
    // prSect = produceSect();
    // schip = _produceSect();

    pmdl = _produceStack();
    cart = _cart();
    cartz = 0;
    // lst = __produceSect();
    // bdw = _bodyWidget();
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
                  borderRadius: BorderRadius.circular(30),
                  color: FarmToDishTheme.scaffoldBackgroundColor,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        // _buildSearchBar(),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            /*
                            (schip == null) ? _buildSelectorTab() : stackData(),
                            SizedBox(height: 20),
                            */
                            (pmdl == null) ? preload() : loadProduct(),
                          ],
                        ),
                        SizedBox(height: 80)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 80, left: 20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Visibility(
                  visible: currentOrder!.items.isNotEmpty,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: FarmToDishTheme.faintGreen,
                    ),
                    child: IconButton(
                      onPressed: () {
                        context.goNamed("CartScreen");
                        // Navigator.of(rootNavigatorKey.currentState!.context)
                        //     .push(MaterialPageRoute(
                        //   builder: (context) => CartScreen(),
                        // ));
                      },
                      icon: Icon(
                        Icons.shopping_cart_checkout,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String selectedTabName = "";

  Column _buildProductTab(
      {String? quantity,
      required String pname,
      String? priceStatement,
      String? imageURL,
      required ProductModel model,
      required CartItemModel? cartModel}) {
    return Column(
      children: [
        SizedBox(
          height: 145,
          width: double.infinity,
          child: Stack(alignment: Alignment.bottomCenter, children: [
            Container(
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: FarmToDishTheme.accentLightColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        // color: Colors.white,
                      ),
                      // child: Image.asset(
                      //     "${assets}tubbers.png"),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          pname.toString(),
                          style: TextStyle(
                              // color:
                              // FarmToDishTheme.scaffoldBackgroundColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          priceStatement.toString(),
                          style: TextStyle(
                              // color:
                              // FarmToDishTheme.scaffoldBackgroundColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          quantity.toString(),
                          style: TextStyle(
                              // color:
                              // FarmToDishTheme.scaffoldBackgroundColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Expanded(child: SizedBox()),
                    Align(
                      alignment: Alignment.center,
                      child: AddORRemoveProductButton(
                        onClickExternalFunction: (add) async {
                          if (add) {
                            cartModel = await showDialog<CartItemModel?>(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => DialogToAddingProducts(
                                productModel: ProductModel(
                                    quantity: 12, price: 1200, name: pname),
                                model: cartModel,
                                // CartModel("dbcj", quantity: 0, price: 1200),
                              ),
                            );
                            ((cartModel != null)
                                ? () {
                                    print("##" * 220);
                                    // selectedProducts.add(cartModel!);
                                    currentOrder?.addThis(cartModel!);
                                    //  balance blh = balance(bal: bal);
                                    //bll = blh;
                                    dshCtx
                                        .read<UINotifier>()
                                        .orderNotice(currentOrder!);

                                    print(currentOrder?.items);
                                    print("##" * 220);
                                  }.call()
                                : "do nothing");
                          } else {
                            print("####" * 120);

                            // selectedProducts.remove(cartModel);
                            currentOrder?.items.remove(cartModel);
                            dshCtx
                                .read<UINotifier>()
                                .orderNotice(currentOrder!);

                            // selectedProducts = currentOrder?.items ?? [];
                            print("####" * 120);

                            // selectedProducts.removeWhere((element) {
                            //   print("object");
                            //   print("element id >>> ${element.id}");
                            //   print("cartModel id >>> ${cartModel?.id}");

                            //   print(element.id == (cartModel)?.id);
                            //   return element.id == (cartModel)?.id;
                            // });
                          }
                          // print(selectedProducts);
                          print(cartModel);
                          print(add);

                          setState(() {});

                          return cartModel != null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  // error image
                  child: Image.asset(
                    imageURL ?? "",
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
          ]),
        )
      ],
    );
  }

  Column _productTab(
      {String? quantity,
      required String pname,
      String? priceStatement,
      String? imageURL,
      required ProductModel model,
      required CartItemModel? cartModel}) {
    return Column(
      children: [
        SizedBox(
          height: 145,
          width: double.infinity,
          child: Stack(alignment: Alignment.bottomCenter, children: [
            Container(
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: FarmToDishTheme.accentLightColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      // height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        // color: Colors.white,
                      ),
                      // child: Image.asset(
                      //     "${assets}tubbers.png"),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        (pname.length > 10)
                            ? Container(
                                width: 100,
                                child: FittedBox(
                                  // TRY THIS: Try changing the fit types to see how they change the way
                                  // the placeholder fits into the container.
                                  fit: BoxFit.fill,
                                  child: Text(
                                    pname,
                                    style: TextStyle(
                                        // color:
                                        // FarmToDishTheme.scaffoldBackgroundColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : Text(pname,
                                style: TextStyle(
                                    // color:
                                    // FarmToDishTheme.scaffoldBackgroundColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                        Text(
                          priceStatement.toString(),
                          style: TextStyle(
                              // color:
                              // FarmToDishTheme.scaffoldBackgroundColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        // Text(
                        //   quantity.toString(),
                        //   style: TextStyle(
                        //       // color:
                        //       // FarmToDishTheme.scaffoldBackgroundColor,
                        //       fontSize: 10,
                        //       fontWeight: FontWeight.w400),
                        // ),
                      ],
                    ),
                    Expanded(child: SizedBox()),
                    Align(
                      alignment: Alignment.center,
                      child: AddORRemoveProductButton(
                        onClickExternalFunction: (add) async {
                          if (add) {
                            cartModel = await showDialog<CartItemModel?>(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => DialogToAddingProducts(
                                productModel: model,
                                model: cartModel,
                                // CartModel("dbcj", quantity: 0, price: 1200),
                              ),
                            );
                            ((cartModel != null)
                                ? () {
                                    print("##" * 220);
                                    // selectedProducts.add(cartModel!);
                                    currentOrder?.addThis(cartModel!);
                                    print(currentOrder?.items);
                                    print("##" * 220);
                                  }.call()
                                : "do nothing");
                          } else {
                            print("####" * 120);

                            // selectedProducts.remove(cartModel);
                            currentOrder?.items.remove(cartModel);

                            // selectedProducts = currentOrder?.items ?? [];
                            print("####" * 120);

                            // selectedProducts.removeWhere((element) {
                            //   print("object");
                            //   print("element id >>> ${element.id}");
                            //   print("cartModel id >>> ${cartModel?.id}");

                            //   print(element.id == (cartModel)?.id);
                            //   return element.id == (cartModel)?.id;
                            // });
                          }
                          // print(selectedProducts);
                          print(cartModel);
                          print(add);

                          try {
                            cartstatus != cartstatus;
                            dshCtx
                                .read<UINotifier>()
                                .orderNotice(currentOrder!);
                            setState(() {});
                          } catch (e) {}

                          return cartModel != null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: FarmToDishTheme.scaffoldBackgroundColor,
                    ),
                    // error image

                    /*
                  ClipRRect(
                    borderRadius: BorderRadius.circular(120),
                    child: Image.network(
                      'https://picsum.photos/seed/picsum/200/300',
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                    ),
                  )
                  */

                    child: Card(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      elevation: 5,
                      child: CachedNetworkImage(
                        cacheManager: customCacheManager,
                        progressIndicatorBuilder: (context, url, progress) =>
                            Center(
                          child: CircularProgressIndicator(
                            color: FarmToDishTheme.accentLightColor,
                            value: progress.progress,
                          ),
                        ),
                        key: UniqueKey(),
                        imageUrl: imageURL!,
                        errorWidget: (context, url, error) =>
                            Icon(Icons.broken_image),
                      ),

                      //  child: Image.network(
                      //   imageURL ?? "",
                      //   errorBuilder: (context, error, stackTrace) =>
                      //       Icon(Icons.broken_image),
                      //   fit: BoxFit.cover,
                      // ),
                    )),
              ),
            ),
          ]),
        )
      ],
    );
  }

  late Navigate nvg;

  Future<List<ProductModel>>? _produceStack() async {
    List<ProductModel> rslt = [];
    int ptt = await dbp.queryRowCount();
    List<Map<String, dynamic>> dd = [];
    logger("Size $ptt");
    if (ptt > 0) {
      List<Map<String, dynamic>> fm = await dbp.queryAllRows();
      for (Map<String, dynamic> itmm in fm) {
        logger("item${itmm[typ]}");
        try {
          rslt.add(ProductModel(
              name: itmm[itm],
              imageURL: itmm[img], // "${assets}goat_meat.png",
              price: itmm[prz],
              quantity: 12,
              unit: "kilo"));

          /*

           "id": "1",
            "item": "Red Cherry Tomato",
            "type": "1",
            "created": "2024-06-08 18:32:54",
            "image": "https://www.farmtodish.com/app/farm%20produce/Red_Cherry%20Tomato.webp"

  ProductModel(
      imageURL: "${assets}goat_meat.png",
      name: "Goat Meat",
      price: 4700,
      quantity: 12,
      unit: "kilo"),
          */
        } catch (e) {
          logger("The error $e");
        }
      }
      dshCtx.read<UINotifier>().produceNotice(rslt);
    } else {
      nvg = Navigate();
      if (selectedTabName != "") {
        DatabaseHelper dbm = DatabaseHelper(table: mnf);

        int i = await dbm.queryRowCount();
        if (i > 0) {
          List<Map<String, dynamic>> dd = await dbm.queryAllRows();
          Map<String, dynamic> ust = dd[0];

          // logger("Cast::: ${dd[0][cpt]}");
          Map<String, dynamic> ddd = jsonDecode(ust[cpt]);

          String ctg_ = ddd[usr][ctg];
          logger("Desig: $ctg_");
          if (ctg_ == "1") {
            ctg_ = "11";
          }

          Map<String, dynamic> identity = jsonDecode(selectedTabName);
          Map<String, String> mnff = {
            "Joint":
                " p INNER JOIN price_index x on p.item =x.produce INNER JOIN unit u on x.unit = u.abbrv WHERE x.cadre = $ctg_ AND p.type = ${identity[id]} ",
            "Rep":
                " p.id, p.item, p.type, p.created AS created_at, p.image, x.amount AS price, u.tag as unit, u.abbrv,  p.nutritional_value"
          };

          Map<String, dynamic>? obj = await nvg.readData(
              produce, mnff, global, rt, "", false, rt, context);

          //
          // nvg.readData(produce, mnf, global, rd, "", false, rd, context);

          ServerPrelim? svp = ServerPrelim.fromJson(obj!); // as ServerPrelim?;

          if (svp.status) {
            ServerResponse rsp = ServerResponse.fromJson(obj);
            for (final item in rsp.data) {
              String typ = item["type"];
              //1  String img = item["image"];

              rslt.add(ProductModel(
                  name: item[itm],
                  imageURL: item[img], // "${assets}goat_meat.png",
                  price: double.parse(item["price"]),
                  quantity: 12,
                  abbrv: item["abbrv"],
                  unit: item["unit"]));

              //  cntz.add({"name": typ, "imageURL": "${assets}foodplate.png"});
              dbp.insertData(item);
            }

            dshCtx.read<UINotifier>().produceNotice(rslt);
          }
        }
      }

      /*
      {
   "Essence":"access",
   "State":"specific_tsk",
   "Specific":"Router",
   "Table":"produce",
   "Joint":" p INNER JOIN price_index x on p.item =x.produce INNER JOIN unit u on x.unit = u.abbrv WHERE x.cadre = 11 ",
   "Rep":" p.id, p.item, p.type, p.created AS created_at, p.image, x.amount AS price, u.tag as unit, u.abbrv,  p.nutritional_value"
}
      */
    }
    return rslt;
  }

  Future<int>? _cart() async {
    int i = await dbCart.queryRowCount();
    cartz = i;
    return i;
  }

  FutureBuilder<int> _cartdisplay() {
    return FutureBuilder(
        future: cart,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int? data_ = snapshot.data;
            String qq = "$data_";
            if (data_! < 1) {
              qq = "";
            }
            return Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                radius: 7,
                backgroundColor: FarmToDishTheme.themeRed,
                child: Text(
                  qq,
                  style: TextStyle(
                      color: FarmToDishTheme.scaffoldBackgroundColor,
                      fontSize: 10),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const NoInternet();
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: LoadingAnimationWidget.flickr(
                  leftDotColor: Color(0xff029534),
                  rightDotColor: bgmainclr,
                  size: 30),
            ),
          );
        });
  }

  Align _cartdefault() {
    return Align(
      alignment: Alignment.bottomRight,
      child: CircleAvatar(
        radius: 7,
        backgroundColor: FarmToDishTheme.themeRed,
        child: Text(
          "1",
          style: TextStyle(
              color: FarmToDishTheme.scaffoldBackgroundColor, fontSize: 10),
        ),
      ),
    );
  }

  Future<List<Widget>>? _produceSect() async {
    List<Widget> plc = [];
    int ptt = await dbp.queryRowCount();
    List<Map<String, dynamic>> dd = [];
    logger("Size $ptt");
    if (ptt > 0) {
      List<Map<String, dynamic>> fm = await dbp.queryAllRows();
      for (Map<String, dynamic> itmm in fm) {
        logger("item${itmm[typ]}");
        try {
          plc.add(
            SelectionChip(
              name: itmm[typ],
              imageURL: "${assets}fruitVeggie.png",
              isSelected: selectedTabName == "fruits And Vegie",
              onClickFunction: (p0) {
                selectedTabName = "fruits And Vegie";
                setState(() {});
              },
              essence: '',
            ),
          );
          plc.add(
            SizedBox(width: 10),
          );
        } catch (e) {
          logger("The error $e");
        }
      }
    } else {}
    return plc;
  }

  Future<List<String>>? __produceSect() async {
    List<String> plc = [];
    int ptt = await dbh.queryRowCount();
    List<Map<String, dynamic>> dd = [];
    if (ptt > 0) {
      List<Map<String, dynamic>> fm = await dbh.queryAllRows();
      for (Map<String, dynamic> itmm in fm) {
        plc.add(itmm[nmm]
            //SizedBox(width: 10),
            );
      }
    }
    return plc;
  }

  Future<List<ProduceType>>? produceSect() async {
    List<ProduceType> pstk = [];
    int ptt = await dbh.queryRowCount();
    List<Map<String, dynamic>> dd = [];
    if (ptt > 0) {
      List<Map<String, dynamic>> fm = await dbh.queryAllRows();
      for (Map<String, dynamic> itmm in fm) {
        pstk.add(
            ProduceType(name: itmm[typ], image: "${assets}fruitVeggie.png"));
      }
    }
    return pstk;
  }

  late Future<TitleMoreAndBodyWidget>? bdw;

  FutureBuilder<List<Widget>> stackData() {
    return FutureBuilder(
        future: schip,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Widget>? data_ = snapshot.data;

            return SingleChildScrollView(
              child: Row(children: [
                ListView.builder(
                    itemCount: data_!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, index) {
                      return data_[index];
                    })
              ]),
            );
            // return cast(essence, data_!);
          } else if (snapshot.hasError) {
            return const NoInternet();
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: LoadingAnimationWidget.flickr(
                  leftDotColor: Color(0xff029534),
                  rightDotColor: bgmainclr,
                  size: 30),
            ),
          );
        });
  }

  FutureBuilder<List<Widget>> _bodyWidget() {
    return FutureBuilder(
        future: schip,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            List<Widget>? data_ = snapshot.data;

            return SingleChildScrollView(
              child: Row(
                children: [
                  ListView.builder(
                    itemCount: data_!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Text("This $index"); //data_[index];
                    },
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Text("Cast Error ");
          }
          return Text("data");
        }));
  }

  TitleMoreAndBodyWidget _buildSelectorTab() {
    return TitleMoreAndBodyWidget(
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            SelectionChip(
              name: "fruits And Vegie",
              imageURL: "${assets}fruitVeggie.png",
              isSelected: selectedTabName == "fruits And Vegie",
              onClickFunction: (p0) {
                selectedTabName = "fruits And Vegie";
                setState(() {});
              },
              essence: '',
            ),
            SizedBox(width: 10),
            SelectionChip(
              name: "Grains and legumes",
              imageURL: "${assets}grains.png",
              isSelected: selectedTabName == "Grains and legumes",
              onClickFunction: (p0) {
                selectedTabName = "Grains and legumes";

                setState(() {});
              },
              essence: '',
            ),
            SizedBox(width: 10),
            SelectionChip(
              name: "Tubers",
              imageURL: "${assets}tubbers.png",
              isSelected: selectedTabName == "Tubers",
              onClickFunction: (p0) {
                selectedTabName = "Tubers";
                setState(() {});
              },
              essence: '',
            ),
            SizedBox(width: 10),
            SelectionChip(
              name: "Spices",
              imageURL: "${assets}pepper.png",
              isSelected: selectedTabName == "Spices",
              onClickFunction: (p0) {
                selectedTabName = "Spices";
                setState(() {});
              },
              essence: '',
            ),
          ]),
        ),
        titleWidget: Text(
          "Categories",
          style: TextStyle(
              // color:
              // FarmToDishTheme.scaffoldBackgroundColor,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ));
  }

  Column preload() {
    return Column(
        children: testProducts
            .map((e) => _buildProductTab(
                imageURL: e.imageURL,
                pname: e.name,
                priceStatement: e.priceStatement,
                quantity: e.quantityStatement,
                model: e,
                cartModel: e.createCartModelFromProduct()))
            .toList());
  }

  FutureBuilder<List<ProductModel>> loadProduct() {
    return FutureBuilder(
        future: pmdl,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            List<ProductModel>? pdm = pdmm;
            // snapshot.data;
            return Column(
                children: pdm!
                    .map((e) => _productTab(
                        imageURL: e.imageURL,
                        pname: e.name,
                        priceStatement: e.priceStatement,
                        quantity: e.quantityStatement,
                        model: e,
                        cartModel: e.createCartModelFromProduct()))
                    .toList());
          } else if (snapshot.hasError) {}
          return Center(
            child: LoadingAnimationWidget.flickr(
                leftDotColor: Color(0xff029534),
                rightDotColor: bgmainclr,
                size: 30),
          );
        }));

    /*
    return Column(
        children: testProducts
            .map((e) => _buildProductTab(
                imageURL: e.imageURL,
                name: e.name,
                priceStatement: e.priceStatement,
                quantity: e.quantityStatement,
                model: e,
                cartModel: e.createCartModelFromProduct()))
            .toList());
            */
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
          (Navigator.of(context).canPop())
              ? IconButton(
                  onPressed: () {
                    print("object");
                    if (Navigator.of(context).canPop()) context.pop();
                  },
                  icon: Icon(
                    Icons.chevron_left,
                    color: FarmToDishTheme.scaffoldBackgroundColor,
                  ),
                )
              : SizedBox(),
          Text(
            "Products",
            style: TextStyle(
                color: FarmToDishTheme.scaffoldBackgroundColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: () {
              if (cartz > 0) {
              } else {
                customSnackBar(
                    context, "No item in cart yet, please add items to cart");
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                // color: FarmToDishTheme.accentLightColor,
                height: 26,
                width: 26,

                // child: Stack(
                //   children: [
                //     Icon(
                //       Icons.shopping_cart,
                //       color: FarmToDishTheme.scaffoldBackgroundColor,
                //     ),
                //     (cart == null) ? Text("") : _cartdisplay(),
                //   ],
                // ),
              ),
            ),
          ),
          //SizedBox(height: 0, width: 0)
        ],
      ),
    );
  }
}

class AddORRemoveProductButton extends StatefulWidget {
  Future<bool> Function(bool) onClickExternalFunction;
  AddORRemoveProductButton({super.key, required this.onClickExternalFunction});

  @override
  State<AddORRemoveProductButton> createState() =>
      _AddORRemoveProductButtonState();
}

class _AddORRemoveProductButtonState extends State<AddORRemoveProductButton> {
  bool isAdded = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        bool tochange = await widget.onClickExternalFunction.call(!isAdded);
        if (tochange) isAdded = !isAdded;
        try {
          setState(() {});
        } catch (e) {}
      },
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color:
              !isAdded ? FarmToDishTheme.faintGreen : FarmToDishTheme.themeRed,
        ),
        child: Icon(
          isAdded ? Icons.remove : Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class SelectionChip extends StatefulWidget {
  String? imageURL;
  bool isSelected;
  Function(bool)? onClickFunction;
  // Function() stateSetterFunction;

  String name;
  String essence;
  SelectionChip({
    super.key,
    this.imageURL,
    this.isSelected = false,
    required this.name,
    required this.essence,
    this.onClickFunction,
  });

  @override
  State<SelectionChip> createState() => _SelectionChipState();
}

class _SelectionChipState extends State<SelectionChip> {
  bool another = false;
  @override
  Widget build(BuildContext context) {
    another = widget.isSelected;
    return InkWell(
      onTap: () {
        print(widget.isSelected);
        // widget.isSelected = !widget.isSelected;
        another = !another;
        widget.isSelected = another;
        logger("This pressed: ${widget.essence}");

        // print(widget.isSelected);
        widget.onClickFunction?.call(widget.isSelected);
        setState(() {});
      },
      child: Container(
        width: 120,
        // height: 44,
        constraints: BoxConstraints(maxHeight: 50),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: another
                ? FarmToDishTheme.deepGreen
                : FarmToDishTheme.accentLightColor,
            boxShadow: !another
                ? List.filled(4, FarmToDishTheme.genericBoxShadow)
                : null),
        // : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            (widget.imageURL != null)
                ? Image.asset(widget.imageURL!)
                : SizedBox(),
            // Visibility(visible: imageURL != null, child: Image.asset(imageURL!)),
            SizedBox(
              width: 70,
              child: Text(
                widget.name,
                textWidthBasis: TextWidthBasis.parent,
                softWrap: true,
                style: TextStyle(
                    color: another
                        ? FarmToDishTheme.scaffoldBackgroundColor
                        : FarmToDishTheme.deepGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
