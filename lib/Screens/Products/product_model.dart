import 'package:farm_to_dish/Screens/Cart/cart_item_model.dart';
// import 'package:farm_to_dish/Screens/Payment/cart_model.dart';

import '../../global_objects.dart';

class ProductModel {
  String? productID = "bdbasd";
  final String name;
  final String? unit;

  final double? price;
  final int? quantity;

  String? priceStatement;
  String? quantityStatement;

  final String? imageURL;
  ProductModel(
      {required this.name,
      this.price,
      this.priceStatement,
      this.imageURL,
      this.unit,
      this.quantity,
      this.quantityStatement,
      this.productID = "asbdksad"}) {
    priceStatement = getPriceStatment();
    quantityStatement = getQuantityStatement();
    // ge
  }

  String getPriceStatment() {
    return "$currency$price per $unit";
  }

  String getQuantityStatement() {
    return "$quantity $unit left";
  }

  CartItemModel createCartModelFromProduct() {
    return CartItemModel("${productID!}carted",
        imageURL: imageURL,
        name: name,
        price: price,
        priceStatement: priceStatement,
        unit: unit);
  }
}

class ProduceType {
  final String name;

  final String image;

  ProduceType({required this.name, required this.image}) {}
}
