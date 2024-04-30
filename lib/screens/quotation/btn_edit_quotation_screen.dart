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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.amber,
                    size: 50,
                  ),
                ),
                Expanded(
                  child: Text(
                    content,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(
                height: 20), // Espacio entre el contenido y los botones
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700], // Color del botón No
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'No',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Color del botón Sí
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Sí',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
      Provider.of<QuotationState>(context, listen: false)
          .loadNewQuotations(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Operación completada')),
      );

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

void archiveQuotation(BuildContext context, int quotationId) {
  final updateQuotation = {
    "codeStatus": "Cancelada",
    "publishedAt": null,
    "id": quotationId,
  };

  final updateData = {'data': updateQuotation};
  _showConfirmationDialog(
    context,
    'Archivar cotización ID N° $quotationId',
    '¿Estás seguro de archivar esta cotización?', // Cambiar el mensaje aquí
    () => _performAction(context, 'Archivando cotización...', () async {
      await QuotationService(context: context)
          .updateQuotation(quotationId, updateData);
    }, quotationId),
  );
}
