import 'package:flutter/material.dart';
import 'package:pract_01/models/product/get_all_product_model.dart' as product_model;

import 'package:pract_01/screens/product/edit_product_size_screen.dart';
import 'package:pract_01/utils/currency_formatter.dart';

class ProductListScreen extends StatefulWidget {
  final List<product_model.Product> productList;
  final void Function(product_model.Product) openEditProductScreen;

  const ProductListScreen({
    Key? key,
    required this.productList,
    required this.openEditProductScreen,
  }) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late List<product_model.Product> filteredProducts;
  bool showProductsWithoutSizes = true;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    filteredProducts = widget.productList;
    _searchController = TextEditingController();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    final searchTerm = _searchController.text.toLowerCase();
    setState(() {
      filteredProducts = widget.productList.where((product) {
        final name = product.attributes.name.toLowerCase();
        final hasSizes = product.attributes.productSizes.data.isNotEmpty;

        if (showProductsWithoutSizes) {
          return name.contains(searchTerm);
        } else {
          return name.contains(searchTerm) && hasSizes;
        }
      }).toList();
    });
  }

  void _toggleShowProductsWithoutSizes(bool value) {
    setState(() {
      showProductsWithoutSizes = value;
      _filterProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: (_) => _filterProducts(),
          decoration: const InputDecoration(
            hintText: 'Buscar por nombre',
          ),
        ),
        actions: [
          Switch(
            value: showProductsWithoutSizes,
            onChanged: _toggleShowProductsWithoutSizes,
          ),
          const SizedBox(width: 8),
          const Text('Mostrar sin medidas'),
          const SizedBox(width: 16),
        ],
      ),
      body: filteredProducts.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
                itemCount: filteredProducts.length,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final product = filteredProducts[index];
                  final productSizes = product.attributes.productSizes.data;
                  final thumbnailUrl = product.attributes.thumbnail.data
                      ?.attributes.formats.thumbnail.url;
                  final imageWidget =
                      thumbnailUrl != null && thumbnailUrl.isNotEmpty
                          ? Image.network(thumbnailUrl)
                          : Image.asset('assets/sin_image.png');

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        backgroundImage: imageWidget.image,
                      ),
                      title: Text(product.attributes.name.toUpperCase()),
                      subtitle: Text(productSizes.isNotEmpty
                          ? 'Medidas: ${productSizes.length}'
                          : 'Precio: ${CurrencyFormatter.format(product.attributes.quotationPrice)}'),
                      trailing: GestureDetector(
                        onTap: () {
                          if (productSizes.isEmpty) {
                            widget.openEditProductScreen(product);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProductSizesScreen(
                                  product: product,
                                  sizes: productSizes,
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
              )

    );
  }
}
