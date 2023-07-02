import 'package:flutter/material.dart';
import 'package:pract_01/models/product_model.dart';
import 'package:pract_01/screens/edit_product_screen.dart';
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Producto"),
        actions: const [],
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
                            .url,
                      ),
                    ),
                    title: Text(products[index].attributes.name),
                    subtitle: Text(products[index].attributes.quotationPrice !=
                            null
                        ? 'Precio: USD ${products[index].attributes.quotationPrice}'
                        : 'Medidas: ${products[index].attributes.productSizes.data.length}'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const EditProductScreen(), // Reemplaza 'EditProductScreen' con el nombre de la pantalla de edición de productos
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
