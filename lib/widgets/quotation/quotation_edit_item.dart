import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart'
    as model_quotation;

class QuotationEditItem extends StatelessWidget {
  final model_quotation.Product product;
  final int productIndex;
  final List<model_quotation.Product> products;
  final void Function(int, int, double) onPriceUpdate;

  const QuotationEditItem({
    Key? key,
    required this.product,
    required this.productIndex,
    required this.products,
    required this.onPriceUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tamaño: ${size.val}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Precio: ${size.quotationPrice}'),
                            const SizedBox(width: 8),
                            Text('Cantidad: ${size.quantity}'),
                            const SizedBox(width: 8),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Modificar precio'),
                                  content: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Nuevo precio',
                                    ),
                                    onChanged: (value) {
                                      onPriceUpdate(
                                        productIndex,
                                        sizeIndex,
                                        double.parse(value),
                                      );
                                    },
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
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Aceptar'),
                                    ),
                                  ],
                                );
                              },
                            );
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Precio: ${product.quotationPrice}'),
                      const SizedBox(width: 8),
                      Text('Cantidad: ${product.quantity}'),
                      const SizedBox(width: 8),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Modificar precio'),
                            content: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Nuevo precio',
                              ),
                              onChanged: (value) {
                                onPriceUpdate(
                                  productIndex,
                                  -1,
                                  double.parse(value),
                                );
                              },
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
                                  Navigator.pop(context);
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          );
                        },
                      );
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
