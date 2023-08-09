import 'package:flutter/material.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/services/quotation_service.dart';
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
    Function action, int quotationId) async {
  _handleButtonPress(context);

  try {
    await action();

    if (context.mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Operación completada')),
      );

      final quotationState =
          Provider.of<QuotationState>(context, listen: false);
      quotationState.removeQuotation(quotationId);

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

void deleteQuotation(BuildContext context, int quotationId) {
  _showConfirmationDialog(
    context,
    'Eliminar cotización permanentemente',
    '¿Estás seguro de eliminar esta Cotización de forma permanente?',
    () => _performAction(context, 'Eliminando cotización...', () async {
      await QuotationService(context: context).deleteQuotation(quotationId);
    }, quotationId),
  );
}

void archiveQuotation(BuildContext context, int quotationId) {
  _showConfirmationDialog(
    context,
    'Archivar cotización $quotationId',
    '¿Estás seguro de archivar esta cotización?',
    () => _performAction(context, 'Archivando cotización...', () async {
      await QuotationService(context: context).archiveQuotation(quotationId);
    }, quotationId),
  );
}
