import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';

class QuotationState with ChangeNotifier {
  List<Quotation> _quotations = [];
  bool _areQuotationsLoaded = false;
  int _quotationsCount = 0; // Nuevo campo para el contador de cotizaciones

  List<Quotation> get quotations => _quotations;
  bool get areQuotationsLoaded => _areQuotationsLoaded;
  int get quotationsCount =>
      _quotationsCount; // Getter para el contador de cotizaciones

  void setQuotations(List<Quotation> quotations) {
    _quotations = quotations;
    setQuotationsCount(
        quotations.length); // Actualizar el contador de cotizaciones
    notifyListeners();
  }

  void setAreQuotationsLoaded(bool value) {
    _areQuotationsLoaded = value;
    notifyListeners();
  }

  void filterQuotations(String searchText) {
    if (searchText.isEmpty) {
      notifyListeners();
      return;
    }

    final filteredQuotations = _quotations.where((quotation) {
      final code = quotation.attributes.codeQuotation.toUpperCase();
      return code.contains(searchText.toUpperCase());
    }).toList();

    _quotations = filteredQuotations;
    notifyListeners();
  }

  void updateQuotationProvider(Quotation updatedQuotation) {
    final index = _quotations.indexWhere((q) => q.id == updatedQuotation.id);
    if (index != -1) {
      _quotations[index] = updatedQuotation;
      notifyListeners();
    }
  }

  // Nuevo método para actualizar el contador de cotizaciones
  void updateQuotationsCount() {
    _quotationsCount = _quotations.length;
    notifyListeners();
  }

  // Nuevo método para establecer el contador de cotizaciones
  void setQuotationsCount(int count) {
    _quotationsCount = count;
    notifyListeners();
  }
}
