import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/product/product_model.dart';

class ProductState with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  void setProducts(List<Product> products) {
    _products = products;
    notifyListeners();
  }

  void filterProducts(String searchText) {
    if (searchText.isEmpty) {
      notifyListeners();
      return;
    }

    final filteredProducts = _products.where((product) {
      final code = product.attributes.name.toUpperCase();
      return code.contains(searchText.toUpperCase());
    }).toList();

    _products = filteredProducts;
    notifyListeners();
  }
}
