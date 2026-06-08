class Product {
  String id;
  String name;
  int stock;
  int shopeeStock;
  int tokopediaStock;
  double price;
  
  Product({
    required this.id,
    required this.name,
    required this.stock,
    required this.shopeeStock,
    required this.tokopediaStock,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['nama_produk'].toString(),
      stock: int.parse(json['stok'].toString()),
      shopeeStock: int.tryParse(json['shopee_stock'].toString()) ?? 0,
      tokopediaStock: int.tryParse(json['tokopedia_stock'].toString()) ?? 0,
      price: double.parse(json['harga'].toString()),
    );
  }
}