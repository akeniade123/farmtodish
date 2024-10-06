import 'package:farm_to_dish/Screens/DeliveryCar/delivery_car_model.dart';

import '../../global_objects.dart';

class CartItemModel {
  String cartID;
  final String? name;
  final String? unit;

  final double? price;
  int? quantity;

  final String? priceStatement;
  final String? quantityStatement;

  final String? imageURL;
  CartItemModel(
    this.cartID, {
    this.name,
    this.price,
    this.priceStatement,
    this.imageURL,
    this.unit,
    this.quantity,
    this.quantityStatement,
  }) {
    getPriceStatment();
    getQuantityStatement();
    // ge
  }

  String getPriceStatment() {
    return "$currency$price per $unit";
  }

  String getQuantityStatement() {
    return "$quantity $unit left";
  }

  double getTotalPriceStatment() {
    return (quantity ?? 0) * (price ?? 0);
  }
}

class OrderModel {
  DeliveryCarModel? vehicle;
  List<CartItemModel> items = [];
  bool isPaid = false;
  bool isDelivered = false;
  OrderModel({this.vehicle, required this.items}) {
    totalPrice = getTotalPrice();
  }
  double totalPrice = 0.0;
  double getTotalPrice() {
    double result = 0;
    items.forEach((element) {
      result += (element.price) ?? 0;
    });
    return result;
  }

  addThis(CartItemModel item) {
    items.add(item);
  }

  removeThis(CartItemModel item) {
    items.remove(item);
  }
}
