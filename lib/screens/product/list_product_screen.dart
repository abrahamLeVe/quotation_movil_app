import 'package:flutter/material.dart';
import 'package:pract_01/providers/product_state.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductState>(context).fullproducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Productos'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            child: ListTile(
              leading: Image.network(
                product
                    .attributes.thumbnail.data.attributes.formats.thumbnail.url,
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
              title: Text(product.attributes.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Precios: ${product.attributes.prices.data.map((e) => e.attributes.value).join(", ")}'),
                  Text(
                    'Colores: ${product.attributes.productColors.data.isNotEmpty ? product.attributes.productColors.data.map((e) => e.attributes.name).join(", ") : "No especificado"}',
                  ),
                  Text(
                    'Medida: ${product.attributes.sizes.data.isNotEmpty ? product.attributes.sizes.data.map((e) => e.attributes.name).join(", ") : "No especificado"}',
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
