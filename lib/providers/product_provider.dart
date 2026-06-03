import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  int totalProduk = 0;

  void setTotalProduk(int total) {
    totalProduk = total;
    notifyListeners();
  }
}
