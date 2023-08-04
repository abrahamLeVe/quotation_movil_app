import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/product/get_all_product_model.dart';

class ProductState with ChangeNotifier {
  List<Product> _products = [];
  int _productsCount = 0;

  List<Product> get products => _products;
  int get productsCount =>
      _productsCount; // Getter para el contador de productos

  void setProducts(List<Product> products) {
    _products = products;
    setProductsCount(products.length);
    notifyListeners();
  }

  void setProductsCount(int count) {
    _productsCount = count;
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
