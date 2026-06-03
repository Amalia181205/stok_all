class Product {
  String id;
  String name;
  int stock;
  double price;
  
  Product({
    required this.id,
    required this.name,
    required this.stock,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['nama_produk'].toString(),
      stock: int.parse(json['stok'].toString()),
      price: double.parse(json['harga'].toString()),
    );
  }
}