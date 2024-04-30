import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart'
    as quotation_all_model;
import 'package:pract_01/services/quotation_service.dart';
import 'package:provider/provider.dart';

class QuotationState with ChangeNotifier {
  List<quotation_all_model.Quotation> _quotations = [];
  List<quotation_all_model.Quotation> _fullquotations = [];
  List<quotation_all_model.Quotation> _originalQuotations = [];
  bool _areQuotationsLoaded = false;

  List<quotation_all_model.Quotation> get quotations => _quotations;
  List<quotation_all_model.Quotation> get fullquotations => _fullquotations;

  bool get areQuotationsLoaded => _areQuotationsLoaded;

  bool newNotificationAvailable = false;
  bool isNewNotificationAvailable() {
    if (newNotificationAvailable) {
      newNotificationAvailable = false;
      return true;
    }
    return false;
  }

  void setQuotations(List<quotation_all_model.Quotation> quotations) {
    _quotations = quotations;
    _originalQuotations = List<quotation_all_model.Quotation>.from(quotations);
    setQuotationsCount(quotations.length);
    notifyListeners();
  }

  void setAreQuotationsLoaded(bool value) {
    _areQuotationsLoaded = value;
    notifyListeners();
  }

  void filterQuotations(String searchText) {
    if (searchText.isEmpty) {
      _quotations =
          List<quotation_all_model.Quotation>.from(_originalQuotations);
    } else {
      final filteredQuotations = _originalQuotations.where((quotation) {
        final code = quotation.id.toString();
        return code.contains(searchText.toUpperCase());
      }).toList();

      _quotations = filteredQuotations;
    }
    notifyListeners();
  }

  void updateQuotationProvider(quotation_all_model.Quotation updatedQuotation) {
    final index = _quotations.indexWhere((q) => q.id == updatedQuotation.id);
    if (index != -1) {
      _quotations[index] = updatedQuotation;
      updateQuotationsCount();
      notifyListeners();
    }
  }

  void updateQuotationsCount() {
    notifyListeners();
  }

  void setQuotationsCount(int count) {
    notifyListeners();
  }

  void addQuotation(quotation_all_model.Quotation quotation) {
    _quotations.add(quotation);
    updateQuotationsCount();
    notifyListeners();
  }

  void markNewNotificationAvailable() {
    newNotificationAvailable = true;
    notifyListeners();
  }

  void removeQuotation(int quotationId) {
    _quotations.removeWhere((quotation) => quotation.id == quotationId);
    updateQuotationsCount();
    notifyListeners();
  }

  Map<String, Map<String, dynamic>> getProductCounts() {
    Map<String, Map<String, dynamic>> productCounts = {};
    for (var quotation in _fullquotations) {
      for (var product in quotation.attributes.products) {
        String? title = product.title;
        int? quantity = product.quantity;

        if (productCounts.containsKey(title)) {
          productCounts[title]?['quantity'] += quantity;
        } else {
          productCounts[title] = {
            'quantity': quantity,
            'name': title, // Guardar el nombre del producto
            'picture_url':
                product.pictureUrl // Opcional: Guardar la URL de la imagen
          };
        }
      }
    }
    return productCounts;
  }

  void loadNewQuotations(BuildContext context) async {
    _areQuotationsLoaded = false;
    // notifyListeners(); // Notifica que está cargando

    try {
      QuotationService service =
          Provider.of<QuotationService>(context, listen: false);
      var newQuotations = await service.getAllQuotation(1);
      _quotations = newQuotations.data;
      _areQuotationsLoaded = true;
      notifyListeners();
    } catch (error) {
      _areQuotationsLoaded = false;
      notifyListeners(); // Notifica que la carga falló
      if (kDebugMode) {
        print("Error loading new quotations: $error");
      }
    }
  }

  void loadFullQuotations(BuildContext context) async {
    _areQuotationsLoaded = false;
    // notifyListeners(); // Notifica que está cargando

    try {
      QuotationService service =
          Provider.of<QuotationService>(context, listen: false);
      var newQuotations = await service.getFullQuotation();
      _fullquotations = newQuotations.data;
      _areQuotationsLoaded = true;
      notifyListeners();
    } catch (error) {
      _areQuotationsLoaded = false;
      notifyListeners(); // Notifica que la carga falló
      if (kDebugMode) {
        print("Error loadFullQuotations: $error");
      }
    }
  }

  Map<String, Map<String, dynamic>> getProductStatesCounts() {
    Map<String, Map<String, dynamic>> productCounts = {};
    for (var quotation in _fullquotations) {
      if (quotation.attributes.codeStatus == "Cerrada") {
        for (var product in quotation.attributes.products) {
          String title = product.title;
          String imageUrl = product.pictureUrl;
          int quantity = product.quantity;

          if (productCounts.containsKey(title)) {
            productCounts[title]?['quantity'] += quantity;
          } else {
            productCounts[title] = {
              'quantity': quantity,
              'name': title, // Guardar el nombre del producto
              'picture_url': imageUrl // Opcional: Guardar la URL de la imagen
            };
          }
        }
      }
    }
    return productCounts;
  }

  Map<String, Map<String, dynamic>> getTopClients() {
    Map<String, Map<String, dynamic>> clientPurchases = {};
    for (var quotation in _fullquotations) {
      if (quotation.attributes.codeStatus == "Cerrada") {
        String clientName = quotation.attributes.name;
        String clientEmail = quotation.attributes.email;
        String clientPhone = quotation.attributes.phone;
        Map<String, dynamic> docs = {};

        // Revisar si ya existe información sobre el cliente y actualizar
        if (clientPurchases.containsKey(clientName)) {
          docs = clientPurchases[clientName]?['docs'];
        }
        // Agregar o actualizar la información del tipo de documento y número
        String typeDoc = quotation.attributes.tipeDoc;
        String numDoc = quotation.attributes.numDoc;
        docs[typeDoc] = numDoc;

        int productQuantity = quotation.attributes.products
            .map((product) => product.quantity)
            .reduce((a, b) => a + b);

        clientPurchases[clientName] = {
          'quantity': clientPurchases.containsKey(clientName)
              ? clientPurchases[clientName]!['quantity'] + productQuantity
              : productQuantity,
          'name': clientName,
          "email": clientEmail,
          "phone": clientPhone,
          "docs": docs
        };
      }
    }
    return clientPurchases;
  }

  int get quotationsCount => _quotations.length;
}
