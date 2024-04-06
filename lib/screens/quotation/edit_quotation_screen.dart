import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart'
    as model_quotation;
import 'package:pract_01/models/quotation/post_quotation_model.dart'
    as post_quotation_model;
import 'package:pract_01/models/state/state_model.dart';
import 'package:pract_01/screens/quotation/quotation_actions.dart';
import 'package:pract_01/services/product_service.dart';
import 'package:pract_01/services/quotation_service.dart';
import 'package:pract_01/services/state_service.dart';
import 'package:pract_01/utils/error_handlers.dart';

class EditQuotationScreen extends StatefulWidget {
  final model_quotation.Quotation quotation;
  final void Function(model_quotation.Quotation) onQuotationUpdated;

  const EditQuotationScreen({
    Key? key,
    required this.quotation,
    required this.onQuotationUpdated,
  }) : super(key: key);

  @override
  State<EditQuotationScreen> createState() => _EditQuotationScreenState();
}

class _EditQuotationScreenState extends State<EditQuotationScreen> {
  late model_quotation.Quotation _originalQuotation;
  late List<List<double>> originalPrices;
  late List<List<TextEditingController>> priceControllers;
  bool _isClientInfoExpanded = false;
  bool _isSaving = false;
  bool _hasChanges = false;
  late StateModel _stateModel = StateModel(data: []);
  late DataState _selectedState;

  @override
  void initState() {
    super.initState();
    _originalQuotation = widget.quotation;
    originalPrices = widget.quotation.attributes.products
        .map((product) => [product.value])
        .toList();

    priceControllers = widget.quotation.attributes.products.map((product) {
      final controller = TextEditingController(
        text: product.value.toString(),
      );
      controller.addListener(_handlePriceChange);
      return [controller];
    }).toList();

    // Inicializar el estado por defecto como el primer estado de la lista
    if (_stateModel.data.isNotEmpty) {
      _selectedState = _stateModel.data.first;
    }

    _loadStates();
  }

  void _loadStates() async {
    try {
      final stateService = StateService(context: context);
      final stateModel = await stateService.getState();
      setState(() {
        _stateModel = stateModel;
      });

      // Establecer el estado por defecto de la cotización en el dropdown
      if (_stateModel.data.isNotEmpty) {
        final defaultStateId = widget.quotation.attributes.state.data.id;
        final defaultState =
            _stateModel.data.firstWhere((state) => state.id == defaultStateId);
        setState(() {
          _selectedState = defaultState;
        });
      }
    } catch (error) {
      print('Error cargando estados: $error');
    }
  }

  void _handlePriceChange() {
    bool hasChanges = false;
    for (int i = 0; i < widget.quotation.attributes.products.length; i++) {
      final originalProduct = _originalQuotation.attributes.products[i];
      final newValue = double.tryParse(priceControllers[i][0].text) ?? 0.0;
      if (newValue != originalProduct.value) {
        hasChanges = true;
        break;
      }
    }
    setState(() {
      _hasChanges = hasChanges;
    });
  }

  void _saveQuotationChanges() async {
    bool hasEmptyPrice = false;
    bool hasChanges = _hasChanges;

    // Verificar si hay campos de precio vacíos o mal formateados
    for (final controllerList in priceControllers) {
      for (final controller in controllerList) {
        if (controller.text.isEmpty ||
            double.tryParse(controller.text) == null) {
          hasEmptyPrice = true;
          break;
        }
      }
      if (hasEmptyPrice) {
        break;
      }
    }

    // Si hay campos de precio vacíos o mal formateados, mostrar mensaje y salir de la función
    if (hasEmptyPrice) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Precios incorrectos'),
          content: const Text(
            'Por favor, completa todos los precios con valores numéricos válidos antes de guardar.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      setState(() => _isSaving = true);

      final List<int> changedProductIds = [];
      final List<post_quotation_model.Product> updatedProducts = [];

      // Verificar si hay cambios en los precios de los productos y construir la lista de productos actualizados
      for (int i = 0; i < widget.quotation.attributes.products.length; i++) {
        final originalProduct = _originalQuotation.attributes.products[i];
        final newPrice = double.parse(priceControllers[i][0].text);

        if (newPrice != originalProduct.value) {
          hasChanges = true;
          changedProductIds.add(originalProduct.id);
        }

        updatedProducts.add(post_quotation_model.Product(
          id: originalProduct.id,
          title: originalProduct.title,
          size: originalProduct.size,
          quantity: originalProduct.quantity,
          value: newPrice,
          colors: originalProduct.colors
              .map((color) => post_quotation_model.Color(
                    id: color.id,
                    color: post_quotation_model.ColorClass(
                      id: color.color.id,
                      attributes: post_quotation_model.ColorAttributes(
                        code: color.color.attributes.code,
                        name: color.color.attributes.name,
                        createdAt: color.color.attributes.createdAt,
                        updatedAt: color.color.attributes.updatedAt,
                        description: color.color.attributes.description,
                        publishedAt: color.color.attributes.publishedAt,
                      ),
                    ),
                    quantity: color.quantity,
                  ))
              .toList(),
          discount: originalProduct.discount,
          pictureUrl: originalProduct.pictureUrl,
          slug: originalProduct.slug,
        ));
      }

      if (!hasChanges) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay cambios para guardar')),
        );
        setState(() => _isSaving = false);
        return;
      }

