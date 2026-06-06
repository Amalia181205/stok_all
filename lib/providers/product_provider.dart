import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  List<Product> get lowStockProducts {
    return _products.where((p) => p.stock < 5).toList();
  }

  int get totalProduk => _products.length;

  void setProducts(List<Product> data) {
    _products = data;
    notifyListeners();
  }
}
