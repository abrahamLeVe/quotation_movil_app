import 'package:flutter/material.dart';
import 'package:pract_01/models/product_model.dart' as product_model;
import 'package:pract_01/screens/product_list_screen.dart';
import 'package:pract_01/services/network_manager.dart';
import 'package:flutter/services.dart';
import 'package:pract_01/utils/dialog_utils.dart';

class EditProductScreen extends StatefulWidget {
  final product_model.Product product;

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final priceFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'^\d{1,6}(\.\d{0,2})?$'),
  );
  final TextEditingController _priceController = TextEditingController();
  bool _isLoading = false;
  void _handleButtonPress(BuildContext context) {
    showLoadingDialog(context); // Mostrar el diálogo de carga
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.attributes.name;
    _priceController.text = widget.product.attributes.quotationPrice.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void updateProduct() async {
    setState(() {
      _isLoading = true;
    });

    double newPrice = double.tryParse(_priceController.text) ?? 0.0;

    _handleButtonPress(context);

    try {
      await NetworkManager().updateProduct(widget.product.id, newPrice);

      if (context.mounted) {
        Navigator.pop(context); // Cerrar el modal de progreso

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto actualizado')),
        );

        Navigator.pop(context); // Volver a la pantalla anterior
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProductListScreen()),
        ); // Navegar a la pantalla de lista de productos y actualizarla
      }
    } catch (error) {
      if (context.mounted) {
        Navigator.pop(context); // Cerrar el modal de progreso

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

  void deleteProduct() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Producto'),
          content: const Text('¿Estás seguro de eliminar este producto?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Respuesta negativa: No
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Respuesta positiva: Sí
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed != null && confirmed) {
        performDeleteAction();
      }
    });
  }

  void performDeleteAction() async {
    _handleButtonPress(context);

    try {
      await NetworkManager().deleteProduct(widget.product.id);

      if (context.mounted) {
        Navigator.pop(context); // Cerrar el modal de progreso

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto eliminado')),
        );

        Navigator.pop(context); // Volver a la pantalla anterior
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProductListScreen()),
        ); // Navegar a la pantalla de lista de productos y actualizarla
      }
    } catch (error) {
      if (context.mounted) {
        Navigator.pop(context); // Cerrar el modal de progreso

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el producto')),
        );

        Navigator.pop(context); // Volver a la pantalla anterior
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProductListScreen()),
        ); // Navegar a la pantalla de lista de productos y actualizarla
      }
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
            Text(
              'Categorías: ${widget.product.attributes.categories.data.map((category) => category.attributes.name).join(", ")}',
              style: const TextStyle(fontSize: 18),
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
              inputFormatters: [priceFormatter],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : updateProduct,
              child: const Text('Guardar'),
            ),
            // const SizedBox(height: 8),
            // ElevatedButton(

            //   onPressed: deleteProduct,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.red,
            //   ),
            //   child: const Text('Eliminar'),
            // ),
          ],
        ),
      ),
    );
  }
}
