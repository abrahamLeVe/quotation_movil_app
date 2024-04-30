import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pract_01/models/payment/get_all_payment.dart';
import 'package:pract_01/services/payment_service.dart';
import 'package:provider/provider.dart';

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

  // En PaymentState
  void loadNewPayments(BuildContext context) async {
    try {
      PaymentService service =
          Provider.of<PaymentService>(context, listen: false);
      PaymentModel newPayments = await service.getPaymentAll();

      // Actualiza el estado con los nuevos pagos
      setPayments(newPayments.data);
      setArePaymentsLoaded(true);
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar nuevos pagos: $e');
      }
      setArePaymentsLoaded(false);
    }
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

  void filterPayments(String searchText) {
    if (searchText.isEmpty) {
      _payments = List<Payment>.from(_originalPayments);
    } else {
      final filteredPayments = _originalPayments.where((payment) {
        final code = payment.id.toString();
        return code.contains(searchText.toUpperCase());
      }).toList();

      _payments = filteredPayments;
    }
    notifyListeners();
  }

  void updatePaymentsCount() {
    _paymentsCount = _payments.length;
    notifyListeners();
  }

  void removePayment(int paymentId) {
    _payments.removeWhere((payment) => payment.id == paymentId);
    updatePaymentsCount();
    notifyListeners();
  }

  int get paymentsCount => _payments.length;
}
