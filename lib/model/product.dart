class Product {
  int id;
  String name;
  String description;
  double unitPrice;
  String imageUrl;
  bool isFavourite;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.unitPrice,
      required this.imageUrl,
      this.isFavourite = false});
}
