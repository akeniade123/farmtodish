class DeliveryCarModel {
  final String name, driver;
  final double price, doorStepDeliveryPrice;
  double? rating;
  final bool isAvailable;

  DeliveryCarModel(this.rating,
      {required this.driver,
      required this.doorStepDeliveryPrice,
      required this.price,
      required this.name,
      required this.isAvailable});
}
