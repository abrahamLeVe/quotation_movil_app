// payment_state.dart
import 'package:flutter/material.dart';
import 'package:pract_01/models/payment/get_all_payment.dart'; // Asegúrate de tener este modelo correctamente definido.

class PaymentState with ChangeNotifier {
  List<Payment> _payments = [];
  List<Payment> _originalPayments = [];
  int _paymentsCount = 0;
  bool _arePaymentsLoaded = false;

  List<Payment> get payments => _payments;
  int get productsCount => _paymentsCount;
  bool get arePaymentsLoaded => _arePaymentsLoaded;
  bool newNotificationAvailable = false;
  bool isNewNotificationAvailable() {
    if (newNotificationAvailable) {
      newNotificationAvailable = false;
      return true;
    }
    return false;
  }

  set payments(List<Payment> newPayments) {
    _payments = newPayments;
    notifyListeners();
  }

  void addPayment(Payment payment) {
    _payments.add(payment);
    notifyListeners();
  }

  void setPaymentsCount(int count) {
    _paymentsCount = count;
    notifyListeners();
  }

  void updatePayment(Payment updatedPayment) {
    int index = _payments.indexWhere((p) => p.id == updatedPayment.id);
    if (index != -1) {
      _payments[index] = updatedPayment;
      notifyListeners();
    }
  }

  void setArePaymentsLoaded(bool value) {
    _arePaymentsLoaded = value;
    notifyListeners();
  }

  void setPayments(List<Payment> payments) {
    _payments = payments;
    _originalPayments = List<Payment>.from(payments);
    setPaymentsCount(payments.length);
    notifyListeners();
  }

  int get paymentsCount => _payments.length;
}
