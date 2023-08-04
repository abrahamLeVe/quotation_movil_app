import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pract_01/models/product/get_all_product_model.dart'
    as product_model;
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
  bool _changesSaved = true;

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
    if (!_changesSaved) {
      final String priceText = _priceController.text;
      if (priceText.isEmpty || double.tryParse(priceText) == null) {
        // Mostrar advertencia si el precio es nulo o no es un número válido
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Advertencia'),
              content: const Text(
                  'Ingrese un precio válido antes de guardar los cambios.'),
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
        return; // Detener el proceso de guardar los cambios
      }

      setState(() {
        _isLoading = true;
      });

      double newPrice = double.parse(priceText);

      showLoadingDialog(context);

      try {
        await ProductService().updateProduct(widget.product.id, newPrice);

        if (context.mounted) {
          widget.onProductUpdated(widget.product);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Producto actualizado')),
          );
          setState(() {
            _changesSaved = true;
          });
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sin cambios que guardar')),
      );
    }
  }

  Future<bool> _showDiscardConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Descartar cambios'),
              content: const Text('¿Estás seguro de descartar los cambios?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
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
    return WillPopScope(
      onWillPop: () async {
        if (!_changesSaved) {
          final confirmDiscard = await _showDiscardConfirmationDialog();
          return confirmDiscard;
        }

        return true;
      },
      child: Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    widget.product.attributes.name.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                   CachedNetworkImage(
                    imageUrl: thumbnailUrl ?? '',
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) {
                      if (thumbnailUrl == null) {
                        
                        return Column(
                          children: [
                            Image.asset('assets/error_image.png'),
                          ],
                        );
                      } else if (error is HttpException) {
                        
                        return Column(
                          children: [
                            Image.asset('assets/error_image.png'),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Image.asset('assets/error_image.png'),
                          ],
                        );
                      }
                    },
                  ),
              
                  const SizedBox(height: 16),
                  const Text('Precio de cotización'),
                  TextFormField(
                    textAlign: TextAlign.center,
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d{1,9}(\.\d{0,2})?$'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _changesSaved = false;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        (_isLoading || _changesSaved) ? null : updateProduct,
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
