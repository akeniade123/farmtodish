// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings

// import 'dart:js_interop';

import 'dart:io';
import 'dart:math';
// import 'package:flutter/widgets.dart' as w;
// import 'package:Yomcoin/models/models.dart';
// import 'package:Yomcoin/screens/login.dart';
import 'package:farm_to_dish/app_theme_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../../Dialogs/dialog_to_adding_products.dart';
import '../../global_objects.dart';
import '../../global_widgets.dart';
import '../Cart/cart_item_model.dart';
// import '../Payment/cart_model.dart';
import '../screens.dart';
import 'product_model.dart';

class ProductScreen extends StatefulWidget {
  String? initialySelectedTab;
  ProductScreen({super.key, this.initialySelectedTab = ""});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  // List<CartItemModel> selectedProducts = [];
  @override
  void initState() {
    // TODO: implement initState
    // selectedProducts = currentOrder?.items ?? [];
    currentOrder ??= OrderModel(items: []);
    selectedTabName = widget.initialySelectedTab ?? "";
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
                  borderRadius: BorderRadius.circular(30),
                  color: FarmToDishTheme.scaffoldBackgroundColor,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        _buildSearchBar(),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            _buildSelectorTab(),
                            SizedBox(height: 20),
                            Column(
                                children: testProducts
                                    .map((e) => _buildProductTab(
                                        imageURL: e.imageURL,
                                        name: e.name,
                                        priceStatement: e.priceStatement,
                                        quantity: e.quantityStatement,
                                        model: e,
                                        cartModel:
                                            e.createCartModelFromProduct()))
                                    .toList()
                                // [
                                //     _buildProductTab(
                                // imageURL: "${assets}yams.png",
                                // name: "Yams",
                                // priceStatement: "N500 per tuber",
                                // quantity: "4 tubers left"),
                                //     _buildProductTab(
                                //         imageURL: "${assets}yams.png",
                                //         name: "Yams",
                                //         priceStatement: "N500 per tuber",
                                //         quantity: "4 tubers left"),
                                //     _buildProductTab(
                                //         imageURL: "${assets}yams.png",
                                //         name: "Yams",
                                //         priceStatement: "N500 per tuber",
                                //         quantity: "4 tubers left"),
                                //   ],
                                )
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
      String? name,
      String? priceStatement,
      String? imageURL,
      required ProductModel model,
      required CartItemModel? cartModel}) {
    return Column(
      children: [
        Container(
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
                          name.toString(),
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
                          "${quantity.toString()}",
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
                                  productModel:
                                      ProductModel(quantity: 12, price: 1200),
                                  model: cartModel
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
        setState(() {});
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
  SelectionChip({
    super.key,
    this.imageURL,
    this.isSelected = false,
    required this.name,
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
        // print(widget.isSelected);
        widget.onClickFunction?.call(widget.isSelected);
        setState(() {});
      },
      child: Container(
        width: 125,
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