      final updateQuotation = post_quotation_model.UpdateQuotationAtributes(
        products: updatedProducts,
        notes: '',
        codeStatus: _selectedState.attributes.name,
        state: _selectedState.id,
      );

      final updateData = {'data': updateQuotation.toJson()};
      await QuotationService(context: context)
          .updateQuotation(widget.quotation.id, updateData);

      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;

      updateQuotationsInBackground(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cotización actualizada con éxito')),
      );

      for (final changedProductId in changedProductIds) {
        final updatedProduct =
            updatedProducts.firstWhere((p) => p.id == changedProductId);
        final updateData = {
          'data': {'value': updatedProduct.value}
        };
        await ProductService(context: context)
            .updatePrice(changedProductId, updateData);
      }

      setState(() {
        _isSaving = false;
        _hasChanges = false;
      });
    } catch (error) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      showAuthenticationErrorDialog(context, error);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error no se pudo actualizar')),
      );
      setState(() {
        _isSaving = false;
        _hasChanges = false;
      });
    }
  }

  void _checkForChanges() {
    bool hasChanges = false;
    for (int i = 0; i < widget.quotation.attributes.products.length; i++) {
      final originalProduct = _originalQuotation.attributes.products[i];
      final newValue = double.tryParse(priceControllers[i][0].text) ?? 0.0;
      if (originalProduct.value != newValue) {
        hasChanges = true;
        break;
      }
    }
    setState(() {
      _hasChanges = hasChanges;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _hasChanges ? false : true,
      onPopInvoked: (_) async {
        if (_hasChanges) {
          final shouldDiscard = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('¿Descartar cambios?'),
                content: const Text(
                    'Hay cambios no guardados. ¿Deseas descartarlos?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      for (final controllerList in priceControllers) {
                        controllerList[0].text = _originalQuotation
                            .attributes
                            .products[priceControllers.indexOf(controllerList)]
                            .value
                            .toString();
                      }
                      _hasChanges = false;
                      Navigator.pop(context, true);
                    },
                    child: const Text('Descartar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Cancelar'),
                  ),
                ],
              );
            },
          );

          return shouldDiscard;
        } else {}
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Editar Cotización N° ${widget.quotation.id}'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildClientInfoAccordion(),
              _buildStateDropdown(), // Nuevo: Agregar el dropdown de estados
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.quotation.attributes.products.length,
                itemBuilder: (context, index) => _buildProductCard(index),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _isSaving || !_hasChanges ? null : _saveQuotationChanges,
          child: _isSaving
              ? const CircularProgressIndicator()
              : const Icon(Icons.save),
        ),
      ),
    );
  }

  Widget _buildStateDropdown() {
    if (_stateModel.data.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<DataState>(
        value: _selectedState,
        items: _stateModel.data
            .map((state) => DropdownMenuItem<DataState>(
                  value: state,
                  child: Text(state.attributes.name),
                ))
            .toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedState = newValue!;
            _hasChanges = true;
          });
          // Aquí puedes realizar otras acciones según la selección del estado si es necesario
        },
        decoration: const InputDecoration(
          labelText: 'Estado',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildClientInfoAccordion() {
    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isClientInfoExpanded = !_isClientInfoExpanded;
        });
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(
              title: Text('Información del Cliente'),
            );
          },
          body: ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre: ${widget.quotation.attributes.name}'),
                Text('Teléfono: ${widget.quotation.attributes.phone}'),
                Text('Email: ${widget.quotation.attributes.email}'),
                Text(
                    'Tipo de documento: ${widget.quotation.attributes.tipeDoc}'),
                Text(
                    'Numero de ${widget.quotation.attributes.tipeDoc}: ${widget.quotation.attributes.numDoc}'),
                Text(
                    'Departamento: ${widget.quotation.attributes.location.departamento}'),
                Text(
                    'Provincia: ${widget.quotation.attributes.location.provincia}'),
                Text(
                    'Distrito: ${widget.quotation.attributes.location.distrito}'),
                Text('Mensaje: ${widget.quotation.attributes.details}'),
              ],
            ),
          ),
          isExpanded: _isClientInfoExpanded,
        ),
      ],
    );
  }

  Widget _buildProductCard(int index) {
    final product = widget.quotation.attributes.products[index];
    final controller = priceControllers[index][0];
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(product.title),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cantidad: ${product.quantity}'),
                if (product.size != null) Text('Medida: ${product.size}'),
                if (product.colors.isNotEmpty) ...[
                  const Text(
                    'Colores:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Table(
                    border: TableBorder.all(),
                    children: [
                      for (var color in product.colors)
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                margin: const EdgeInsets.all(4.0),
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(int.parse(
                                      '0xFF${color.color.attributes.code.substring(1)}')),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(color.color.attributes.name),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Cantidad: ${color.quantity}'),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Precio general:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                          LengthLimitingTextInputFormatter(12),
                        ],
                        onChanged: (_) => _checkForChanges(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
