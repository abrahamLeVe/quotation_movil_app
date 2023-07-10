import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';
import 'package:pract_01/models/quotation/get_details_quotation_model.dart';
import 'package:pract_01/services/quotation_service.dart';

class QuotationState with ChangeNotifier {
  List<Quotation> _quotations = [];

  List<Quotation> get quotations => _quotations;

  void setQuotations(List<Quotation> quotations) {
    _quotations = quotations;
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

  void filterQuotationId(int quotationId) {
    final filteredQuotations = _quotations.where((quotation) {
      final code = quotation.attributes.codeQuotation.toUpperCase();
      return code.contains(quotationId as Pattern);
    }).toList();

    _quotations = filteredQuotations;
    notifyListeners();
  }

  Future<GetDetailsQuotation?> getQuotationById(int quotationId) async {
    try {
      final quotationDetails =
          await QuotationService().getDetailsQuotation(quotationId);
      return quotationDetails;
    } catch (error) {
      return null;
    }
  }
}
