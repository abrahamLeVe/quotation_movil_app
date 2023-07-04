import 'package:flutter/material.dart';
import 'package:pract_01/models/product_model.dart';
import 'package:pract_01/screens/edit_product_screen.dart';
import 'package:pract_01/screens/edit_product_size_screen.dart';

import 'package:pract_01/services/network_manager.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];

  bool isLoading = false;

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    final result = await NetworkManager().getAllProduct();
    products = result.data;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos (${products.length})'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: products.length,
              physics: const ScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      backgroundImage: NetworkImage(
                        products[index]
                            .attributes
                            .thumbnail
                            .data
                            .attributes
                            .formats
                            .thumbnail
                            .url,
                      ),
                    ),
                    title: Text(products[index].attributes.name.toUpperCase()),
                    subtitle: Text(products[index]
                            .attributes
                            .productSizes
                            .data
                            .isNotEmpty
                        ? 'Medidas: ${products[index].attributes.productSizes.data.length}'
                        : 'Precio: USD ${products[index].attributes.quotationPrice}'),
                    trailing: GestureDetector(
                      onTap: () {
                        if (products[index]
                            .attributes
                            .productSizes
                            .data
                            .isEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProductScreen(product: products[index]),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProductSizesScreen(
                                product: products[index],
                                sizes: products[index]
                                    .attributes
                                    .productSizes
                                    .data,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Icon(Icons.edit),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
