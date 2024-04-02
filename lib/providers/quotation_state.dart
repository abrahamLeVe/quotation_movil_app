import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';

class QuotationState with ChangeNotifier {
  List<Quotation> _quotations = [];
  List<Quotation> _originalQuotations = [];
  bool _areQuotationsLoaded = false;
  int _quotationsCount = 0;

  List<Quotation> get quotations => _quotations;
  bool get areQuotationsLoaded => _areQuotationsLoaded;
  int get quotationsCount => _quotationsCount;
  bool newNotificationAvailable = false;
  bool isNewNotificationAvailable() {
    if (newNotificationAvailable) {
      newNotificationAvailable = false;
      return true;
    }
    return false;
  }

  void setQuotations(List<Quotation> quotations) {
    print('setQuotation $quotations');
    _quotations = quotations;
    _originalQuotations = List<Quotation>.from(quotations);
    setQuotationsCount(quotations.length);
    notifyListeners();
  }

  void setAreQuotationsLoaded(bool value) {
    _areQuotationsLoaded = value;
    notifyListeners();
  }

  void filterQuotations(String searchText) {
    if (searchText.isEmpty) {
      _quotations = List<Quotation>.from(_originalQuotations);
    } else {
      final filteredQuotations = _originalQuotations.where((quotation) {
        final code = quotation.id.toString();
        return code.contains(searchText.toUpperCase());
      }).toList();

      _quotations = filteredQuotations;
    }
    notifyListeners();
  }

  void updateQuotationProvider(Quotation updatedQuotation) {
    final index = _quotations.indexWhere((q) => q.id == updatedQuotation.id);
    if (index != -1) {
      _quotations[index] = updatedQuotation;
      updateQuotationsCount();
      notifyListeners();
    }
  }

  void updateQuotationsCount() {
    _quotationsCount = _quotations.length;
    notifyListeners();
  }

  void setQuotationsCount(int count) {
    _quotationsCount = count;
    notifyListeners();
  }

  void addQuotation(Quotation quotation) {
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
}
