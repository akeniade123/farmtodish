class DeliveryCarModel {
  String name = "babariger motomoto";
  double price = 0.0;
  double rating = 4.8;
  double doorStepDeliveryPrice = 0.0;
  bool isAvailable = false;

  DeliveryCarModel(
      {this.doorStepDeliveryPrice = 0,
      this.price = 0,
      this.rating = 0,
      this.name = "babariger motomoto",
      this.isAvailable = false});
}
