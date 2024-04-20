import 'package:flutter/material.dart';
import 'package:pract_01/providers/payment_state.dart';
import 'package:pract_01/services/payment_service.dart';
import 'package:pract_01/utils/dialog_utils.dart';
import 'package:pract_01/utils/error_handlers.dart';
import 'package:provider/provider.dart';

void _handleButtonPress(BuildContext context) {
  showLoadingDialog(context);
}

void _showConfirmationDialog(
    BuildContext context, String title, String content, Function onConfirmed) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Sí'),
          ),
        ],
      );
    },
  ).then((confirmed) {
    if (confirmed != null && confirmed) {
      onConfirmed();
    }
  });
}

Future<void> _performAction(BuildContext context, String loadingText,
    Function action, int paymentId) async {
  _handleButtonPress(context);

  try {
    await action();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Operación completada')),
      );

      final paymentState = Provider.of<PaymentState>(context, listen: false);
      paymentState.removePayment(paymentId);
      PaymentService(context: context).removeCachedPayment(paymentId);
      Navigator.pop(context);
    }
  } catch (error) {
    if (context.mounted) {
      showAuthenticationErrorDialog(context, error);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al realizar la operación')),
      );

      Navigator.pop(context);
    }
  }
}

void archivePayment(BuildContext context, int paymentId, int quoId) {
  _showConfirmationDialog(
    context,
    'Archivar pago $quoId',
    '¿Estás seguro de archivar este pago?',
    () => _performAction(context, 'Archivando pago...', () async {
      await PaymentService(context: context).archivePayments(paymentId);
    }, paymentId),
  );
}
