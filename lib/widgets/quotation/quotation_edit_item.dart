import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart'
    as model_quotation;
import 'package:flutter/services.dart';
import 'package:pract_01/utils/currency_formatter.dart';

class QuotationEditItem extends StatelessWidget {
  final model_quotation.Product product;
  final int productIndex;
  final List<model_quotation.Product> products;
  final void Function(
    int productIndex,
    int sizeIndex,
    double newPrice,
    List<model_quotation.Product> updatedProducts,
  ) onPriceUpdate;

  const QuotationEditItem({
    Key? key,
    required this.product,
    required this.productIndex,
    required this.products,
    required this.onPriceUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final copiedProducts = List<model_quotation.Product>.from(products);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (product.size.isNotEmpty)
              ...product.size.asMap().entries.map((entry) {
                final sizeIndex = entry.key;
                final size = entry.value;
                final TextEditingController priceController =
                    TextEditingController();
                priceController.text = size.quotationPrice.toString();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tamaño: ${size.val}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Precio: ${CurrencyFormatter.format(size.quotationPrice as double)}',
                              ),
                              const SizedBox(width: 8),
                              Text('Cantidad: ${size.quantity}'),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final newPrice = await showPriceAlertDialog(
                                context, priceController);
                            if (newPrice != null) {
                              onPriceUpdate(productIndex, sizeIndex, newPrice,
                                  copiedProducts);
                            }
                          },
                          child: const Text('Modificar precio'),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            if (product.size.isEmpty)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Precio: ${CurrencyFormatter.format(product.quotationPrice as double)}',
                        ),
                        const SizedBox(width: 8),
                        Text('Cantidad: ${product.quantity}'),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final TextEditingController priceController0 =
                          TextEditingController();
                      priceController0.text = product.quotationPrice.toString();
                      final newPrice =
                          await showPriceAlertDialog(context, priceController0);

                      if (newPrice != null) {
                        onPriceUpdate(
                          productIndex,
                          -1,
                          newPrice,
                          copiedProducts,
                        );
                      }
                    },
                    child: const Text('Modificar precio'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

Future<double?> showPriceAlertDialog(
    BuildContext context, TextEditingController priceController) async {
  return showDialog<double?>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: AlertDialog(
          title: const Text('Modificar precio'),
          content: Container(
            padding: const EdgeInsets.all(8.0), // Ajusta el espaciado aquí
            child: TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
                LengthLimitingTextInputFormatter(9),
              ],
              decoration: const InputDecoration(
                labelText: 'Nuevo precio',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final newPrice = double.tryParse(priceController.text);
                if (newPrice != null) {
                  Navigator.pop(context, newPrice);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('El valor ingresado no es válido.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    },
  );
}
