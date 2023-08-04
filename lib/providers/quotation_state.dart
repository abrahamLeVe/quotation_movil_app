import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';

class QuotationState with ChangeNotifier {
  List<Quotation> _quotations = [];
   List<Quotation> _originalQuotations = [];
  bool _areQuotationsLoaded = false;
  int _quotationsCount = 0; // Nuevo campo para el contador de cotizaciones

  List<Quotation> get quotations => _quotations;
  bool get areQuotationsLoaded => _areQuotationsLoaded;
  int get quotationsCount =>
      _quotationsCount; // Getter para el contador de cotizaciones
  bool newNotificationAvailable =
      false; // Variable para marcar notificación nueva
  bool isNewNotificationAvailable() {
    if (newNotificationAvailable) {
      newNotificationAvailable = false;
      return true;
    }
    return false;
  }

   void setQuotations(List<Quotation> quotations) {
    _quotations = quotations;
    _originalQuotations = List<Quotation>.from(quotations); // Copia de respaldo
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
          List<Quotation>.from(_originalQuotations); // Restaurar lista original
    } else {
      final filteredQuotations = _originalQuotations.where((quotation) {
        final code = quotation.attributes.codeQuotation?.toUpperCase();
        return code!.contains(searchText.toUpperCase());
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

      // Agrega la línea para imprimir las cotizaciones actualizadas en la consola
      print('Cotización actualizada en el estado: ${_quotations}');

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

  void addQuotation(Quotation quotation) {
    _quotations.add(quotation);
    updateQuotationsCount();
    notifyListeners();
  }

  void markNewNotificationAvailable() {
    newNotificationAvailable = true;
    notifyListeners();
  }
}
