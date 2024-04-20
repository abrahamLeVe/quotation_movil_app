import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pract_01/models/payment/get_all_payment.dart';
import 'package:pract_01/models/state/state_model.dart';
import 'package:pract_01/providers/payment_state.dart';
import 'package:pract_01/services/messaging/messaging_service.dart';
import 'package:pract_01/widgets/payment/payment_list_item.dart';
import 'package:provider/provider.dart' as provider;

class PaymentListScreen extends StatefulWidget {
  final List<Payment> paymentList;

  const PaymentListScreen({
    Key? key,
    required this.paymentList,
  }) : super(key: key);
  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  List<Payment> filtersPayments = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  final MessagingService _messagingService = MessagingService();
  StreamSubscription<void>? _subscription;
  late PaymentState paymentState;
  List<DataState> paymentStates = [];
  DataState? selectedPaymentState;

  void filterPayments(List<Payment> payments) {
    final String searchText = searchController.text.toUpperCase();
    if (searchText.isNotEmpty) {
      // Filtrar adicionalmente por el texto de búsqueda
      filtersPayments = payments.where((payment) {
        final String code = payment.attributes.cotizacion.data!.id.toString();
        return code.contains(searchText);
      }).toList();
    } else {
      filtersPayments = List.from(
          payments); // Mostrar todos los pagos si no hay texto de búsqueda
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    final paymentState =
        provider.Provider.of<PaymentState>(context, listen: false);
    _subscription = _messagingService.onPaymentsUpdated.listen((_) {
      setState(() {
        filtersPayments = paymentState.payments;
      });
    });

    // Escuchar el Stream para actualizaciones de cotizaciones debido a notificaciones
    _subscription = _messagingService.onPaymentsUpdated.listen((_) {
      // Llamar a un método para resetear el estado seleccionado y recargar las cotizaciones
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        provider.Provider.of<PaymentState>(context,
                            listen: false);
                        filtersPayments;
                      });
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Permitir solo dígitos
                    ],
                    keyboardType:
                        TextInputType.number, // Mostrar teclado numérico
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por código',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator()) // Mostrar spinner
            : provider.Consumer<PaymentState>(
                builder: (context, paymentState, _) {
                  final payments = paymentState.payments;

                  filterPayments(payments);

                  if (paymentState.isNewNotificationAvailable()) {
                    filterPayments(paymentState.payments);
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filtersPayments.length,
                          itemBuilder: (BuildContext context, int index) {
                            final payment = filtersPayments[index];
                            return PaymentItem(
                              payment: payment,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
