import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';

class QuotationState with ChangeNotifier {
  List<Quotation> _quotations = [];

  List<Quotation> get quotations => _quotations;

  void setQuotations(List<Quotation> quotations) {
    _quotations = quotations;
    notifyListeners();
  }

  void filterQuotations(String searchText) {
    if (searchText.isEmpty) {
      // No se ha ingresado texto de búsqueda, mostrar todas las cotizaciones
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
}
