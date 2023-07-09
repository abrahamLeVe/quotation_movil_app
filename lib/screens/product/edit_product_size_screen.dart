import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pract_01/models/product/product_model.dart' as product_model;
import 'package:pract_01/screens/product/list_product_screen.dart';
import 'package:pract_01/services/product_service.dart';
import 'package:pract_01/utils/dialog_utils.dart';

class EditProductSizesScreen extends StatefulWidget {
  final product_model.Product product;
  final List<product_model.ProductSizesDatum> sizes;

  const EditProductSizesScreen({
    Key? key,
    required this.product,
    required this.sizes,
  }) : super(key: key);

  @override
  State<EditProductSizesScreen> createState() => _EditProductSizesScreenState();
}

class _EditProductSizesScreenState extends State<EditProductSizesScreen> {
  final List<double> _sizePrices = [];
  final List<product_model.ProductSizesDatum> _modifiedSizes = [];
  final priceFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'^\d{1,6}(\.\d{0,2})?$'),
  );
  @override
  void initState() {
    super.initState();
    _initializeSizePrices();
  }

  void _initializeSizePrices() {
    // Inicializar los precios de las medidas con los valores actuales del producto
    for (var size in widget.sizes) {
      final quotationPrice = size.attributes.quotationPrice;
      if (quotationPrice != null) {
        _sizePrices.add(quotationPrice.toDouble());
      }
    }
  }

  void _updateSizePrice(product_model.ProductSizesDatum size, double price) {
    final index = widget.sizes.indexWhere((s) => s.id == size.id);
    if (index >= 0) {
      setState(() {
        _sizePrices[index] = price;
        if (!_modifiedSizes.contains(size)) {
          _modifiedSizes.add(size);
        }
      });
    }
  }

  void _handleButtonPress(BuildContext context) {
    showLoadingDialog(context); // Mostrar el diálogo de carga
  }

  Future<void> _saveChanges() async {
    _handleButtonPress(context);
    try {
      for (final size in _modifiedSizes) {
        final index = widget.sizes.indexOf(size);
        final newPrice = _sizePrices[index];
        await ProductService().updateSize(size.id, newPrice);
      }
      if (context.mounted) {
        Navigator.pop(context); // Cerrar el modal de progreso

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Precios de medidas actualizados')),
        );

        Navigator.pop(context); // Volver a la pantalla anterior
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProductListScreen()),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error al actualizar los precios de medidas')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar medidas (${widget.sizes.length})'),
      ),
      body: ListView.builder(
        itemCount: widget.sizes.length,
        itemBuilder: (context, index) {
          final size = widget.sizes[index];
          final product = widget.product;

          return ListTile(
            key: Key(size.id.toString()),
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              backgroundImage: NetworkImage(
                product
                    .attributes.thumbnail.data.attributes.formats.thumbnail.url,
              ),
            ),
            title: Text(product.attributes.name.toUpperCase()),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(size.attributes.val),
                TextFormField(
                  initialValue: size.attributes.quotationPrice.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    priceFormatter
                  ], // Aplicar el formatter aquí
                  onChanged: (value) {
                    double newPrice = double.tryParse(value) ?? 0.0;
                    _updateSizePrice(size, newPrice);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveChanges();
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
