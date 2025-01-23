class Product {
  final int id;
  final String image;
  final double price;
  final String name;
  final int quantity;
  final String category;
  final int categoryId;

  Product({
    required this.id,
    required this.image,
    required this.price,
    required this.name,
    required this.quantity,
    required this.category,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      category: json['category'] ?? '',
      categoryId: json['category_id'] ?? 0,
    );
  }

  String get categoryName{
    switch(categoryId){
      case 1: return 'Tables';
      case 2: return 'Chairs';
      case 3: return 'Bookcases';
      case 4: return 'Storage';
      case 5: return 'Paper';
      case 6: return 'Binders';
      case 7: return 'Copiers';
      case 8: return 'Envelopes';
      case 9: return 'Fasteners';
      default: return '';
    }
  }
}
