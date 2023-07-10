import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pract_01/models/product/product_model.dart' as product_model;
import 'package:pract_01/services/product_service.dart';
import 'package:pract_01/utils/dialog_utils.dart';

class EditProductScreen extends StatefulWidget {
  final product_model.Product product;
  final Function(product_model.Product) onProductUpdated;

  const EditProductScreen({
    Key? key,
    required this.product,
    required this.onProductUpdated,
  }) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController _priceController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _priceController.text = widget.product.attributes.quotationPrice.toString();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void updateProduct() async {
    setState(() {
      _isLoading = true;
    });

    double newPrice = double.tryParse(_priceController.text) ?? 0.0;

    showLoadingDialog(context);

    try {
      await ProductService().updateProduct(widget.product.id, newPrice);

      if (context.mounted) {
        widget.onProductUpdated(widget.product);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto actualizado')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar el producto')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              widget.product.attributes.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Image.network(
              widget.product.attributes.thumbnail.data.attributes.formats
                  .thumbnail.url,
              width: 156,
              height: 156,
            ),
            const SizedBox(height: 16),
            const Text('Precio de cotización'),
            TextFormField(
              textAlign: TextAlign.center,
              controller: _priceController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d{1,6}(\.\d{0,2})?$'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : updateProduct,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
