import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pract_01/models/product/get_all_product_model.dart'
    as product_model;
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
    RegExp(r'^\d{1,9}(\.\d{0,2})?$'),
  );

  bool _isSaving = false; // Variable para rastrear si se está guardando

  @override
  void initState() {
    super.initState();
    _initializeSizePrices();
  }

  void _initializeSizePrices() {
    for (var size in widget.sizes) {
      final quotationPrice = size.attributes.quotationPrice;
      _sizePrices.add(quotationPrice.toDouble());
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

  // Función para mostrar el diálogo de advertencia
  Future<void> _showWarningDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Advertencia'),
          content: const Text(
            'Complete todos los campos de precio antes de guardar los cambios.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveChanges() async {
    if (_isSaving) return; // Evitar múltiples clics mientras se está guardando

    setState(() {
      _isSaving = true;
    });

    try {
      bool hasNullPrice =
          false; // Variable para rastrear si hay precios nulos o vacíos

      for (final size in _modifiedSizes) {
        final index = widget.sizes.indexOf(size);
        final newPrice = _sizePrices[index];

        if (newPrice == null || newPrice <= 0.0) {
          // Si el precio es nulo o menor o igual a cero
          hasNullPrice = true;
          break;
        } else {
          size.attributes.quotationPrice = newPrice;
        }
      }

      if (hasNullPrice) {
        // Mostrar el diálogo de advertencia si hay precios nulos o vacíos
        await _showWarningDialog();
      } else {
        // Realizar el proceso de guardar cambios
        for (final size in _modifiedSizes) {
          await ProductService().updateSize(
            size.id,
            size.attributes.quotationPrice,
          );
        }

        if (context.mounted) {
          // Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Precios de medidas actualizados')),
          );

          setState(() {
            _modifiedSizes.clear();
          });
        }
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al actualizar los precios de medidas'),
          ),
        );
      }
    } finally {
      if (context.mounted) {
        setState(() {
          _isSaving = false;
        });
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
    final thumbnailUrl = widget
        .product.attributes.thumbnail.data?.attributes.formats.thumbnail.url;
    final imageWidget = thumbnailUrl != null && thumbnailUrl.isNotEmpty
        ? Image.network(thumbnailUrl)
        : Image.asset('assets/sin_image.png');
    return WillPopScope(
      onWillPop: () async {
        if (_modifiedSizes.isNotEmpty) {
          final confirmDiscard = await _showDiscardConfirmationDialog();
          if (confirmDiscard) {
            return true;
          } else {
            return false;
          }
        }

        return true;
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
                backgroundImage: imageWidget.image,
              ),
              title: Text(product.attributes.name.toUpperCase()),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(size.attributes.val),
                  TextFormField(
                    initialValue: size.attributes.quotationPrice.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [priceFormatter],
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
          onPressed: _isSaving ? null : _saveChanges,
          child: _isSaving
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Icon(Icons.save),
        ),
      ),
    );
  }
}
