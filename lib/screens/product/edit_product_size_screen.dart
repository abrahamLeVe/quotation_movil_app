import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pract_01/models/product/product_model.dart' as product_model;
import 'package:pract_01/services/product_service.dart';

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
  final List<double?> _sizePrices = [];
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
    for (var size in widget.sizes) {
      final quotationPrice = size.attributes.quotationPrice;
      if (quotationPrice != null) {
        _sizePrices.add(quotationPrice.toDouble());
      } else {
        _sizePrices.add(null);
      }
    }
  }

  void _updateSizePrice(product_model.ProductSizesDatum size, String price) {
    final index = widget.sizes.indexWhere((s) => s.id == size.id);
    if (index >= 0) {
      setState(() {
        final newPrice = double.tryParse(price);
        _sizePrices[index] = newPrice;
        if (!_modifiedSizes.contains(size)) {
          _modifiedSizes.add(size);
        }
      });
    }
  }

  void _handleButtonPress(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text('Guardando cambios...'),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveChanges() async {
    _handleButtonPress(context);
    try {
      for (final size in _modifiedSizes) {
        final index = widget.sizes.indexOf(size);
        final newPrice = _sizePrices[index];
        if (newPrice != null) {
          size.attributes.quotationPrice = newPrice;
        }
      }

      for (final size in _modifiedSizes) {
        if (size.attributes.quotationPrice != null) {
          await ProductService().updateSize(
            size.id,
            size.attributes.quotationPrice,
          );
        }
      }

      if (context.mounted) {
        Navigator.pop(context); // Cerrar el modal de progreso

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Precios de medidas actualizados')),
        );

        setState(() {
          // Actualizar el estado para reflejar los cambios en la lista de tamaños
          _modifiedSizes.clear();
        });
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al actualizar los precios de medidas'),
          ),
        );
      }
    }
  }

  Future<bool> _showDiscardConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('¿Desea descartar los cambios?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Descartar'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Si el usuario intenta regresar sin guardar los cambios, mostrar un diálogo de confirmación
        if (_modifiedSizes.isNotEmpty) {
          final confirmDiscard = await _showDiscardConfirmationDialog();
          if (confirmDiscard) {
            return true; // Permitir regresar
          } else {
            return false; // Bloquear el regreso
          }
        }

        return true; // Permitir regresar si no hay cambios
      },
      child: Scaffold(
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
                  product.attributes.thumbnail.data.attributes.formats.thumbnail
                      .url,
                ),
              ),
              title: Text(product.attributes.name.toUpperCase()),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(size.attributes.val),
                  TextFormField(
                    initialValue:
                        size.attributes.quotationPrice?.toString() ?? '',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      priceFormatter
                    ], // Aplicar el formatter aquí
                    onChanged: (value) {
                      _updateSizePrice(size, value);
                    },
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveChanges,
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
