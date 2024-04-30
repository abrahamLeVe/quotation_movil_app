import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pract_01/models/price/get_all_prices_model.dart';
import 'package:pract_01/providers/price_state.dart';
import 'package:pract_01/services/product_service.dart';
import 'package:pract_01/utils/error_handlers.dart';
import 'package:pract_01/widgets/product/prices_invoice.dart';
import 'package:provider/provider.dart' as provider;

class PriceListScreen extends StatefulWidget {
  const PriceListScreen({Key? key}) : super(key: key);

  @override
  State<PriceListScreen> createState() => _PriceListScreenState();
}

class _PriceListScreenState extends State<PriceListScreen> {
  TextEditingController searchController = TextEditingController();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final products = provider.Provider.of<PriceState>(context).fullprices;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  provider.Provider.of<PriceState>(context, listen: false)
                      .filterPrices(value);
                },
                decoration: InputDecoration(
                  labelText: 'Buscar por nombre',
                  labelStyle: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14, // Reducido para que ocupe menos espacio
                  ),
                  prefixIcon: const Icon(Icons.search,
                      color: Colors.white70, size: 20), // Icono más pequeño
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal:
                          10), // Padding ajustado para reducir la altura
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white24),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  isDense:
                      true, // Mantiene la densidad para reducir aún más el espacio
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14, // Coincide con el tamaño de la etiqueta
                ),
              ),
            ),
            const SizedBox(
                width: 10), // Espacio entre el campo de búsqueda y el botón
            IconButton(
              icon: const Icon(Icons.cloud_download,
                  color: Colors.white70,
                  size: 24), // Icono ligeramente más pequeño
              onPressed: () {
                downloadProductInventori(context, products);
              },
              tooltip: 'Descargar factura',
            ),
          ],
        ),
        backgroundColor: Colors.blueGrey,
        elevation: 4.0, // Elevación de la AppBar para darle sombra
        shadowColor: Colors.black45, // Color de la sombra
      ),
      body: provider.Consumer<PriceState>(
        builder: (context, priceState, _) {
          final filteredPrices = priceState.fullprices;

          return filteredPrices.isEmpty
              ? const Center(
                  child: Text('No hay cotizaciones disponibles'),
                )
              : ListView.builder(
                  itemCount: filteredPrices.length,
                  itemBuilder: (BuildContext context, int index) {
                    final price = filteredPrices[index];
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: Image.network(
                              price.attributes.thumbnail.data.attributes.formats
                                  .thumbnail.url,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                            ),
                            title: Text(price.attributes.name),
                            subtitle: Text(price.attributes.description),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                if (price.attributes.brand.data != null)
                                  Text(
                                      'Marca: ${price.attributes.brand.data?.attributes.name}'),
                                ...price.attributes.prices.data
                                    .map((priceDetail) => InkWell(
                                          onTap: () => _showEditPriceDialog(
                                              context,
                                              priceDetail,
                                              handleUpdatePrice),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'Precio: ${priceDetail.attributes.value.toStringAsFixed(2)}'),
                                                  Text(
                                                      'Medida: ${priceDetail.attributes.size.data?.attributes.name ?? "No especificado"}'),
                                                  Wrap(
                                                    children: priceDetail
                                                        .attributes
                                                        .productColors
                                                        .data
                                                        .map((color) => Chip(
                                                              label: Text(color
                                                                  .attributes
                                                                  .name),
                                                            ))
                                                        .toList(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  Future<void> handleUpdatePrice(int priceId, double newPrice) async {
    setState(() {
      _isSaving = true; // Activa el spinner antes de iniciar la operación
    });
    Map<String, dynamic> data = {
      "value": newPrice,
    };
    final updateData = {'data': data};
    try {
      await ProductService(context: context).updatePrice(priceId, updateData);
      if (mounted) {
        provider.Provider.of<PriceState>(context, listen: false)
            .loadFullPrices(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Operación completada')),
        );
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }

      if (mounted) {
        showAuthenticationErrorDialog(context, error);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al realizar la operación')),
        );
      }
    } finally {
      setState(() {
        _isSaving =
            false; // Desactiva el spinner una vez finalizada la operación
      });
    }
  }

  void _showEditPriceDialog(BuildContext context, PricesDatum priceDetail,
      Function(int, double) onUpdate) {
    TextEditingController priceController =
        TextEditingController(text: priceDetail.attributes.value.toString());

    showDialog(
      context: context,
      barrierDismissible: !_isSaving,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar Precio"),
          content: TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              LengthLimitingTextInputFormatter(7),
            ],
            decoration:
                const InputDecoration(hintText: "Ingrese el nuevo precio"),
          ),
          actions: <Widget>[
            if (_isSaving)
              const CircularProgressIndicator(), // Muestra el spinner si está guardando
            if (!_isSaving) ...[
              TextButton(
                child: const Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Guardar"),
                onPressed: () {
                  double? newPrice = double.tryParse(priceController.text);
                  if (newPrice != null) {
                    onUpdate(priceDetail.id, newPrice);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Ingrese un precio válido.")));
                  }
                },
              ),
            ],
          ],
        );
      },
    );
  }
}
