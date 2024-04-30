import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/product/get_all_product_model.dart';

import 'package:pract_01/services/product_service.dart';
import 'package:provider/provider.dart' as provider;

class ProductState with ChangeNotifier {
  List<ProductModelData> _products = [];
  List<ProductModelData> _fullproducts = [];
  List<ProductModelData> _originalProducts = [];
  bool _areProductsLoaded = false;

  List<ProductModelData> get products => _products;
  List<ProductModelData> get fullproducts => _fullproducts;

  bool get areProductsLoaded => _areProductsLoaded;

  bool newNotificationAvailable = false;
  bool isNewNotificationAvailable() {
    if (newNotificationAvailable) {
      newNotificationAvailable = false;
      return true;
    }
    return false;
  }

  void setProducts(List<ProductModelData> products) {
    _products = products;
    _originalProducts = List<ProductModelData>.from(products);
    setProductsCount(products.length);
    notifyListeners();
  }

  void setAreProductsLoaded(bool value) {
    _areProductsLoaded = value;
    notifyListeners();
  }

  void filterProducts(String searchText) {
    if (searchText.isEmpty) {
      _products = List<ProductModelData>.from(_originalProducts);
    } else {
      final filteredProducts = _originalProducts.where((product) {
        final code = product.id.toString();
        return code.contains(searchText.toUpperCase());
      }).toList();

      _products = filteredProducts;
    }
    notifyListeners();
  }

  void updateProductProvider(ProductModelData updatedProduct) {
    final index = _products.indexWhere((q) => q.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      updateProductsCount();
      notifyListeners();
    }
  }

  void updateProductsCount() {
    notifyListeners();
  }

  void setProductsCount(int count) {
    notifyListeners();
  }

  void addProduct(ProductModelData product) {
    _products.add(product);
    updateProductsCount();
    notifyListeners();
  }

  void markNewNotificationAvailable() {
    newNotificationAvailable = true;
    notifyListeners();
  }

  void removeProduct(int productId) {
    _products.removeWhere((product) => product.id == productId);
    updateProductsCount();
    notifyListeners();
  }

  Map<String, Map<String, dynamic>> getProductCounts() {
    Map<String, Map<String, dynamic>> productCounts = {};
    for (var product in _fullproducts) {
      String? title = product.attributes.name;
      int? quantity = product.attributes.rating;

      if (productCounts.containsKey(title)) {
        productCounts[title]?['quantity'] += quantity;
      } else {
        productCounts[title] = {
          'quantity': quantity,
          'name': title, // Guardar el nombre del producto
          'picture_url': product.attributes.thumbnail.data.attributes.formats
              .thumbnail.url // Opcional: Guardar la URL de la imagen
        };
      }
    }
    return productCounts;
  }

  void loadNewProducts(BuildContext context) async {
    _areProductsLoaded = false;
    // notifyListeners(); // Notifica que está cargando

    try {
      ProductService service =
          provider.Provider.of<ProductService>(context, listen: false);
      var newProducts = await service.getAllProduct();
      _products = newProducts.data;
      _areProductsLoaded = true;
      notifyListeners();
    } catch (error) {
      _areProductsLoaded = false;
      notifyListeners(); // Notifica que la carga falló
      if (kDebugMode) {
        print("Error loading new Products: $error");
      }
    }
  }

  void loadFullProducts(BuildContext context) async {
    _areProductsLoaded = false;
    // notifyListeners(); // Notifica que está cargando

    try {
      ProductService service =
          provider.Provider.of<ProductService>(context, listen: false);
      var newProducts = await service.getAllProduct();
      _fullproducts = newProducts.data;
      _areProductsLoaded = true;
      notifyListeners();
    } catch (error) {
      _areProductsLoaded = false;
      notifyListeners(); // Notifica que la carga falló
      if (kDebugMode) {
        print("Error loadFullProducts: $error");
      }
    }
  }

  Map<String, Map<String, dynamic>> getProductStatesCounts(
      List<ProductModelData> products) {
    Map<String, Map<String, dynamic>> productCounts = {};

    for (var product in products) {
      String name = product.attributes.name;
      String imageUrl =
          product.attributes.thumbnail.data.attributes.formats.thumbnail.url;
      List<dynamic> prices = product.attributes.prices.data
          .map((price) => price.attributes.value)
          .toList();

      productCounts[name] = {
        'name': name, // Guardar el nombre del producto
        'picture_url': imageUrl, // Guardar la URL de la imagen
        'prices': prices, // Guardar los precios del producto
      };
    }

    return productCounts;
  }

  int get productsCount => _products.length;
}
