import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart';
import 'package:pract_01/providers/quotation_state.dart';
import 'package:pract_01/services/product_service.dart';
import 'package:pract_01/services/quotation_service.dart';

import 'package:provider/provider.dart';
import 'package:pract_01/models/quotation/post_quotation_model.dart'
    as post_quotation_model;

Future<void> updateQuotationsInBackground(BuildContext context) async {
  List<Quotation> updatedQuotations = [];
  print('empezo el segundo plano quotation');

  await Future.delayed(Duration.zero, () async {
    final response =
        await QuotationService(context: context).getAllQuotation(1);
    updatedQuotations = response.data;
  });
  await Future(() async {
    await QuotationService(context: context).cacheQuotations(updatedQuotations);
  });

  await Future(() async {
    final quotationState = Provider.of<QuotationState>(context, listen: false);
    quotationState.setQuotations(updatedQuotations);
  });
  print('terminó el segundo plano quotation');
}

Future<void> updateQuotationsCache(BuildContext context, int idState) async {
  List<Quotation> updatedQuotations = [];
  print('Actualizando cotizaciones...');

  try {
    final response =
        await QuotationService(context: context).getAllQuotation(idState);
    updatedQuotations = response.data;

    await Future(() async {
      await QuotationService(context: context)
          .cacheQuotations(updatedQuotations);
    });

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

  await Future.delayed(Duration.zero, () async {
    for (final changedProductId in changedProductIds) {
      final updatedProduct = updatedProducts.firstWhere(
        (product) => product.id == changedProductId,
      );
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
    if (context.mounted) {
      onCompletion();
    }
  });

  print('terminó el segundo plano updatePricesInBackground');
}
