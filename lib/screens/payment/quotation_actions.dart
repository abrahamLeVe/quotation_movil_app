import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/services/product_service.dart';
import 'package:pract_01/services/quotation_service.dart';
import 'package:pract_01/utils/dialog_utils.dart';
import 'package:pract_01/utils/error_handlers.dart';
import 'package:provider/provider.dart';
import 'package:pract_01/models/quotation/post_quotation_model.dart'
    as post_quotation_model;

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Operación completada')),
      );

      final quotationState =
          Provider.of<QuotationState>(context, listen: false);
      quotationState.removeQuotation(quotationId);
      QuotationService(context: context).removeCachedQuotation(quotationId);
      Navigator.pushReplacementNamed(context, '/home');
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

Future<void> updateQuotationsInBackground(BuildContext context) async {
  List<Quotation> updatedQuotations = [];
  print('empezo el segundo plano');

  await Future.delayed(Duration.zero, () async {
    final response =
        await QuotationService(context: context).getAllQuotation(1);
    updatedQuotations = response.data;
  });
  // Actualizar la caché en segundo plano
  await Future(() async {
    await QuotationService(context: context).cacheQuotations(updatedQuotations);
  });

  // Actualizar el estado global en segundo plano
  await Future(() async {
    final quotationState = Provider.of<QuotationState>(context, listen: false);
    quotationState.setQuotations(updatedQuotations);
  });
  print('terminó el segundo plano');
}

Future<void> updateQuotationsCache(BuildContext context, int idState) async {
  List<Quotation> updatedQuotations = [];
  print('Actualizando cotizaciones...');

  try {
    // Obtener las cotizaciones para el estado específico
    final response =
        await QuotationService(context: context).getAllQuotation(idState);
    updatedQuotations = response.data;

    // Actualizar la caché
    await Future(() async {
      await QuotationService(context: context)
          .cacheQuotations(updatedQuotations);
    });

    // Actualizar el estado global
    await Future(() async {
      final quotationState =
          Provider.of<QuotationState>(context, listen: false);
      quotationState.setQuotations(updatedQuotations);
    });

    print('Cotizaciones actualizadas con éxito.');
  } catch (error) {
    print('Error al actualizar las cotizaciones: $error');
  }
}

Future<void> updatePricesInBackground(
    BuildContext context,
    List<int> changedProductIds,
    List<post_quotation_model.Product> updatedProducts,
    Function() onCompletion) async {
  print('empezó el segundo plano updatePricesInBackground');

  // Esto asegura que el código se ejecute en el próximo ciclo del event loop,
  // lo que permite que el await funcione dentro del Future.delayed.
  await Future.delayed(Duration.zero, () async {
    for (final changedProductId in changedProductIds) {
      // Encuentra el producto actualizado basado en el ID
      final updatedProduct = updatedProducts.firstWhere(
        (product) => product.id == changedProductId,
      );
      // Si encontramos un producto, actualizamos su precio
      final updateData = {
        'data': {'value': updatedProduct.value}
      };
      try {
        await ProductService(context: context)
            .updatePrice(changedProductId, updateData);
      } catch (e) {
        print(
            'Error actualizando precio del producto ID $changedProductId: $e');
      }
    }
    // Llama a onCompletion si el contexto aún está montado
    if (context.mounted) {
      onCompletion();
    }
  });

  print('terminó el segundo plano updatePricesInBackground');
}
