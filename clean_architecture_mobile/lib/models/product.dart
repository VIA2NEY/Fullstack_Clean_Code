

class Product {
  final int? id;
  final String? name;
  final String? description;
  final double? price;

  Product({
    this.id, 
    this.name, 
    this.description, 
    this.price, 
  });

  // Methode pour convertir un Map (dictionnaire) en Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String?,
      description: map['description'] as String?,
      price: map['price'] as double?,
    );
  }

}