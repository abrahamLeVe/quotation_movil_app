import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart'
    as model_quotation;
import 'package:pract_01/models/quotation/post_quotation_model.dart'
    as post_quotation_model;
import 'package:pract_01/models/state/state_model.dart';
import 'package:pract_01/screens/quotation/quotation_actions.dart';
import 'package:pract_01/services/quotation_service.dart';
import 'package:pract_01/services/state_quotation_service.dart';
import 'package:pract_01/utils/error_handlers.dart';

class EditQuotationScreen extends StatefulWidget {
  final model_quotation.Quotation quotation;

  const EditQuotationScreen({
    Key? key,
    required this.quotation,
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
  bool _isSaved = false;
  bool _hasChanges = false;
  late StateModel _stateModel = StateModel(data: []);
  late DataState _selectedState = DataState(
      id: 0,
      attributes: Attributes(
          name: 'Estados',
          description: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          publishedAt: DateTime.now(),
          code: ''));

  late int _initialStateId;

  @override
  void initState() {
    super.initState();
    // _selectedState = DataState(id: 0, attributes: Attributes(name: ''));
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
        _initialStateId = widget.quotation.attributes.state.data.id;
        final defaultState =
            _stateModel.data.firstWhere((state) => state.id == defaultStateId);
        setState(() {
          _selectedState = defaultState;
        });
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error cargando estados: $error');
      }
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
    bool stateChanged =
        _selectedState.id != widget.quotation.attributes.state.data.id;

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

    // Mostrar mensaje si ha guardado con éxito y preguntar si desea guardar
    final shouldSave = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cotización actualizada'),
        content: const Text(
          'La cotización se ha actualizado. ¿Deseas guardar los cambios?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Guardar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );

    try {
      if (!shouldSave) {
        return;
      }
    } catch (e) {}

    setState(() => _isSaving = true);

    try {
      final List<int> changedProductIds = [];
      final List<post_quotation_model.Product> updatedProducts = [];

// Verificar si hay cambios en los precios de los productos y construir la lista de productos actualizados
      for (int i = 0; i < widget.quotation.attributes.products.length; i++) {
        final originalProduct = _originalQuotation.attributes.products[i];
        final newPrice = double.parse(priceControllers[i][0].text);

        if (newPrice != originalProduct.value) {
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

      if (_selectedState.attributes!.name == 'En progreso') {
        final updateQuotation = post_quotation_model.UpdateQuotationAtributes(
          products: updatedProducts,
          notes: '',
          codeStatus: 'Completada',
          state: 4,
          email: widget.quotation.attributes.email,
          id: widget.quotation.id,
          userId: widget.quotation.attributes.user.data.id,
        );
        final updateData = {'data': updateQuotation.toJson()};
        if (mounted) {
          await QuotationService(context: context)
              .updateQuotation(widget.quotation.id, updateData);
        }
        if (mounted) {
          updatePricesInBackground(context, changedProductIds, updatedProducts,
              () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Precios actualizados con éxito')),
            );
          });
        }
      } else {
        if (_hasChanges || stateChanged) {
          final updateQuotation = post_quotation_model.UpdateQuotationAtributes(
            products: updatedProducts,
            notes: '',
            codeStatus: _selectedState.attributes!.name,
            state: _selectedState.id,
            email: widget.quotation.attributes.email,
            id: widget.quotation.id,
            userId: widget.quotation.attributes.user.data.id,
          );

          final updateData = {'data': updateQuotation.toJson()};
          if (mounted) {
            await QuotationService(context: context)
                .updateQuotation(widget.quotation.id, updateData);
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No hay cambios para guardar')),
            );
          }
          return;
        }
      }
      setState(() => _isSaved = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cotización actualizada con éxito')),
        );
        await updateQuotationsCache(context, _initialStateId);
      }
    } catch (error) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      showAuthenticationErrorDialog(context, error);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error no se pudo actualizar')),
      );
      setState(() => _isSaved = false);
    } finally {
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
              builder: (context) => AlertDialog(
                title: const Text('¿Descartar cambios?'),
                content: const Text(
                    'Hay cambios no guardados. ¿Deseas descartarlos?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Restablecer los controladores de precios
                      for (final controllerList in priceControllers) {
                        controllerList[0].text = _originalQuotation
                            .attributes
                            .products[priceControllers.indexOf(controllerList)]
                            .value
                            .toString();
                      }
                      // Restablecer el estado seleccionado
                      if (_stateModel.data.isNotEmpty) {
                        final defaultState = _stateModel.data.firstWhere(
                            (state) => state.id == _initialStateId,
                            orElse: () => _stateModel.data.first);
                        setState(() {
                          _selectedState = defaultState;
                        });
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
              ),
            );

            return shouldDiscard;
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16.0),
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
            floatingActionButton: _isSaved
                ? FloatingActionButton(
                    onPressed: () {
                      // Aquí puedes agregar el código para mostrar el mensaje de "Ya se envió"
                      // o realizar cualquier otra acción necesaria
                    },
                    child: const Icon(Icons.check),
                  )
                : FloatingActionButton(
                    onPressed: _isSaving ? null : _saveQuotationChanges,
                    child: _isSaving
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.save),
                  ),
          ),
        ));
  }

  Widget _buildStateDropdown() {
    // Verificar si la cotización está en progreso
    final isInProgress = _selectedState.attributes!.name == 'En progreso';
    List<DataState> filteredStates = _stateModel.data
        .where((state) =>
            state.attributes!.name != 'En progreso' &&
            state.attributes!.name != 'Vencido')
        .toList();

    if (_stateModel.data.isEmpty || isInProgress) {
      // Si no hay datos de estado o la cotización está en progreso, mostrar el texto del estado
      if (!_isSaved) {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.orange,
              ),
              SizedBox(width: 8.0),
              Text(
                "Estado: En progreso",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      } else {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                Icons.check_circle_outline_outlined,
                color: Colors.green,
              ),
              SizedBox(width: 8.0),
              Text(
                "Estado: Completado",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }
    }
    //select
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<DataState>(
        value: _selectedState,
        items: filteredStates
            .map((state) => DropdownMenuItem<DataState>(
                  value: state,
                  child: Text(state.attributes!.name),
                ))
            .toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedState = newValue!;
            _hasChanges =
                true; // Actualiza _hasChanges cuando se selecciona un nuevo estado
          });
          // Aquí puedes realizar otras acciones según la selección del estado si es necesario
        },
        decoration: const InputDecoration(
          labelText: 'Seleccionar estado para esta cotización',
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
                if (widget.quotation.attributes.details != null)
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
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Container(
        decoration: BoxDecoration(color: Colors.amber[50]),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              product.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87),
            ),
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
                        LengthLimitingTextInputFormatter(7),
                      ],
                      onChanged: (_) => _checkForChanges(),
                      enabled: _selectedState.attributes!.name ==
                          'En progreso', // Solo se habilita la edición si el estado es "En Progreso"
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
