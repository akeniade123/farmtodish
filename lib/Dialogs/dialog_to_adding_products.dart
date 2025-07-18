// import 'package:farm_to_dish/Screens/Payment/cart_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:farm_to_dish/Screens/Cart/cart_item_model.dart';
import 'package:farm_to_dish/Screens/Products/product_model.dart';
import 'package:farm_to_dish/app_theme_file.dart';
import 'package:farm_to_dish/global_objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class DialogToAddingProducts extends StatefulWidget {
  CartItemModel? model;
  final ProductModel productModel;

  DialogToAddingProducts({super.key, this.model, required this.productModel});

  @override
  State<DialogToAddingProducts> createState() => _DialogToAddingProductsState();
}

class _DialogToAddingProductsState extends State<DialogToAddingProducts> {
  int quantity = 0;
  late ProductModel? pmdl;

  static final customCacheManager = CacheManager(Config('customCacheKey',
      stalePeriod: const Duration(days: 15), maxNrOfCacheObjects: 100));

  @override
  void initState() {
    quantity = widget.model?.quantity ?? 0;
    // nmm =;
    super.initState();
  }

/*
  Future<ProductModel> product() {
    ProductModel _pmdl = null;
   // widget.productModel;
    if (widget.productModel == null) {}
    return _pmdl;
  }
  */

  @override
  Widget build(BuildContext context) {
    widget.model?.quantity = quantity;
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 340,
        width: 290,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: FarmToDishTheme.scaffoldBackgroundColor),
        child: Column(children: [
          Row(
            children: [
              Container(
                height: 95,
                width: 95,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
                      imageUrl: widget.model!.imageURL!,
                      errorWidget: (context, url, error) =>
                          Icon(Icons.broken_image),
                    )

                    // Image.network(
                    //   widget.model!.imageURL ?? "",
                    //   errorBuilder: (context, error, stackTrace) =>
                    //       const Icon(Icons.broken_image),
                    //   fit: BoxFit.cover,
                    // ),

                    ), // Image.asset("${assets}yams.png"),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  (widget.productModel.name.length > 7)
                      ? SizedBox(
                          width: 95,
                          child: FittedBox(
                            // TRY THIS: Try changing the fit types to see how they change the way
                            // the placeholder fits into the container.
                            fit: BoxFit.fill,
                            child: Text(
                              widget.productModel.name,
                              style: const TextStyle(
                                  // color:
                                  // FarmToDishTheme.scaffoldBackgroundColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Text(widget.productModel.name,
                          style: const TextStyle(
                              // color:
                              // FarmToDishTheme.scaffoldBackgroundColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),

                  /*
                  Text(
                    widget.productModel.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),

                  */

                  Text(
                    "in ${widget.productModel.unit}",
                    style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Quantity:",
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              const SizedBox(width: 40),
              Row(
                children: [
                  MaterialButton(
                    padding: const EdgeInsets.all(0),
                    minWidth: 20,
                    height: 30,
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onPressed: () {
                      if (quantity > 0) quantity -= 1;
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    quantity.toString(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(width: 10),
                  MaterialButton(
                    padding: const EdgeInsets.all(0),
                    minWidth: 20,
                    height: 30,
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onPressed: () {
                      if (quantity < (widget.productModel?.quantity ?? 0)) {
                        quantity += 1;
                      }
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 25),
              const Text(
                "Total Price:",
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              const SizedBox(width: 50),
              Text(
                (widget.model?.getTotalPriceStatment()).toString(),
                style: const TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          MaterialButton(
            height: 50,
            minWidth: 200,
            color: FarmToDishTheme.faintGreen,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              (widget.model?.quantity != 0)
                  ? Navigator.pop(context, widget.model)
                  : Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Text(
                (widget.model?.quantity != 0) ? "Add to Cart" : "Return",
                style: TextStyle(
                  color: FarmToDishTheme.scaffoldBackgroundColor,
                  // fontSize: 14,
                  // fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
